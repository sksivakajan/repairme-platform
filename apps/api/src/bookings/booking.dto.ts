import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  IsArray,
  IsBoolean,
  IsEnum,
  IsIn,
  IsInt,
  IsISO8601,
  IsOptional,
  IsString,
  IsUUID,
  Length,
  Max,
  Min,
  ValidateNested,
} from 'class-validator';
import { AddressInputDto } from '../addresses/address.dto.js';
import {
  AddressLabel,
  BookingType,
  PaymentMethod,
} from '../generated/prisma/client.js';
import { BOOKING_TABS, type BookingTab } from './booking-status.js';

export class CreateBookingDto {
  @IsUUID()
  categoryId: string;

  @IsOptional()
  @IsUUID()
  problemTypeId?: string;

  @IsEnum(BookingType)
  type: BookingType;

  @IsString()
  @Length(10, 1000)
  description: string;

  @IsOptional()
  @IsArray()
  @ArrayMaxSize(8)
  @IsString({ each: true })
  @Length(1, 40, { each: true })
  symptoms?: string[];

  /** Use a saved address… */
  @IsOptional()
  @IsUUID()
  addressId?: string;

  /** …or provide one. */
  @IsOptional()
  @ValidateNested()
  @Type(() => AddressInputDto)
  address?: AddressInputDto;

  /** Save the provided address to the customer's address book. */
  @IsOptional()
  @IsBoolean()
  saveAddress?: boolean;

  @IsOptional()
  @IsEnum(AddressLabel)
  addressLabel?: AddressLabel;

  @IsOptional()
  @IsISO8601({ strict: true })
  scheduledStart?: string;

  @IsOptional()
  @IsISO8601({ strict: true })
  scheduledEnd?: string;

  @IsOptional()
  @IsEnum(PaymentMethod)
  paymentMethod?: PaymentMethod;
}

export class ListBookingsQueryDto {
  @IsOptional()
  @IsIn(Object.keys(BOOKING_TABS))
  tab?: BookingTab;
}

export const CANCEL_REASONS = [
  'FOUND_SOMEONE_ELSE',
  'PROBLEM_FIXED',
  'WAITING_TOO_LONG',
  'OTHER',
] as const;

export class CancelBookingDto {
  @IsIn(CANCEL_REASONS)
  reason: (typeof CANCEL_REASONS)[number];

  @IsOptional()
  @IsString()
  @Length(1, 300)
  details?: string;
}

export class PayBookingDto {
  @IsEnum(PaymentMethod)
  method: PaymentMethod;
}

export const REVIEW_TAGS = [
  'ON_TIME',
  'PROFESSIONAL',
  'CLEAN_WORK',
  'FAIR_PRICE',
  'EXPLAINED_CLEARLY',
] as const;

export class CreateReviewDto {
  @IsInt()
  @Min(1)
  @Max(5)
  rating: number;

  @IsOptional()
  @IsArray()
  @ArrayMaxSize(REVIEW_TAGS.length)
  @IsIn(REVIEW_TAGS, { each: true })
  tags?: string[];

  @IsOptional()
  @IsString()
  @Length(1, 500)
  comment?: string;
}

export class SendMessageDto {
  @IsString()
  @Length(1, 1000)
  body: string;
}

export class QuotationItemDto {
  @IsString()
  @Length(1, 120)
  description: string;

  @IsInt()
  @Min(1)
  @Max(100)
  quantity: number;

  @IsInt()
  @Min(0)
  @Max(100_000_000)
  unitPriceCents: number;
}

export class SendQuotationDto {
  @IsOptional()
  @IsString()
  @Length(1, 500)
  note?: string;

  @IsInt()
  @Min(0)
  @Max(100_000_000)
  labourCents: number;

  @IsArray()
  @ArrayMaxSize(30)
  @ValidateNested({ each: true })
  @Type(() => QuotationItemDto)
  items: QuotationItemDto[];
}
