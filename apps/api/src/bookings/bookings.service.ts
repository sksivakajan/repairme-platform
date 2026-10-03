import {
  BadRequestException,
  ConflictException,
  Injectable,
  NotFoundException,
  UnprocessableEntityException,
} from '@nestjs/common';
import { randomInt } from 'node:crypto';
import type { AuthUser } from '../auth/auth-user.js';
import { PrismaService } from '../database/prisma.service.js';
import type { Prisma } from '../generated/prisma/client.js';
import { NotificationsService } from '../notifications/notifications.service.js';
import { BookingLifecycleService } from './booking-lifecycle.service.js';
import {
  BOOKING_TABS,
  CUSTOMER_CANCELLABLE,
  formatLkr,
  formatReference,
  type BookingTab,
} from './booking-status.js';
import {
  bookingDetailInclude,
  bookingDetailView,
  bookingSummaryInclude,
  bookingSummaryView,
} from './booking.view.js';
import {
  CancelBookingDto,
  CreateBookingDto,
  CreateReviewDto,
  PayBookingDto,
} from './booking.dto.js';

const MAX_ACTIVE_BOOKINGS = 5;
const MAX_WINDOW_HOURS = 4;
const MAX_DAYS_AHEAD = 60;
const ENABLED_PAYMENT_METHODS = ['CASH'] as const;

