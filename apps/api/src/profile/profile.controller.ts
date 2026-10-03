import { Body, Controller, Get, Patch } from '@nestjs/common';
import type { AuthUser } from '../auth/auth-user.js';
import { CurrentUser } from '../auth/decorators.js';
import { UpdateProfileDto } from './profile.dto.js';
import { ProfileService } from './profile.service.js';

@Controller('me')
export class ProfileController {
  constructor(private readonly profileService: ProfileService) {}

  @Get()
  get(@CurrentUser() user: AuthUser) {
    return this.profileService.get(user);
  }

  @Patch()
  update(@CurrentUser() user: AuthUser, @Body() dto: UpdateProfileDto) {
    return this.profileService.update(user, dto);
  }
}
