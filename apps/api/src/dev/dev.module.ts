import {
  Body,
  CanActivate,
  Controller,
  Get,
  HttpCode,
  Injectable,
  Module,
  NotFoundException,
  Param,
  ParseUUIDPipe,
  Post,
  UnprocessableEntityException,
  UseGuards,
} from '@nestjs/common';
import { IsInt, IsOptional, IsUUID, Matches, Max, Min } from 'class-validator';
import { Public } from '../auth/decorators.js';
import { SendMessageDto, SendQuotationDto } from '../bookings/booking.dto.js';
import { BookingsModule } from '../bookings/bookings.module.js';
import { ChatService } from '../bookings/chat.service.js';
import { TechnicianActionsService } from '../bookings/technician-actions.service.js';
import { AppConfig } from '../config/app-config.js';
import { PrismaService } from '../database/prisma.service.js';

/** Hides every /v1/dev route unless DEV_TOOLS=true (never allowed in production). */
@Injectable()
class DevToolsGuard implements CanActivate {
  constructor(private readonly config: AppConfig) {}

  canActivate(): boolean {
    if (!this.config.devTools) throw new NotFoundException();
    return true;
  }
}

class AssignDto {
  @IsOptional()
  @IsUUID()
  technicianId?: string;
}

class EnRouteDto {
  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(240)
  etaMinutes?: number;
}

class ArriveDto {
  @Matches(/^\d{4}$/)
  jobCode: string;
}

/**
 * Development-only simulator for the technician and operator side, so the
 * customer app can be exercised end to end before those apps exist.
 */
@Public()
@UseGuards(DevToolsGuard)
@Controller('dev')
class DevController {
  constructor(
    private readonly prisma: PrismaService,
    private readonly actions: TechnicianActionsService,
    private readonly chat: ChatService,
  ) {}

  @Get('technicians')
  technicians() {
    return this.prisma.technician.findMany({
      select: {
        id: true,
        displayName: true,
        status: true,
        isOnline: true,
        categories: { select: { category: { select: { slug: true } } } },
      },
    });
  }

  @Post('bookings/:id/escalate')
  @HttpCode(204)
  async escalate(@Param('id', ParseUUIDPipe) id: string): Promise<void> {
    await this.actions.escalateToOperator(id);
  }

  @Post('bookings/:id/assign')
  @HttpCode(204)
  async assign(
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: AssignDto,
  ): Promise<void> {
    const technicianId = dto.technicianId ?? (await this.pickTechnician(id));
    await this.actions.assign(id, technicianId);
  }

  @Post('bookings/:id/en-route')
  @HttpCode(204)
  async enRoute(
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: EnRouteDto,
  ): Promise<void> {
    await this.actions.startTravel(await this.technicianOf(id), id, dto.etaMinutes ?? 18);
  }

  @Post('bookings/:id/arrive')
  @HttpCode(204)
  async arrive(
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: ArriveDto,
  ): Promise<void> {
    await this.actions.arrive(await this.technicianOf(id), id, dto.jobCode);
  }

  @Post('bookings/:id/quote')
  @HttpCode(204)
  async quote(
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: SendQuotationDto,
  ): Promise<void> {
    await this.actions.sendQuotation(await this.technicianOf(id), id, dto);
  }

  @Post('bookings/:id/complete')
  @HttpCode(204)
  async complete(@Param('id', ParseUUIDPipe) id: string): Promise<void> {
    await this.actions.complete(await this.technicianOf(id), id);
  }

  @Post('bookings/:id/confirm-cash')
  @HttpCode(204)
  async confirmCash(@Param('id', ParseUUIDPipe) id: string): Promise<void> {
    await this.actions.confirmCashPayment(await this.technicianOf(id), id);
  }

  @Post('bookings/:id/messages')
  async message(
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: SendMessageDto,
  ) {
    const booking = await this.prisma.booking.findUnique({
      where: { id },
      select: { technician: { select: { userId: true } } },
    });
    if (!booking?.technician) {
      throw new UnprocessableEntityException('No technician assigned');
    }
    return this.chat.send(booking.technician.userId, id, dto.body);
  }

  private async pickTechnician(bookingId: string): Promise<string> {
    const booking = await this.prisma.booking.findUnique({
      where: { id: bookingId },
      select: { categoryId: true },
    });
    if (!booking) throw new NotFoundException('Booking not found');
    const technician = await this.prisma.technician.findFirst({
      where: {
        status: 'VERIFIED',
        categories: { some: { categoryId: booking.categoryId } },
      },
      orderBy: { jobsCompleted: 'desc' },
      select: { id: true },
    });
    if (!technician) {
      throw new UnprocessableEntityException(
        'No verified technician for this service. Run the database seed.',
      );
    }
    return technician.id;
  }

  private async technicianOf(bookingId: string): Promise<string> {
    const booking = await this.prisma.booking.findUnique({
      where: { id: bookingId },
      select: { technicianId: true },
    });
    if (!booking) throw new NotFoundException('Booking not found');
    if (!booking.technicianId) {
      throw new UnprocessableEntityException('No technician assigned yet');
    }
    return booking.technicianId;
  }
}

@Module({
  imports: [BookingsModule],
  controllers: [DevController],
  providers: [DevToolsGuard],
})
export class DevModule {}
