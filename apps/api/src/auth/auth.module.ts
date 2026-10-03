import { Module } from '@nestjs/common';
import { APP_GUARD } from '@nestjs/core';
import { AuthGuard } from './auth.guard.js';
import { AuthService } from './auth.service.js';
import { FirebaseTokenVerifier } from './firebase-token-verifier.js';

@Module({
  providers: [
    AuthService,
    FirebaseTokenVerifier,
    { provide: APP_GUARD, useClass: AuthGuard },
  ],
})
export class AuthModule {}
