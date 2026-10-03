import { Injectable } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service.js';

@Injectable()
export class CatalogService {
  constructor(private readonly prisma: PrismaService) {}

  async listCategories() {
    const [categories, onlineTechnicians] = await Promise.all([
      this.prisma.serviceCategory.findMany({
        where: { isActive: true },
        orderBy: { sortOrder: 'asc' },
        select: {
          id: true,
          slug: true,
          name: true,
          description: true,
          iconKey: true,
          isPopular: true,
          visitFeeCents: true,
          problemTypes: {
            where: { isActive: true },
            orderBy: { sortOrder: 'asc' },
            select: { id: true, slug: true, name: true },
          },
        },
      }),
      this.prisma.technician.count({
        where: { status: 'VERIFIED', isOnline: true },
      }),
    ]);
    return { categories, onlineTechnicians };
  }
}
