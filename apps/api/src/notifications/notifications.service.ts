import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service.js';
import type { Prisma } from '../generated/prisma/client.js';

export interface NotificationInput {
  userId: string;
  bookingId?: string;
  title: string;
  body: string;
}

@Injectable()
export class NotificationsService {
  constructor(private readonly prisma: PrismaService) {}

  /**
   * Stores an in-app notification. Push delivery (FCM) will hook in here.
   * Pass a transaction client to create it atomically with the change it reports.
   */
  async create(
    input: NotificationInput,
    tx: Prisma.TransactionClient = this.prisma,
  ): Promise<void> {
    await tx.notification.create({ data: input });
  }

  list(userId: string) {
    return this.prisma.notification.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
      take: 100,
      select: {
        id: true,
        bookingId: true,
        title: true,
        body: true,
        readAt: true,
        createdAt: true,
      },
    });
  }

  async markRead(userId: string, id: string): Promise<void> {
    await this.prisma.notification.updateMany({
      where: { id, userId, readAt: null },
      data: { readAt: new Date() },
    });
  }

  async markAllRead(userId: string): Promise<void> {
    await this.prisma.notification.updateMany({
      where: { userId, readAt: null },
      data: { readAt: new Date() },
    });
  }
}