@Injectable()
export class BookingsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly lifecycle: BookingLifecycleService,
    private readonly notifications: NotificationsService,
  ) {}

  async create(user: AuthUser, customerId: string, dto: CreateBookingDto) {
    const category = await this.prisma.serviceCategory.findFirst({
      where: { id: dto.categoryId, isActive: true },
    });
    if (!category) throw new BadRequestException('Unknown service category');

    if (dto.problemTypeId) {
      const problemType = await this.prisma.problemType.findFirst({
        where: { id: dto.problemTypeId, categoryId: category.id, isActive: true },
      });
      if (!problemType) {
        throw new BadRequestException('Problem type does not match the service');
      }
    }

    const schedule = this.validateSchedule(dto);
    const paymentMethod = dto.paymentMethod ?? 'CASH';
    if (!(ENABLED_PAYMENT_METHODS as readonly string[]).includes(paymentMethod)) {
      throw new UnprocessableEntityException(
        'Only cash payment is available at the moment',
      );
    }

    const activeCount = await this.prisma.booking.count({
      where: { customerId, status: { in: [...BOOKING_TABS.active] } },
    });
    if (activeCount >= MAX_ACTIVE_BOOKINGS) {
      throw new ConflictException(
        `You can have at most ${MAX_ACTIVE_BOOKINGS} active bookings`,
      );
    }

    const bookingId = await this.prisma.$transaction(async (tx) => {
      const address = await this.resolveAddress(tx, customerId, dto);

      const booking = await tx.booking.create({
        data: {
          customerId,
          categoryId: category.id,
          problemTypeId: dto.problemTypeId,
          addressId: address.id,
          type: dto.type,
          description: dto.description.trim(),
          symptoms: dto.symptoms ?? [],
          addressLine1: address.line1,
          addressArea: address.area,
          addressCity: address.city,
          houseNumber: address.houseNumber,
          landmark: address.landmark,
          latitude: address.latitude,
          longitude: address.longitude,
          scheduledStart: schedule?.start,
          scheduledEnd: schedule?.end,
          paymentMethod,
          visitFeeCents: category.visitFeeCents,
          jobCode: String(randomInt(0, 10_000)).padStart(4, '0'),
        },
      });
      await tx.bookingEvent.create({
        data: { bookingId: booking.id, status: 'SEARCHING', actorUserId: user.userId },
      });
      await this.notifications.create(
        {
          userId: user.userId,
          bookingId: booking.id,
          title: 'Request received',
          body: `We are finding a verified ${category.name.toLowerCase()} technician for ${formatReference(booking.referenceNumber)}.`,
        },
        tx,
      );
      return booking.id;
    });

    return this.get(user, customerId, bookingId);
  }

  async list(customerId: string, tab: BookingTab = 'active') {
    const bookings = await this.prisma.booking.findMany({
      where: { customerId, status: { in: [...BOOKING_TABS[tab]] } },
      orderBy: { createdAt: 'desc' },
      take: 100,
      include: bookingSummaryInclude,
    });
    return bookings.map(bookingSummaryView);
  }

  async get(user: AuthUser, customerId: string, bookingId: string) {
    const booking = await this.prisma.booking.findFirst({
      where: { id: bookingId, customerId },
      include: bookingDetailInclude,
    });
    if (!booking) throw new NotFoundException('Booking not found');

    const unreadMessages = await this.prisma.chatMessage.count({
      where: { bookingId, readAt: null, senderId: { not: user.userId } },
    });
    return bookingDetailView(booking, unreadMessages);
  }

  async cancel(
    user: AuthUser,
    customerId: string,
    bookingId: string,
    dto: CancelBookingDto,
  ) {
    const booking = await this.findOwned(customerId, bookingId);
    if (!CUSTOMER_CANCELLABLE.includes(booking.status)) {
      throw new ConflictException(
        'This booking can no longer be cancelled in the app. Please contact support.',
      );
    }

    const reason = dto.details ? `${dto.reason}: ${dto.details.trim()}` : dto.reason;
    await this.prisma.$transaction(async (tx) => {
      await this.lifecycle.transition(tx, bookingId, 'CANCELLED', {
        actorUserId: user.userId,
        note: 'Cancelled by customer',
        data: { cancelledBy: 'CUSTOMER', cancelReason: reason },
      });
      await this.notifications.create(
        {
          userId: user.userId,
          bookingId,
          title: 'Booking cancelled',
          body: `${formatReference(booking.referenceNumber)} was cancelled. No charge was made.`,
        },
        tx,
      );
      if (booking.technician) {
        await this.notifications.create(
          {
            userId: booking.technician.userId,
            bookingId,
            title: 'Job cancelled by customer',
            body: `${formatReference(booking.referenceNumber)} was cancelled.`,
          },
          tx,
        );
      }
    });
    return this.get(user, customerId, bookingId);
  }

  async decideQuotation(
    user: AuthUser,
    customerId: string,
    bookingId: string,
    quotationId: string,
    approve: boolean,
  ) {
    const booking = await this.findOwned(customerId, bookingId);
    const quotation = await this.prisma.quotation.findFirst({
      where: { id: quotationId, bookingId, status: 'PENDING' },
    });
    if (!quotation || booking.status !== 'AWAITING_APPROVAL') {
      throw new ConflictException('There is no cost waiting for your approval');
    }

    await this.prisma.$transaction(async (tx) => {
      const { count } = await tx.quotation.updateMany({
        where: { id: quotation.id, status: 'PENDING' },
        data: {
          status: approve ? 'APPROVED' : 'DECLINED',
          decidedAt: new Date(),
        },
      });
      if (count !== 1) throw new ConflictException('This cost was already answered');

      await this.lifecycle.transition(
        tx,
        bookingId,
        approve ? 'IN_PROGRESS' : 'ARRIVED',
        {
          actorUserId: user.userId,
          note: approve
            ? `Cost approved · ${formatLkr(quotation.totalCents)}`
            : 'Cost declined',
        },
      );
      await this.notifications.create(
        {
          userId: user.userId,
          bookingId,
          title: approve ? 'Cost approved. Work continues' : 'Cost declined',
          body: approve
            ? `${formatLkr(quotation.totalCents)} · ${booking.technician?.displayName ?? 'Your technician'} is continuing the work.`
            : 'Your technician has been told. Only the visit fee applies if no work is done.',
        },
        tx,
      );
      if (booking.technician) {
        await this.notifications.create(
          {
            userId: booking.technician.userId,
            bookingId,
            title: approve ? 'Cost approved' : 'Cost declined',
            body: `${formatReference(booking.referenceNumber)} · ${formatLkr(quotation.totalCents)}`,
          },
          tx,
        );
      }
    });
    return this.get(user, customerId, bookingId);
  }

  async choosePaymentMethod(
    user: AuthUser,
    customerId: string,
    bookingId: string,
    dto: PayBookingDto,
  ) {
    const booking = await this.findOwned(customerId, bookingId);
    if (booking.status !== 'COMPLETED' || !booking.payment) {
      throw new ConflictException('This booking is not ready for payment');
    }
    if (!(ENABLED_PAYMENT_METHODS as readonly string[]).includes(dto.method)) {
      throw new UnprocessableEntityException(
        'Card and wallet payments are coming soon. Please pay in cash.',
      );
    }
    // Cash is confirmed by the technician on receipt, which marks it paid.
    await this.prisma.$transaction([
      this.prisma.payment.update({
        where: { bookingId },
        data: { method: dto.method },
      }),
      this.prisma.booking.update({
        where: { id: bookingId },
        data: { paymentMethod: dto.method },
      }),
    ]);
    return this.get(user, customerId, bookingId);
  }

  async review(
    user: AuthUser,
    customerId: string,
    bookingId: string,
    dto: CreateReviewDto,
  ) {
    const booking = await this.findOwned(customerId, bookingId);
    if (booking.status !== 'PAID' || !booking.technician) {
      throw new ConflictException('You can rate a job after it is paid');
    }
    const technicianId = booking.technician.id;

    await this.prisma.$transaction(async (tx) => {
      const existing = await tx.review.findUnique({ where: { bookingId } });
      if (existing) throw new ConflictException('You already rated this job');

      await tx.review.create({
        data: {
          bookingId,
          customerId,
          technicianId,
          rating: dto.rating,
          tags: [...new Set(dto.tags ?? [])],
          comment: dto.comment?.trim(),
        },
      });
      await tx.technician.update({
        where: { id: technicianId },
        data: {
          ratingSum: { increment: dto.rating },
          ratingCount: { increment: 1 },
        },
      });
    });
    return this.get(user, customerId, bookingId);
  }

  /** Loads a booking owned by the customer, or 404. */
  async findOwned(customerId: string, bookingId: string) {
    const booking = await this.prisma.booking.findFirst({
      where: { id: bookingId, customerId },
      include: {
        technician: { select: { id: true, userId: true, displayName: true } },
        payment: true,
      },
    });
    if (!booking) throw new NotFoundException('Booking not found');
    return booking;
  }

  private validateSchedule(dto: CreateBookingDto) {
    const hasWindow = dto.scheduledStart !== undefined || dto.scheduledEnd !== undefined;

    if (dto.type === 'EMERGENCY') {
      if (hasWindow) {
        throw new BadRequestException('Emergency bookings cannot be scheduled');
      }
      return null;
    }
    if (!hasWindow) {
      if (dto.type === 'SCHEDULED') {
        throw new BadRequestException('Choose a date and arrival window');
      }
      return null;
    }
    if (!dto.scheduledStart || !dto.scheduledEnd) {
      throw new BadRequestException('Both window start and end are required');
    }

    const start = new Date(dto.scheduledStart);
    const end = new Date(dto.scheduledEnd);
    const now = Date.now();
    if (start.getTime() <= now) {
      throw new BadRequestException('The arrival window must be in the future');
    }
    if (end <= start || end.getTime() - start.getTime() > MAX_WINDOW_HOURS * 3_600_000) {
      throw new BadRequestException(
        `The arrival window must end after it starts and last at most ${MAX_WINDOW_HOURS} hours`,
      );
    }
    if (start.getTime() - now > MAX_DAYS_AHEAD * 86_400_000) {
      throw new BadRequestException(
        `Bookings can be made at most ${MAX_DAYS_AHEAD} days ahead`,
      );
    }
    return { start, end };
  }

  private async resolveAddress(
    tx: Prisma.TransactionClient,
    customerId: string,
    dto: CreateBookingDto,
  ) {
    if (dto.addressId) {
      const saved = await tx.address.findFirst({
        where: { id: dto.addressId, customerId },
      });
      if (!saved) throw new BadRequestException('Address not found');
      return saved;
    }
    if (!dto.address) {
      throw new BadRequestException('An address is required');
    }
    if (dto.saveAddress) {
      const isFirst = (await tx.address.count({ where: { customerId } })) === 0;
      return tx.address.create({
        data: {
          ...dto.address,
          customerId,
          label: dto.addressLabel ?? 'HOME',
          isDefault: isFirst,
        },
      });
    }
    return {
      id: undefined,
      line1: dto.address.line1,
      area: dto.address.area,
      city: dto.address.city,
      houseNumber: dto.address.houseNumber ?? null,
      landmark: dto.address.landmark ?? null,
      latitude: dto.address.latitude ?? null,
      longitude: dto.address.longitude ?? null,
    };
  }
}
