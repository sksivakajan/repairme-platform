import {
  BadRequestException,
  Body,
  Controller,
  Get,
  Injectable,
  Module,
  Post,
} from '@nestjs/common';
import { IsOptional, IsString, IsUUID, Length } from 'class-validator';
import { CustomerId } from '../auth/decorators.js';
import { formatReference } from '../bookings/booking-status.js';
import { PrismaService } from '../database/prisma.service.js';

export class CreateTicketDto {
  @IsOptional()
  @IsUUID()
  bookingId?: string;

  @IsString()
  @Length(3, 120)
  subject: string;

  @IsString()
  @Length(10, 2000)
  message: string;
}

@Injectable()
export class SupportService {
  constructor(private readonly prisma: PrismaService) {}

  async list(customerId: string) {
    const tickets = await this.prisma.supportTicket.findMany({
      where: { customerId },
      orderBy: { createdAt: 'desc' },
      include: { booking: { select: { referenceNumber: true } } },
    });
    return tickets.map((ticket) => ({
      id: ticket.id,
      reference: `S-${ticket.referenceNumber}`,
      bookingReference: ticket.booking
        ? formatReference(ticket.booking.referenceNumber)
        : null,
      subject: ticket.subject,
      status: ticket.status,
      createdAt: ticket.createdAt,
    }));
  }

  async create(customerId: string, dto: CreateTicketDto) {
    if (dto.bookingId) {
      const owned = await this.prisma.booking.count({
        where: { id: dto.bookingId, customerId },
      });
      if (!owned) throw new BadRequestException('Booking not found');
    }
    await this.prisma.supportTicket.create({
      data: {
        customerId,
        bookingId: dto.bookingId,
        subject: dto.subject.trim(),
        message: dto.message.trim(),
      },
    });
    return this.list(customerId);
  }
}

@Controller('support/tickets')
export class SupportController {
  constructor(private readonly supportService: SupportService) {}

  @Get()
  list(@CustomerId() customerId: string) {
    return this.supportService.list(customerId);
  }

  @Post()
  create(@CustomerId() customerId: string, @Body() dto: CreateTicketDto) {
    return this.supportService.create(customerId, dto);
  }
}

@Module({
  controllers: [SupportController],
  providers: [SupportService],
})
export class SupportModule {}
