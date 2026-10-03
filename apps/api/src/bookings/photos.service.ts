import {
  BadRequestException,
  ConflictException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { createReadStream } from 'node:fs';
import { mkdir, rm, writeFile } from 'node:fs/promises';
import { join } from 'node:path';
import { randomUUID } from 'node:crypto';
import { AppConfig } from '../config/app-config.js';
import { PrismaService } from '../database/prisma.service.js';
import type { PhotoKind } from '../generated/prisma/client.js';
import { loadAsParticipant } from './booking-access.js';
import { PHOTOS_OPEN } from './booking-status.js';

export const MAX_PHOTO_BYTES = 8 * 1024 * 1024;
const MAX_PHOTOS_PER_KIND = 6;

/** Detects the image type from its content; the client's declared type is not trusted. */
export function detectImageType(data: Buffer): { mime: string; ext: string } | null {
  if (data.length < 12) return null;
  if (data[0] === 0xff && data[1] === 0xd8 && data[2] === 0xff) {
    return { mime: 'image/jpeg', ext: 'jpg' };
  }
  if (data.subarray(0, 8).equals(Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]))) {
    return { mime: 'image/png', ext: 'png' };
  }
  if (data.toString('ascii', 0, 4) === 'RIFF' && data.toString('ascii', 8, 12) === 'WEBP') {
    return { mime: 'image/webp', ext: 'webp' };
  }
  const brand = data.toString('ascii', 4, 12);
  if (brand === 'ftypheic' || brand === 'ftypheix' || brand === 'ftypmif1') {
    return { mime: 'image/heic', ext: 'heic' };
  }
  return null;
}

/**
 * Booking photos on local disk. Storage keys are opaque, so moving to S3
 * later only changes this service.
 */
@Injectable()
export class PhotosService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly config: AppConfig,
  ) {}

  async upload(userId: string, bookingId: string, kind: PhotoKind, data: Buffer) {
    const { booking, participant } = await loadAsParticipant(
      this.prisma,
      bookingId,
      userId,
    );
    if (participant === 'CUSTOMER') {
      if (kind !== 'PROBLEM') throw new BadRequestException('Invalid photo kind');
      if (!PHOTOS_OPEN.includes(booking.status)) {
        throw new ConflictException('Photos can no longer be added to this booking');
      }
    } else if (kind === 'PROBLEM') {
      throw new BadRequestException('Invalid photo kind');
    }

    const type = detectImageType(data);
    if (!type) {
      throw new BadRequestException('Upload a JPEG, PNG, WebP or HEIC image');
    }
    const count = await this.prisma.bookingPhoto.count({ where: { bookingId, kind } });
    if (count >= MAX_PHOTOS_PER_KIND) {
      throw new ConflictException(`At most ${MAX_PHOTOS_PER_KIND} photos can be added`);
    }

    const storageKey = `${bookingId}/${randomUUID()}.${type.ext}`;
    const path = join(this.config.uploadDir, storageKey);
    await mkdir(join(this.config.uploadDir, bookingId), { recursive: true });
    await writeFile(path, data);
    try {
      return await this.prisma.bookingPhoto.create({
        data: {
          bookingId,
          uploadedById: userId,
          kind,
          storageKey,
          contentType: type.mime,
          sizeBytes: data.length,
        },
        select: { id: true, kind: true, createdAt: true },
      });
    } catch (error) {
      await rm(path, { force: true });
      throw error;
    }
  }

  async open(userId: string, bookingId: string, photoId: string) {
    await loadAsParticipant(this.prisma, bookingId, userId);
    const photo = await this.prisma.bookingPhoto.findFirst({
      where: { id: photoId, bookingId },
    });
    if (!photo) throw new NotFoundException('Photo not found');
    return {
      stream: createReadStream(join(this.config.uploadDir, photo.storageKey)),
      contentType: photo.contentType,
      sizeBytes: photo.sizeBytes,
    };
  }
}
