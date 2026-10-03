import { Controller, Get } from '@nestjs/common';
import type { AuthUser } from '../auth/auth-user.js';
import { CurrentUser, CustomerId } from '../auth/decorators.js';
import { ChatService } from './chat.service.js';

@Controller('conversations')
export class ConversationsController {
  constructor(private readonly chatService: ChatService) {}

  /** The customer's chats with their technicians, most recent first. */
  @Get()
  list(@CurrentUser() user: AuthUser, @CustomerId() customerId: string) {
    return this.chatService.conversations(user.userId, customerId);
  }
}
