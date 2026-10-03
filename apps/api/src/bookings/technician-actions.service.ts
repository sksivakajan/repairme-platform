import {
  BadRequestException,
  ConflictException,
  ForbiddenException,
  Injectable,
  NotFoundException,
  UnprocessableEntityException,
} from '@nestjs/common';
import { timingSafeEqual } from 'node:crypto';
import { PrismaService } from '../database/prisma.service.js';
import { NotificationsService } from '../notifications/notifications.service.js';
import { BookingLifecycleService } from './booking-lifecycle.service.js';
import { formatLkr, formatReference } from './booking-status.js';
import { SendQuotationDto } from './booking.dto.js';

const DEFAULT_EMERGENCY_ETA_MINUTES = 18;

/**
 * Actions taken by a technician (or the operations team) on a booking.
 * Used by the development simulator today and by the technician app later.
 */
@Injectable()
export class TechnicianActionsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly lifecycle: BookingLifecycleService,
    private readonly notifications: NotificationsService,
  ) {}

  /** No technician accepted in time: hand the request to the operations team. */
  async escalateToOperator(bookingId: string): Promise<void> {
    const booking = await this.load(bookingId);
    await this.prisma.$transaction(async (tx) => {
      await this.lifecycle.transition(tx, bookingId, 'OPERATOR_ASSIGNING', {
        note: 'No technician accepted yet; RepairMe team is assigning',
      });
      await this.notifications.create(
        {
          userId: booking.customer.userId,
          bookingId,
          title: 'Our team is finding someone for you',
          body: 'No technician accepted yet, so a RepairMe operator is assigning one. Usually under 2 minutes.',
        },
        tx,
      );
    });
  }

  async assign(
    bookingId: string,
    technicianId: string,
    actorUserId?: string,
  ): Promise<void> {
    const booking = await this.load(bookingId);
    const technician = await this.prisma.technician.findFirst({
      where: {
        id: technicianId,
        status: 'VERIFIED',
        categories: { some: { categoryId: booking.categoryId } },
      },
    });
    if (!technician) {
      throw new UnprocessableEntityException(
        'Technician is not verified for this service',
      );
    }

    await this.prisma.$transaction(async (tx) => {
      await this.lifecycle.transition(tx, bookingId, 'ASSIGNED', {
        actorUserId: actorUserId ?? technician.userId,
        note: `${technician.displayName} accepted`,
        data: {
          technicianId,
          etaMinutes:
            booking.type === 'EMERGENCY' ? DEFAULT_EMERGENCY_ETA_MINUTES : null,
        },
      });
      await this.notifications.create(
        {
          userId: booking.customer.userId,
          bookingId,
          title: 'Technician assigned',
          body: `${technician.displayName} · Verified ${booking.category.name.toLowerCase()} technician`,
        },
        tx,
      );
    });
  }

  async startTravel(
    technicianId: string,
    bookingId: string,
    etaMinutes: number,
  ): Promise<void> {
    const booking = await this.loadAssigned(technicianId, bookingId);
    await this.prisma.$transaction(async (tx) => {
      await this.lifecycle.transition(tx, bookingId, 'EN_ROUTE', {
        actorUserId: booking.technician.userId,
        data: { etaMinutes },
      });
      await this.notifications.create(
        {
          userId: booking.customer.userId,
          bookingId,
          title: `${booking.technician.displayName} is on the way`,
          body: `Arrives in about ${etaMinutes} min.`,
        },
        tx,
      );
    });
  }

  /** The customer tells the technician the job code; a match proves arrival. */
  async arrive(
    technicianId: string,
    bookingId: string,
    jobCode: string,
  ): Promise<void> {
    const booking = await this.loadAssigned(technicianId, bookingId);
    const expected = Buffer.from(booking.jobCode);
    const given = Buffer.from(jobCode);
    if (expected.length !== given.length || !timingSafeEqual(expected, given)) {
      throw new UnprocessableEntityException('Job code does not match');
    }

    await this.prisma.$transaction(async (tx) => {
      await this.lifecycle.transition(tx, bookingId, 'ARRIVED', {
        actorUserId: booking.technician.userId,
        note: 'Job code verified',
        data: { etaMinutes: null },
      });
      await this.notifications.create(
        {
          userId: booking.customer.userId,
          bookingId,
          title: `${booking.technician.displayName} has arrived`,
          body: 'Job code verified. Inspection has started.',
        },
        tx,
      );
    });
  }

  async sendQuotation(
    technicianId: string,
    bookingId: string,
    dto: SendQuotationDto,
  ): Promise<void> {
    const booking = await this.loadAssigned(technicianId, bookingId);
    if (booking.status !== 'ARRIVED' && booking.status !== 'IN_PROGRESS') {
      throw new ConflictException('A cost can only be sent while on site');
    }

    const partsCents = dto.items.reduce(
      (sum, item) => sum + item.quantity * item.unitPriceCents,
      0,
    );
    const totalCents = booking.visitFeeCents + dto.labourCents + partsCents;

    await this.prisma.$transaction(async (tx) => {
      const latest = await tx.quotation.findFirst({
        where: { bookingId },
        orderBy: { version: 'desc' },
        select: { version: true },
      });
      await tx.quotation.updateMany({
        where: { bookingId, status: { in: ['PENDING', 'APPROVED'] } },
        data: { status: 'SUPERSEDED' },
      });
      await tx.quotation.create({
        data: {
          bookingId,
          version: (latest?.version ?? 0) + 1,
          note: dto.note?.trim(),
          visitFeeCents: booking.visitFeeCents,
          labourCents: dto.labourCents,
          partsCents,
          totalCents,
          items: { create: dto.items },
        },
      });
      await this.lifecycle.transition(tx, bookingId, 'AWAITING_APPROVAL', {
        actorUserId: booking.technician.userId,
        note: `Cost sent · ${formatLkr(totalCents)}`,
      });
      await this.notifications.create(
        {
          userId: booking.customer.userId,
          bookingId,
          title: 'Cost ready for approval',
          body: `${booking.technician.displayName} sent ${formatLkr(totalCents)} for ${formatReference(booking.referenceNumber)}.`,
        },
        tx,
      );
    });
  }

  /**
   * Finishes the job. From IN_PROGRESS the approved cost is due; from ARRIVED
   * (cost declined or nothing to fix) only the visit fee is due.
   */
  async complete(technicianId: string, bookingId: string): Promise<void> {
    const booking = await this.loadAssigned(technicianId, bookingId);
    let amountCents = booking.visitFeeCents;
    if (booking.status === 'IN_PROGRESS') {
      const approved = await this.prisma.quotation.findFirst({
        where: { bookingId, status: 'APPROVED' },
        orderBy: { version: 'desc' },
      });
      if (!approved) throw new ConflictException('No approved cost found');
      amountCents = approved.totalCents;
    }

    await this.prisma.$transaction(async (tx) => {
      await this.lifecycle.transition(tx, bookingId, 'COMPLETED', {
        actorUserId: booking.technician.userId,
        note: `Repair completed · ${formatLkr(amountCents)} due`,
      });
      await tx.payment.create({
        data: { bookingId, method: booking.paymentMethod, amountCents },
      });
      await tx.technician.update({
        where: { id: technicianId },
        data: { jobsCompleted: { increment: 1 } },
      });
      await this.notifications.create(
        {
          userId: booking.customer.userId,
          bookingId,
          title: 'Repair completed',
          body: `Please pay ${formatLkr(amountCents)} to ${booking.technician.displayName}.`,
        },
        tx,
      );
    });
  }

  async confirmCashPayment(technicianId: string, bookingId: string): Promise<void> {
    const booking = await this.loadAssigned(technicianId, bookingId);
    const payment = await this.prisma.payment.findUnique({ where: { bookingId } });
    if (booking.status !== 'COMPLETED' || !payment) {
      throw new ConflictException('This booking is not awaiting payment');
    }
    if (payment.method !== 'CASH') {
      throw new BadRequestException('Only cash payments are confirmed by the technician');
    }

    await this.prisma.$transaction(async (tx) => {
      await tx.payment.update({
        where: { bookingId },
        data: { status: 'PAID', paidAt: new Date() },
      });
      await this.lifecycle.transition(tx, bookingId, 'PAID', {
        actorUserId: booking.technician.userId,
        note: `${formatLkr(payment.amountCents)} paid in cash`,
      });
      await this.notifications.create(
        {
          userId: booking.customer.userId,
          bookingId,
          title: 'Receipt ready',
          body: `${formatLkr(payment.amountCents)} paid in cash for ${formatReference(booking.referenceNumber)}.`,
        },
        tx,
      );
    });
  }

  private async load(bookingId: string) {
    const booking = await this.prisma.booking.findUnique({
      where: { id: bookingId },
      include: {
        customer: { select: { userId: true } },
        category: { select: { name: true } },
        technician: { select: { id: true, userId: true, displayName: true } },
      },
    });
    if (!booking) throw new NotFoundException('Booking not found');
    return booking;
  }

  private async loadAssigned(technicianId: string, bookingId: string) {
    const booking = await this.load(bookingId);
    if (!booking.technician || booking.technician.id !== technicianId) {
      throw new ForbiddenException('This job is not assigned to you');
    }
    return { ...booking, technician: booking.technician };
  }
}
