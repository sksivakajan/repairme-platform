import {
  BadRequestException,
  ConflictException,
  ForbiddenException,
  Injectable,
} from '@nestjs/common';
import type { AuthUser } from '../auth/auth-user.js';
import { AppConfig } from '../config/app-config.js';
import { PrismaService } from '../database/prisma.service.js';
import { Prisma } from '../generated/prisma/client.js';
import { LegalService } from '../legal/legal.service.js';
import {
  CompleteProfileDto,
  DeleteAccountDto,
  EmergencyContactDto,
  NotificationPreferencesDto,
  UpdateProfileDto,
} from './profile.dto.js';
import { ProfilePhotoService } from './profile-photo.service.js';

/** How recently the customer must have verified their number for sensitive changes. */
const RECENT_LOGIN_SECONDS = 10 * 60;

const OPEN_BOOKING_STATUSES = [
  'SEARCHING',
  'OPERATOR_ASSIGNING',
  'ASSIGNED',
  'EN_ROUTE',
  'ARRIVED',
  'AWAITING_APPROVAL',
  'IN_PROGRESS',
  'COMPLETED',
] as const;

const PROFILE_SELECT = {
  id: true,
  role: true,
  phoneNumber: true,
  fullName: true,
  firstName: true,
  lastName: true,
  email: true,
  birthday: true,
  gender: true,
  profilePhotoKey: true,
  language: true,
  membershipType: true,
  profileCompletedAt: true,
  createdAt: true,
  notifyBookingUpdates: true,
  notifyServiceReminders: true,
  notifyPaymentUpdates: true,
  notifyOffers: true,
  notifyRepairmeUpdates: true,
} satisfies Prisma.UserSelect;

function clean(value: string | undefined): string | undefined {
  return value === undefined ? undefined : value.trim().replace(/\s+/g, ' ');
}

function joinName(first: string | null, last: string | null): string | null {
  const name = [first, last].filter(Boolean).join(' ').trim();
  return name.length > 0 ? name : null;
}

function dateOnly(value: Date | null): string | null {
  return value ? value.toISOString().slice(0, 10) : null;
}

