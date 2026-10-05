import { Module } from '@nestjs/common';
import { LegalModule } from '../legal/legal.module.js';
import { ProfileController } from './profile.controller.js';
import { ProfilePhotoService } from './profile-photo.service.js';
import { ProfileService } from './profile.service.js';

@Module({
  imports: [LegalModule],
  controllers: [ProfileController],
  providers: [ProfileService, ProfilePhotoService],
})
export class ProfileModule {}
