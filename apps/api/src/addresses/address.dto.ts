import {
  IsBoolean,
  IsEnum,
  IsLatitude,
  IsLongitude,
  IsOptional,
  IsString,
  Length,
} from 'class-validator';
import { AddressLabel } from '../generated/prisma/client.js';

/** Address fields shared by saved addresses and a booking's address. */
export class AddressInputDto {
  @IsString()
  @Length(3, 120)
  line1: string;

  @IsString()
  @Length(2, 60)
  area: string;

  @IsString()
  @Length(2, 60)
  city: string;

  @IsOptional()
  @IsString()
  @Length(1, 40)
  houseNumber?: string;

  @IsOptional()
  @IsString()
  @Length(1, 160)
  landmark?: string;

  @IsOptional()
  @IsLatitude()
  latitude?: number;

  @IsOptional()
  @IsLongitude()
  longitude?: number;
}

export class CreateAddressDto extends AddressInputDto {
  @IsOptional()
  @IsEnum(AddressLabel)
  label?: AddressLabel;

  @IsOptional()
  @IsBoolean()
  isDefault?: boolean;
}