@Injectable()
export class ProfileService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly config: AppConfig,
    private readonly legal: LegalService,
    private readonly photos: ProfilePhotoService,
  ) {}

  async get(user: AuthUser) {
    const [profile, bookingCount, addressCount, unreadNotifications, pendingLegal] =
      await Promise.all([
        this.prisma.user.findUniqueOrThrow({
          where: { id: user.userId },
          select: PROFILE_SELECT,
        }),
        user.customerId
          ? this.prisma.booking.count({ where: { customerId: user.customerId } })
          : 0,
        user.customerId
          ? this.prisma.address.count({ where: { customerId: user.customerId } })
          : 0,
        this.prisma.notification.count({
          where: { userId: user.userId, readAt: null },
        }),
        this.legal.pending(user.userId),
      ]);
    const {
      profilePhotoKey,
      profileCompletedAt,
      createdAt,
      birthday,
      notifyBookingUpdates,
      notifyServiceReminders,
      notifyPaymentUpdates,
      notifyOffers,
      notifyRepairmeUpdates,
      ...rest
    } = profile;
    return {
      ...rest,
      birthday: dateOnly(birthday),
      hasPhoto: profilePhotoKey !== null,
      // Changes with every upload, so the app knows when to fetch the photo again.
      photoVersion: profilePhotoKey?.split('/').pop() ?? null,
      profileComplete: profileCompletedAt !== null,
      memberSince: createdAt,
      notificationPreferences: {
        bookingUpdates: notifyBookingUpdates,
        serviceReminders: notifyServiceReminders,
        paymentUpdates: notifyPaymentUpdates,
        offers: notifyOffers,
        repairmeUpdates: notifyRepairmeUpdates,
      },
      pendingLegal,
      bookingCount,
      addressCount,
      unreadNotifications,
    };
  }

  async update(user: AuthUser, dto: UpdateProfileDto) {
    const current = await this.prisma.user.findUniqueOrThrow({
      where: { id: user.userId },
      select: { firstName: true, lastName: true },
    });
    let { firstName, lastName } = {
      firstName: clean(dto.firstName) ?? current.firstName,
      lastName: clean(dto.lastName) ?? current.lastName,
    };
    if (dto.fullName !== undefined && dto.firstName === undefined && dto.lastName === undefined) {
      const [first, ...rest] = clean(dto.fullName)!.split(' ');
      firstName = first;
      lastName = rest.join(' ') || null;
    }

    const data: Prisma.UserUpdateInput = {
      firstName,
      lastName,
      fullName: joinName(firstName, lastName),
      gender: dto.gender,
      language: dto.language,
    };
    if (dto.email !== undefined) data.email = dto.email === '' ? null : dto.email.trim().toLowerCase();
    if (dto.birthday !== undefined) data.birthday = this.parseBirthday(dto.birthday);

    await this.prisma.user.update({ where: { id: user.userId }, data });
    return this.get(user);
  }

  /** Creates the account: the first time a verified number finishes setup. */
  async complete(user: AuthUser, dto: CompleteProfileDto) {
    const existing = await this.prisma.user.findUniqueOrThrow({
      where: { id: user.userId },
      select: { profileCompletedAt: true },
    });
    if (existing.profileCompletedAt) {
      throw new ConflictException('This account is already set up');
    }
    this.legal.validateAcceptance(dto.acceptedDocuments, true);

    const firstName = clean(dto.firstName)!;
    const lastName = clean(dto.lastName)!;
    await this.prisma.user.update({
      where: { id: user.userId },
      data: {
        firstName,
        lastName,
        fullName: joinName(firstName, lastName),
        email: dto.email ? dto.email.trim().toLowerCase() : null,
        profileCompletedAt: new Date(),
      },
    });
    await this.legal.record(user.userId, dto.acceptedDocuments);
    return this.get(user);
  }

  private parseBirthday(value: string): Date | null {
    if (value === '') return null;
    const date = new Date(`${value}T00:00:00.000Z`);
    if (Number.isNaN(date.getTime()) || date.toISOString().slice(0, 10) !== value) {
      throw new BadRequestException('Enter a real birthday');
    }
    if (date.getTime() > Date.now()) throw new BadRequestException('Birthday cannot be in the future');
    if (date.getUTCFullYear() < 1900) throw new BadRequestException('Enter a real birthday');
    return date;
  }

  // ─── Emergency contact (one for now; the table allows more later) ──────────

  async getEmergencyContact(user: AuthUser) {
    const contact = await this.prisma.emergencyContact.findFirst({
      where: { userId: user.userId },
      orderBy: { createdAt: 'asc' },
      select: { name: true, relationship: true, phoneNumber: true },
    });
    return contact ?? null;
  }

  async saveEmergencyContact(user: AuthUser, dto: EmergencyContactDto) {
    const data = { name: clean(dto.name)!, relationship: clean(dto.relationship)!, phoneNumber: dto.phoneNumber };
    const existing = await this.prisma.emergencyContact.findFirst({ where: { userId: user.userId } });
    if (existing) {
      await this.prisma.emergencyContact.update({ where: { id: existing.id }, data });
    } else {
      await this.prisma.emergencyContact.create({ data: { ...data, userId: user.userId } });
    }
    return this.getEmergencyContact(user);
  }

  async removeEmergencyContact(user: AuthUser): Promise<void> {
    await this.prisma.emergencyContact.deleteMany({ where: { userId: user.userId } });
  }

  // ─── Notification preferences ──────────────────────────────────────────────

  async updateNotificationPreferences(user: AuthUser, dto: NotificationPreferencesDto) {
    await this.prisma.user.update({
      where: { id: user.userId },
      data: {
        notifyBookingUpdates: dto.bookingUpdates,
        notifyServiceReminders: dto.serviceReminders,
        notifyPaymentUpdates: dto.paymentUpdates,
        notifyOffers: dto.offers,
        notifyRepairmeUpdates: dto.repairmeUpdates,
      },
    });
    return (await this.get(user)).notificationPreferences;
  }

  // ─── Legal acceptance ──────────────────────────────────────────────────────

  async acceptDocuments(user: AuthUser, refs: { type: string; version: string }[]) {
    this.legal.validateAcceptance(refs, false);
    await this.legal.record(user.userId, refs);
    return this.legal.history(user.userId);
  }

  // ─── Changing the mobile number ────────────────────────────────────────────

  /**
   * With Firebase sign-in the customer first verifies the new number with an
   * OTP (the app does that), which gives them a token carrying it. Here we
   * only confirm the token's number is the one requested. In development
   * (dev login) there is no token to prove it, so the number is switched.
   */
  async changePhone(user: AuthUser, phoneNumber: string) {
    this.requireRecentLogin(user);
    if (user.phoneNumber === phoneNumber) return this.get(user);

    if (!this.config.authDevBypass) {
      throw new BadRequestException('Verify the new number with the code we send, then try again');
    }
    try {
      await this.prisma.user.update({
        where: { id: user.userId },
        data: { phoneNumber, firebaseUid: `dev:${phoneNumber}` },
      });
    } catch (error) {
      if (error instanceof Prisma.PrismaClientKnownRequestError && error.code === 'P2002') {
        throw new ConflictException('This mobile number is already associated with another account');
      }
      throw error;
    }
    return this.get({ ...user, phoneNumber });
  }

  // ─── Deleting the account ──────────────────────────────────────────────────

  /**
   * Removes the customer's personal data and signs them out everywhere. The
   * user row stays, anonymised, so bookings, payments and support records that
   * must be kept for accounting and disputes still have an owner. Their phone
   * number is freed, so registering again starts a fresh account.
   */
  async deleteAccount(user: AuthUser, dto: DeleteAccountDto): Promise<void> {
    this.requireRecentLogin(user);

    if (user.customerId) {
      const open = await this.prisma.booking.count({
        where: { customerId: user.customerId, status: { in: [...OPEN_BOOKING_STATUSES] } },
      });
      if (open > 0) {
        throw new ConflictException('Finish or cancel your active bookings before deleting your account');
      }
    }

    await this.prisma.$transaction(async (tx) => {
      await tx.accountDeletionFeedback.create({
        data: { reason: dto.reason, details: dto.details?.trim() || null },
      });
      await tx.emergencyContact.deleteMany({ where: { userId: user.userId } });
      await tx.notification.deleteMany({ where: { userId: user.userId } });
      if (user.customerId) await tx.address.deleteMany({ where: { customerId: user.customerId } });
      await tx.user.update({
        where: { id: user.userId },
        data: {
          firstName: null,
          lastName: null,
          fullName: null,
          email: null,
          birthday: null,
          gender: null,
          profilePhotoKey: null,
          phoneNumber: null,
          firebaseUid: null,
          accountStatus: 'DELETED',
          deletedAt: new Date(),
        },
      });
    });
    await this.photos.removeFiles(user.userId);
  }

  private requireRecentLogin(user: AuthUser): void {
    const ageSeconds = Date.now() / 1000 - (user.authTime ?? 0);
    if (ageSeconds > RECENT_LOGIN_SECONDS) {
      throw new ForbiddenException('Please verify your mobile number again to continue');
    }
  }
}
