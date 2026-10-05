import { Controller, Get, Param } from '@nestjs/common';
import { Public } from '../auth/decorators.js';
import { LegalService } from './legal.service.js';

/** The published policies. Public, because the sign-in screen links to them. */
@Controller('legal/documents')
export class LegalController {
  constructor(private readonly legalService: LegalService) {}

  @Public()
  @Get()
  list() {
    return this.legalService.list();
  }

  @Public()
  @Get(':type')
  get(@Param('type') type: string) {
    return this.legalService.get(type);
  }
}
