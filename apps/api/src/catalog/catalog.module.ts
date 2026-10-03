import { Module } from '@nestjs/common';
import { CatalogController } from './catalog.controller.js';
import { CatalogService } from './catalog.service.js';
import { TechniciansController } from './technicians.controller.js';
import { TechniciansService } from './technicians.service.js';

@Module({
  controllers: [CatalogController, TechniciansController],
  providers: [CatalogService, TechniciansService],
})
export class CatalogModule {}
