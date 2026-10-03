import {
  createParamDecorator,
  ExecutionContext,
  ForbiddenException,
  SetMetadata,
} from '@nestjs/common';
import type { Request } from 'express';
import type { AuthUser } from './auth-user.js';

export const IS_PUBLIC = 'isPublic';

/** Marks a route as reachable without authentication. */
export const Public = () => SetMetadata(IS_PUBLIC, true);

export type AuthenticatedRequest = Request & { authUser?: AuthUser };

/** The authenticated user. */
export const CurrentUser = createParamDecorator(
  (_data: unknown, ctx: ExecutionContext): AuthUser => {
    const user = ctx.switchToHttp().getRequest<AuthenticatedRequest>().authUser;
    if (!user) throw new ForbiddenException();
    return user;
  },
);

/** The authenticated user's customer ID; rejects callers without a customer profile. */
export const CustomerId = createParamDecorator(
  (_data: unknown, ctx: ExecutionContext): string => {
    const user = ctx.switchToHttp().getRequest<AuthenticatedRequest>().authUser;
    if (!user?.customerId) {
      throw new ForbiddenException('A customer account is required');
    }
    return user.customerId;
  },
);
