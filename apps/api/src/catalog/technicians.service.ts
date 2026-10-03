import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service.js';
import { rankTopRated } from './technician-ranking.js';

@Injectable()
export class TechniciansService {
  constructor(private readonly prisma: PrismaService) {}

  async topRated() {
    const technicians = await this.prisma.technician.findMany({
      where: { status: 'VERIFIED', ratingCount: { gt: 0 } },
      orderBy: { ratingCount: 'desc' },
      take: 200,
      select: {
        displayName: true,
        ratingSum: true,
        ratingCount: true,
        jobsCompleted: true,
        categories: {
          select: {
            category: { select: { slug: true, name: true, sortOrder: true } },
          },
        },
      },
    });
    return rankTopRated(technicians);
  }
}
