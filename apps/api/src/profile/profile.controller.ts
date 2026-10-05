import {
  BadRequestException,
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  Patch,
  Post,
  Put,
  StreamableFile,
  UploadedFile,
  UseInterceptors,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import type { AuthUser } from '../auth/auth-user.js';
import { CurrentUser } from '../auth/decorators.js';
import { MAX_PHOTO_BYTES } from '../bookings/photos.service.js';
import { LegalService } from '../legal/legal.service.js';
import {
  AcceptDocumentsDto,
  ChangePhoneDto,
  CompleteProfileDto,
  DeleteAccountDto,
  EmergencyContactDto,
  NotificationPreferencesDto,
  UpdateProfileDto,
} from './profile.dto.js';
import { ProfilePhotoService } from './profile-photo.service.js';
import { ProfileService } from './profile.service.js';

@Controller('me')
export class ProfileController {
  constructor(
    private readonly profileService: ProfileService,
    private readonly photoService: ProfilePhotoService,
    private readonly legalService: LegalService,
  ) {}

  @Get()
  get(@CurrentUser() user: AuthUser) {
    return this.profileService.get(user);
  }

  @Patch()
  update(@CurrentUser() user: AuthUser, @Body() dto: UpdateProfileDto) {
    return this.profileService.update(user, dto);
  }

  /** First-time account setup, after the mobile number is verified. */
  @Post('complete-profile')
  complete(@CurrentUser() user: AuthUser, @Body() dto: CompleteProfileDto) {
    return this.profileService.complete(user, dto);
  }

  @Put('phone')
  changePhone(@CurrentUser() user: AuthUser, @Body() dto: ChangePhoneDto) {
    return this.profileService.changePhone(user, dto.phoneNumber);
  }

  // ─── Photo ─────────────────────────────────────────────────────────────────

  @Post('photo')
  @HttpCode(204)
  @UseInterceptors(FileInterceptor('file', { limits: { fileSize: MAX_PHOTO_BYTES, files: 1 } }))
  async uploadPhoto(
    @CurrentUser() user: AuthUser,
    @UploadedFile() file: Express.Multer.File | undefined,
  ): Promise<void> {
    if (!file) throw new BadRequestException('Attach an image as "file"');
    await this.photoService.upload(user.userId, file.buffer);
  }

  @Get('photo')
  async photo(@CurrentUser() user: AuthUser): Promise<StreamableFile> {
    const photo = await this.photoService.open(user.userId);
    return new StreamableFile(photo.stream, { type: photo.contentType, length: photo.sizeBytes });
  }

  @Delete('photo')
  @HttpCode(204)
  async removePhoto(@CurrentUser() user: AuthUser): Promise<void> {
    await this.photoService.remove(user.userId);
  }

  // ─── Emergency contact ─────────────────────────────────────────────────────

  @Get('emergency-contact')
  emergencyContact(@CurrentUser() user: AuthUser) {
    return this.profileService.getEmergencyContact(user);
  }

  @Put('emergency-contact')
  saveEmergencyContact(@CurrentUser() user: AuthUser, @Body() dto: EmergencyContactDto) {
    return this.profileService.saveEmergencyContact(user, dto);
  }

  @Delete('emergency-contact')
  @HttpCode(204)
  async removeEmergencyContact(@CurrentUser() user: AuthUser): Promise<void> {
    await this.profileService.removeEmergencyContact(user);
  }

  // ─── Notification preferences ──────────────────────────────────────────────

  @Patch('notification-preferences')
  notificationPreferences(@CurrentUser() user: AuthUser, @Body() dto: NotificationPreferencesDto) {
    return this.profileService.updateNotificationPreferences(user, dto);
  }

  // ─── Legal acceptance ──────────────────────────────────────────────────────

  @Get('legal-acceptances')
  legalAcceptances(@CurrentUser() user: AuthUser) {
    return this.legalService.history(user.userId);
  }

  @Post('legal-acceptances')
  acceptLegal(@CurrentUser() user: AuthUser, @Body() dto: AcceptDocumentsDto) {
    return this.profileService.acceptDocuments(user, dto.documents);
  }

  // ─── Delete account ────────────────────────────────────────────────────────

  @Post('delete')
  @HttpCode(204)
  async deleteAccount(@CurrentUser() user: AuthUser, @Body() dto: DeleteAccountDto): Promise<void> {
    await this.profileService.deleteAccount(user, dto);
  }
}
