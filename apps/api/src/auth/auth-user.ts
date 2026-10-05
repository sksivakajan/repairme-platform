import { UserRole } from '../generated/prisma/client.js';

/** The authenticated caller, attached to the request by AuthGuard. */
export interface AuthUser {
  userId: string;
  role: UserRole;
  phoneNumber: string | null;
  customerId: string | null;
  /** When the customer last verified their number (Unix seconds); null if unknown. */
  authTime: number | null;
}

/** Identity proven by the token, before it is mapped to a RepairMe user. */
export interface VerifiedIdentity {
  firebaseUid: string;
  phoneNumber: string | null;
  authTime: number | null;
}

export const E164_PHONE = /^\+[1-9]\d{7,14}$/;
