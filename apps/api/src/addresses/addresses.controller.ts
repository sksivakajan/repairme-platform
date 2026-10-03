import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  Param,
  ParseUUIDPipe,
  Post,
  Put,
} from '@nestjs/common';
import { CustomerId } from '../auth/decorators.js';
import { CreateAddressDto } from './address.dto.js';
import { AddressesService } from './addresses.service.js';

@Controller('addresses')
export class AddressesController {
  constructor(private readonly addressesService: AddressesService) {}

  @Get()
  list(@CustomerId() customerId: string) {
    return this.addressesService.list(customerId);
  }

  @Post()
  create(@CustomerId() customerId: string, @Body() dto: CreateAddressDto) {
    return this.addressesService.create(customerId, dto);
  }

  @Put(':id')
  update(
    @CustomerId() customerId: string,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: CreateAddressDto,
  ) {
    return this.addressesService.update(customerId, id, dto);
  }

  @Delete(':id')
  @HttpCode(204)
  async remove(
    @CustomerId() customerId: string,
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<void> {
    await this.addressesService.remove(customerId, id);
  }
}
