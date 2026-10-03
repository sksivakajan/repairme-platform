import { Module } from '@nestjs/common';
import { BookingLifecycleService } from './booking-lifecycle.service.js';
import { BookingsController } from './bookings.controller.js';
import { BookingsService } from './bookings.service.js';
import { ChatService } from './chat.service.js';
import { ConversationsController } from './conversations.controller.js';
import { PhotosService } from './photos.service.js';
import { TechnicianActionsService } from './technician-actions.service.js';

@Module({
  controllers: [BookingsController, ConversationsController],
  providers: [
    BookingsService,
    BookingLifecycleService,
    ChatService,
    PhotosService,
    TechnicianActionsService,
  ],
  exports: [TechnicianActionsService, ChatService],
})
export class BookingsModule {}
