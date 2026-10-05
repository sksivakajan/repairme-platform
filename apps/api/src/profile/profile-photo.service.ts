import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { randomUUID } from 'node:crypto';
import { createReadStream } from 'node:fs';
import { mkdir, rm, stat, writeFile } from 'node:fs/promises';
import { join } from 'node:path';
import { detectImageType } from '../bookings/photos.service.js';
import { AppConfig } from '../config/app-config.js';
import { PrismaService } from '../database/prisma.service.js';

/** Profile photos on local disk, next to booking photos (keys are opaque, so S3 later is a swap here). */
@Injectable()
export class ProfilePhotoService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly config: AppConfig,
  ) {}

  private dir(userId: string) {
    return join(this.config.uploadDir, 'profile', userId);
  }

  async upload(userId: string, data: Buffer): Promise<void> {
    const type = detectImageType(data);
    if (!type || type.ext === 'heic') {
      throw new BadRequestException('Upload a JPEG, PNG or WebP image');
    }
    const key = `profile/${userId}/${randomUUID()}.${type.ext}`;
    await mkdir(this.dir(userId), { recursive: true });
    await writeFile(join(this.config.uploadDir, key), data);

    const previous = await this.prisma.user.findUniqueOrThrow({
      where: { id: userId },
      select: { profilePhotoKey: true },
    });
    await this.prisma.user.update({ where: { id: userId }, data: { profilePhotoKey: key } });
    if (previous.profilePhotoKey) {
      await rm(join(this.config.uploadDir, previous.profilePhotoKey), { force: true });
    }
  }

  async open(userId: string) {
    const user = await this.prisma.user.findUniqueOrThrow({
      where: { id: userId },
      select: { profilePhotoKey: true },
    });
    if (!user.profilePhotoKey) throw new NotFoundException('No profile photo');
    const path = join(this.config.uploadDir, user.profilePhotoKey);
    const { size } = await stat(path).catch(() => {
      throw new NotFoundException('No profile photo');
    });
    const ext = user.profilePhotoKey.split('.').pop();
    return {
      stream: createReadStream(path),
      contentType: ext === 'png' ? 'image/png' : ext === 'webp' ? 'image/webp' : 'image/jpeg',
      sizeBytes: size,
    };
  }

  async remove(userId: string): Promise<void> {
    await this.prisma.user.update({ where: { id: userId }, data: { profilePhotoKey: null } });
    await this.removeFiles(userId);
  }

  async removeFiles(userId: string): Promise<void> {
    await rm(this.dir(userId), { recursive: true, force: true });
  }
}
