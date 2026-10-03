import {
  BadRequestException,
  Body,
  Controller,
  Get,
  Param,
  ParseUUIDPipe,
  Post,
  Query,
  StreamableFile,
  UploadedFile,
  UseInterceptors,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import type { AuthUser } from '../auth/auth-user.js';
import { CurrentUser, CustomerId } from '../auth/decorators.js';
import {
  CancelBookingDto,
  CreateBookingDto,
  CreateReviewDto,
  ListBookingsQueryDto,
  PayBookingDto,
  SendMessageDto,
} from './booking.dto.js';
import { BookingsService } from './bookings.service.js';
import { ChatService } from './chat.service.js';
import { MAX_PHOTO_BYTES, PhotosService } from './photos.service.js';

@Controller('bookings')
export class BookingsController {
  constructor(
    private readonly bookingsService: BookingsService,
    private readonly chatService: ChatService,
    private readonly photosService: PhotosService,
  ) {}

  @Post()
  create(
    @CurrentUser() user: AuthUser,
    @CustomerId() customerId: string,
    @Body() dto: CreateBookingDto,
  ) {
    return this.bookingsService.create(user, customerId, dto);
  }

  @Get()
  list(@CustomerId() customerId: string, @Query() query: ListBookingsQueryDto) {
    return this.bookingsService.list(customerId, query.tab);
  }

  @Get(':id')
  get(
    @CurrentUser() user: AuthUser,
    @CustomerId() customerId: string,
    @Param('id', ParseUUIDPipe) id: string,
  ) {
    return this.bookingsService.get(user, customerId, id);
  }

  @Post(':id/cancel')
  cancel(
    @CurrentUser() user: AuthUser,
    @CustomerId() customerId: string,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: CancelBookingDto,
  ) {
    return this.bookingsService.cancel(user, customerId, id, dto);
  }

  @Post(':id/quotations/:quotationId/approve')
  approveQuotation(
    @CurrentUser() user: AuthUser,
    @CustomerId() customerId: string,
    @Param('id', ParseUUIDPipe) id: string,
    @Param('quotationId', ParseUUIDPipe) quotationId: string,
  ) {
    return this.bookingsService.decideQuotation(user, customerId, id, quotationId, true);
  }

  @Post(':id/quotations/:quotationId/decline')
  declineQuotation(
    @CurrentUser() user: AuthUser,
    @CustomerId() customerId: string,
    @Param('id', ParseUUIDPipe) id: string,
    @Param('quotationId', ParseUUIDPipe) quotationId: string,
  ) {
    return this.bookingsService.decideQuotation(user, customerId, id, quotationId, false);
  }

  @Post(':id/payment')
  pay(
    @CurrentUser() user: AuthUser,
    @CustomerId() customerId: string,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: PayBookingDto,
  ) {
    return this.bookingsService.choosePaymentMethod(user, customerId, id, dto);
  }

  @Post(':id/review')
  review(
    @CurrentUser() user: AuthUser,
    @CustomerId() customerId: string,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: CreateReviewDto,
  ) {
    return this.bookingsService.review(user, customerId, id, dto);
  }

  @Get(':id/messages')
  messages(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseUUIDPipe) id: string,
  ) {
    return this.chatService.list(user.userId, id);
  }

  @Post(':id/messages')
  sendMessage(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: SendMessageDto,
  ) {
    return this.chatService.send(user.userId, id, dto.body);
  }

  @Post(':id/photos')
  @UseInterceptors(
    FileInterceptor('file', { limits: { fileSize: MAX_PHOTO_BYTES, files: 1 } }),
  )
  uploadPhoto(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseUUIDPipe) id: string,
    @UploadedFile() file: Express.Multer.File | undefined,
  ) {
    if (!file) throw new BadRequestException('Attach an image as "file"');
    return this.photosService.upload(user.userId, id, 'PROBLEM', file.buffer);
  }

  @Get(':id/photos/:photoId')
  async photo(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseUUIDPipe) id: string,
    @Param('photoId', ParseUUIDPipe) photoId: string,
  ): Promise<StreamableFile> {
    const photo = await this.photosService.open(user.userId, id, photoId);
    return new StreamableFile(photo.stream, {
      type: photo.contentType,
      length: photo.sizeBytes,
    });
  }
}
