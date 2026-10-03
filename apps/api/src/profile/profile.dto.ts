import { IsEnum, IsOptional, IsString, Length } from 'class-validator';
import { Language } from '../generated/prisma/client.js';

export class UpdateProfileDto {
  @IsOptional()
  @IsString()
  @Length(2, 80)
  fullName?: string;

  @IsOptional()
  @IsEnum(Language)
  language?: Language;
}
