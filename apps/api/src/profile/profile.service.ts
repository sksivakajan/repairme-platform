import { Injectable } from '@nestjs/common';
import type { AuthUser } from '../auth/auth-user.js';
import { PrismaService } from '../database/prisma.service.js';
import { UpdateProfileDto } from './profile.dto.js';

@Injectable()
export class ProfileService {
  constructor(private readonly prisma: PrismaService) {}

  async get(user: AuthUser) {
    const [profile, bookingCount, addressCount, unreadNotifications] =
      await Promise.all([
        this.prisma.user.findUniqueOrThrow({
          where: { id: user.userId },
          select: {
            id: true,
            role: true,
            phoneNumber: true,
            fullName: true,
            language: true,
          },
        }),
        user.customerId
          ? this.prisma.booking.count({
              where: { customerId: user.customerId },
            })
          : 0,
        user.customerId
          ? this.prisma.address.count({
              where: { customerId: user.customerId },
            })
          : 0,
        this.prisma.notification.count({
          where: { userId: user.userId, readAt: null },
        }),
      ]);
    return { ...profile, bookingCount, addressCount, unreadNotifications };
  }

  async update(user: AuthUser, dto: UpdateProfileDto) {
    await this.prisma.user.update({
      where: { id: user.userId },
      data: { fullName: dto.fullName?.trim(), language: dto.language },
    });
    return this.get(user);
  }
}
