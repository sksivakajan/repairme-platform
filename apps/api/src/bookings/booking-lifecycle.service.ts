import {
  ConflictException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import type {
  BookingStatus,
  Prisma,
} from '../generated/prisma/client.js';
import { canTransition } from './booking-status.js';

export interface TransitionOptions {
  actorUserId?: string;
  note?: string;
  /** Extra booking fields to update together with the status. */
  data?: Prisma.BookingUncheckedUpdateManyInput;
}

/**
 * Applies status changes. The update is conditional on the current status,
 * so two concurrent actions on the same booking cannot both succeed.
 */
@Injectable()
export class BookingLifecycleService {
  async transition(
    tx: Prisma.TransactionClient,
    bookingId: string,
    to: BookingStatus,
    options: TransitionOptions = {},
  ): Promise<void> {
    const booking = await tx.booking.findUnique({
      where: { id: bookingId },
      select: { status: true },
    });
    if (!booking) throw new NotFoundException('Booking not found');
    if (!canTransition(booking.status, to)) {
      throw new ConflictException(
        `Booking cannot move from ${booking.status} to ${to}`,
      );
    }

    const { count } = await tx.booking.updateMany({
      where: { id: bookingId, status: booking.status },
      data: { ...options.data, status: to },
    });
    if (count !== 1) {
      throw new ConflictException(
        'The booking was updated by someone else, please refresh',
      );
    }

    await tx.bookingEvent.create({
      data: {
        bookingId,
        status: to,
        note: options.note,
        actorUserId: options.actorUserId,
      },
    });
  }
}
