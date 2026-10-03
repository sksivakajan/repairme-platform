import { Module } from '@nestjs/common';
import { AddressesModule } from './addresses/addresses.module.js';
import { AuthModule } from './auth/auth.module.js';
import { BookingsModule } from './bookings/bookings.module.js';
import { CatalogModule } from './catalog/catalog.module.js';
import { ConfigModule } from './config/config.module.js';
import { PrismaModule } from './database/prisma.module.js';
import { DevModule } from './dev/dev.module.js';
import { HealthModule } from './health/health.module.js';
import { NotificationsModule } from './notifications/notifications.module.js';
import { ProfileModule } from './profile/profile.module.js';
import { SupportModule } from './support/support.module.js';

@Module({
  imports: [
    ConfigModule,
    PrismaModule,
    AuthModule,
    NotificationsModule,
    HealthModule,
    CatalogModule,
    ProfileModule,
    AddressesModule,
    BookingsModule,
    SupportModule,
    DevModule,
  ],
})
export class AppModule {}
