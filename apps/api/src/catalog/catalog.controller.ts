import { Controller, Get } from '@nestjs/common';
import { Public } from '../auth/decorators.js';
import { CatalogService } from './catalog.service.js';

@Controller('service-categories')
export class CatalogController {
  constructor(private readonly catalogService: CatalogService) {}

  @Public()
  @Get()
  list() {
    return this.catalogService.listCategories();
  }
}
