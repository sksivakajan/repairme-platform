import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  IsArray,
  IsBoolean,
  IsEmail,
  IsEnum,
  IsIn,
  IsISO8601,
  IsOptional,
  IsString,
  Length,
  Matches,
  ValidateIf,
  ValidateNested,
} from 'class-validator';
import { Gender, Language } from '../generated/prisma/client.js';

const E164 = /^\+[1-9]\d{7,14}$/;
const PHONE_MESSAGE = 'Enter the number with its country code, like +94771234567';

export class UpdateProfileDto {
  /** Older apps send one name; it is split into first and last name. */
  @IsOptional()
  @IsString()
  @Length(2, 80)
  fullName?: string;

  @IsOptional()
  @IsString()
  @Length(1, 40)
  firstName?: string;

  @IsOptional()
  @IsString()
  @Length(1, 40)
  lastName?: string;

  /** An empty string clears the email. */
  @IsOptional()
  @ValidateIf((_o, value) => value !== '')
  @IsEmail()
  @Length(3, 120)
  email?: string;

  /** Date only: "2001-08-12". An empty string clears it. */
  @IsOptional()
  @ValidateIf((_o, value) => value !== '')
  @IsISO8601({ strict: true })
  @Matches(/^\d{4}-\d{2}-\d{2}$/, { message: 'birthday must look like 2001-08-12' })
  birthday?: string;

  @IsOptional()
  @IsEnum(Gender)
  gender?: Gender;

  @IsOptional()
  @IsEnum(Language)
  language?: Language;
}

export class DocumentRefDto {
  @IsString()
  @Length(1, 40)
  type: string;

  @IsString()
  @Length(1, 20)
  version: string;
}

export class CompleteProfileDto {
  @IsString()
  @Length(1, 40)
  firstName: string;

  @IsString()
  @Length(1, 40)
  lastName: string;

  @IsOptional()
  @ValidateIf((_o, value) => value !== '')
  @IsEmail()
  @Length(3, 120)
  email?: string;

  /** The legal documents (and versions) shown to the customer when they continued. */
  @IsArray()
  @ArrayMaxSize(10)
  @ValidateNested({ each: true })
  @Type(() => DocumentRefDto)
  acceptedDocuments: DocumentRefDto[];
}

export class AcceptDocumentsDto {
  @IsArray()
  @ArrayMaxSize(10)
  @ValidateNested({ each: true })
  @Type(() => DocumentRefDto)
  documents: DocumentRefDto[];
}

export class EmergencyContactDto {
  @IsString()
  @Length(2, 80)
  name: string;

  @IsString()
  @Length(2, 40)
  relationship: string;

  @IsString()
  @Matches(E164, { message: PHONE_MESSAGE })
  phoneNumber: string;
}

export class NotificationPreferencesDto {
  @IsOptional()
  @IsBoolean()
  bookingUpdates?: boolean;

  @IsOptional()
  @IsBoolean()
  serviceReminders?: boolean;

  @IsOptional()
  @IsBoolean()
  paymentUpdates?: boolean;

  @IsOptional()
  @IsBoolean()
  offers?: boolean;

  @IsOptional()
  @IsBoolean()
  repairmeUpdates?: boolean;
}

export const DELETION_REASONS = [
  'NO_LONGER_NEEDED',
  'PRIVACY_CONCERNS',
  'BAD_EXPERIENCE',
  'ANOTHER_ACCOUNT',
  'TOO_MANY_NOTIFICATIONS',
  'SERVICES_NOT_FOUND',
  'OTHER',
] as const;

export class DeleteAccountDto {
  @IsIn(DELETION_REASONS)
  reason: (typeof DELETION_REASONS)[number];

  @IsOptional()
  @IsString()
  @Length(0, 500)
  details?: string;
}

export class ChangePhoneDto {
  @IsString()
  @Matches(E164, { message: PHONE_MESSAGE })
  phoneNumber: string;
}
