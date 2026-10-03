import { ConflictException, Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service.js';
import { loadAsParticipant } from './booking-access.js';
import { CHAT_OPEN } from './booking-status.js';

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
