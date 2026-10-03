import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../database/prisma.service.js';
import { CreateAddressDto } from './address.dto.js';

@Injectable()
export class AddressesService {
  constructor(private readonly prisma: PrismaService) {}

  list(customerId: string) {
    return this.prisma.address.findMany({
      where: { customerId },
      orderBy: [{ isDefault: 'desc' }, { createdAt: 'asc' }],
    });
  }

  async create(customerId: string, dto: CreateAddressDto) {
    return this.prisma.$transaction(async (tx) => {
      const isFirst = (await tx.address.count({ where: { customerId } })) === 0;
      const isDefault = dto.isDefault ?? isFirst;
      if (isDefault) {
        await tx.address.updateMany({
          where: { customerId },
          data: { isDefault: false },
        });
      }
      return tx.address.create({ data: { ...dto, customerId, isDefault } });
    });
  }

  async update(customerId: string, id: string, dto: CreateAddressDto) {
    await this.findOwned(customerId, id);
    return this.prisma.$transaction(async (tx) => {
      if (dto.isDefault) {
        await tx.address.updateMany({
          where: { customerId },
          data: { isDefault: false },
        });
      }
      return tx.address.update({ where: { id }, data: dto });
    });
  }

  async remove(customerId: string, id: string): Promise<void> {
    await this.findOwned(customerId, id);
    // Bookings keep their own address snapshot, so deleting is safe.
    await this.prisma.address.delete({ where: { id } });
  }

  async findOwned(customerId: string, id: string) {
    const address = await this.prisma.address.findFirst({
      where: { id, customerId },
    });
    if (!address) throw new NotFoundException('Address not found');
    return address;
  }
}
