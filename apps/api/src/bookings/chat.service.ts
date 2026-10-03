import { ConflictException, Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service.js';
import { loadAsParticipant } from './booking-access.js';
import { CHAT_OPEN, formatReference } from './booking-status.js';

@Injectable()
export class ChatService {
  constructor(private readonly prisma: PrismaService) {}

  /** Returns the conversation and marks the other party's messages as read. */
  async list(userId: string, bookingId: string) {
    await loadAsParticipant(this.prisma, bookingId, userId);

    await this.prisma.chatMessage.updateMany({
      where: { bookingId, senderId: { not: userId }, readAt: null },
      data: { readAt: new Date() },
    });
    const messages = await this.prisma.chatMessage.findMany({
      where: { bookingId },
      orderBy: { createdAt: 'asc' },
      take: 500,
      select: { id: true, senderId: true, body: true, readAt: true, createdAt: true },
    });
    return messages.map(({ senderId, ...message }) => ({
      ...message,
      mine: senderId === userId,
    }));
  }

  /** One conversation per booking that has a technician, newest activity first. */
  async conversations(userId: string, customerId: string) {
    const bookings = await this.prisma.booking.findMany({
      where: { customerId, technicianId: { not: null } },
      orderBy: { createdAt: 'desc' },
      take: 50,
      select: {
        id: true,
        referenceNumber: true,
        status: true,
        createdAt: true,
        category: { select: { name: true, iconKey: true } },
        problemType: { select: { name: true } },
        technician: { select: { displayName: true } },
        messages: {
          orderBy: { createdAt: 'desc' },
          take: 1,
          select: { body: true, senderId: true, createdAt: true },
        },
      },
    });
    if (bookings.length === 0) return [];

    const unread = await this.prisma.chatMessage.groupBy({
      by: ['bookingId'],
      where: {
        bookingId: { in: bookings.map((booking) => booking.id) },
        senderId: { not: userId },
        readAt: null,
      },
      _count: { _all: true },
    });
    const unreadByBooking = new Map(
      unread.map((row) => [row.bookingId, row._count._all]),
    );

    return bookings
      .map((booking) => {
        const last = booking.messages[0] ?? null;
        return {
          bookingId: booking.id,
          reference: formatReference(booking.referenceNumber),
          title: booking.problemType?.name ?? booking.category.name,
          categoryIcon: booking.category.iconKey,
          status: booking.status,
          technicianName: booking.technician?.displayName ?? 'Technician',
          chatOpen: CHAT_OPEN.includes(booking.status),
          lastMessage: last && {
            body: last.body,
            mine: last.senderId === userId,
            createdAt: last.createdAt,
          },
          unreadCount: unreadByBooking.get(booking.id) ?? 0,
          lastActivityAt: last?.createdAt ?? booking.createdAt,
        };
      })
      .sort((a, b) => b.lastActivityAt.getTime() - a.lastActivityAt.getTime());
  }

  async send(userId: string, bookingId: string, body: string) {
    const { booking } = await loadAsParticipant(this.prisma, bookingId, userId);
    if (!booking.technician || !CHAT_OPEN.includes(booking.status)) {
      throw new ConflictException('Chat is not available for this booking');
    }
    const message = await this.prisma.chatMessage.create({
      data: { bookingId, senderId: userId, body: body.trim() },
      select: { id: true, body: true, readAt: true, createdAt: true },
    });
    return { ...message, mine: true };
  }
}
