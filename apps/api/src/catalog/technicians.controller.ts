import { Controller, Get } from '@nestjs/common';
import { TechniciansService } from './technicians.service.js';

@Controller('technicians')
export class TechniciansController {
  constructor(private readonly techniciansService: TechniciansService) {}

  /** Best-rated verified technicians, for the customer home screen. */
  @Get('top-rated')
  topRated() {
    return this.techniciansService.topRated();
  }
}
