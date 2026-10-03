import {
  CanActivate,
  ExecutionContext,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { AppConfig } from '../config/app-config.js';
import { E164_PHONE, type VerifiedIdentity } from './auth-user.js';
import { AuthService } from './auth.service.js';
import { IS_PUBLIC, type AuthenticatedRequest } from './decorators.js';
import { FirebaseTokenVerifier } from './firebase-token-verifier.js';

/**
 * Global guard. Every route requires `Authorization: Bearer <Firebase ID token>`
 * unless marked @Public(). In development, `Authorization: Dev <+94…>` is
 * accepted when AUTH_DEV_BYPASS=true (refused at startup in production).
 */
@Injectable()
export class AuthGuard implements CanActivate {
  constructor(
    private readonly reflector: Reflector,
    private readonly config: AppConfig,
    private readonly verifier: FirebaseTokenVerifier,
    private readonly authService: AuthService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const isPublic = this.reflector.getAllAndOverride<boolean>(IS_PUBLIC, [
      context.getHandler(),
      context.getClass(),
    ]);
    if (isPublic) return true;

    const request = context.switchToHttp().getRequest<AuthenticatedRequest>();
    const identity = await this.identify(request.headers.authorization);
    if (!identity) throw new UnauthorizedException();

    request.authUser = await this.authService.resolveUser(identity);
    return true;
  }

  private async identify(
    header: string | undefined,
  ): Promise<VerifiedIdentity | null> {
    const [scheme, credential] = header?.split(' ') ?? [];
    if (!credential) return null;

    if (scheme === 'Bearer') {
      return this.verifier.verify(credential);
    }
    if (scheme === 'Dev' && this.config.authDevBypass) {
      return E164_PHONE.test(credential)
        ? { firebaseUid: `dev:${credential}`, phoneNumber: credential }
        : null;
    }
    return null;
  }
}
