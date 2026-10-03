import { NotFoundException } from '@nestjs/common';
import type { PrismaService } from '../database/prisma.service.js';

export type Participant = 'CUSTOMER' | 'TECHNICIAN';

/**
 * Loads a booking and works out whether the user is its customer or its
 * assigned technician. Anyone else gets a 404 so booking IDs cannot be probed.
 */
export async function loadAsParticipant(
  prisma: PrismaService,
  bookingId: string,
  userId: string,
) {
  const booking = await prisma.booking.findUnique({
    where: { id: bookingId },
    select: {
      id: true,
      status: true,
      customer: { select: { userId: true } },
      technician: { select: { userId: true } },
    },
  });
  if (!booking) throw new NotFoundException('Booking not found');

  let participant: Participant;
  if (booking.customer.userId === userId) participant = 'CUSTOMER';
  else if (booking.technician?.userId === userId) participant = 'TECHNICIAN';
  else throw new NotFoundException('Booking not found');

  return { booking, participant };
}
