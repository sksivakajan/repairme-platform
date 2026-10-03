import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service.js';
import type { AuthUser, VerifiedIdentity } from './auth-user.js';

@Injectable()
export class AuthService {
  constructor(private readonly prisma: PrismaService) {}

  /**
   * Maps a verified identity to a RepairMe user. First sign-in creates the
   * user with a customer profile (technician accounts are created by the
   * operations team, not by self sign-up).
   */
  async resolveUser(identity: VerifiedIdentity): Promise<AuthUser> {
    const user = await this.prisma.user.upsert({
      where: { firebaseUid: identity.firebaseUid },
      update:
        identity.phoneNumber !== null
          ? { phoneNumber: identity.phoneNumber }
          : {},
      create: {
        firebaseUid: identity.firebaseUid,
        phoneNumber: identity.phoneNumber,
        role: 'CUSTOMER',
        customer: { create: {} },
      },
      select: {
        id: true,
        role: true,
        phoneNumber: true,
        customer: { select: { id: true } },
      },
    });

    return {
      userId: user.id,
      role: user.role,
      phoneNumber: user.phoneNumber,
      customerId: user.customer?.id ?? null,
    };
  }
}
