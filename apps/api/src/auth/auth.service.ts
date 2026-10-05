import { ConflictException, Injectable } from '@nestjs/common';
import { Prisma } from '../generated/prisma/client.js';
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
    try {
      return await this.upsertUser(identity);
    } catch (error) {
      // A new user's first requests arrive in parallel and race to create the
      // row; the loser hits the unique constraint and the retry updates it.
      if (
        error instanceof Prisma.PrismaClientKnownRequestError &&
        error.code === 'P2002'
      ) {
        try {
          return await this.upsertUser(identity);
        } catch (retryError) {
          // Still a clash: the verified number belongs to a different account.
          if (
            retryError instanceof Prisma.PrismaClientKnownRequestError &&
            retryError.code === 'P2002'
          ) {
            throw new ConflictException(
              'This mobile number is already associated with another account',
            );
          }
          throw retryError;
        }
      }
      throw error;
    }
  }

  private async upsertUser(identity: VerifiedIdentity): Promise<AuthUser> {
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
      authTime: identity.authTime,
    };
  }
}
