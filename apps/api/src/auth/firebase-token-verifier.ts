import { Injectable, Logger } from '@nestjs/common';
import { getApps, initializeApp, type App } from 'firebase-admin/app';
import { getAuth } from 'firebase-admin/auth';
import { AppConfig } from '../config/app-config.js';
import type { VerifiedIdentity } from './auth-user.js';

/**
 * Verifies Firebase Authentication ID tokens. Only the project ID is needed:
 * signatures are checked against Google's public keys, so no service account
 * secret is involved.
 */
@Injectable()
export class FirebaseTokenVerifier {
  private readonly logger = new Logger(FirebaseTokenVerifier.name);
  private readonly app: App | undefined;

  constructor(config: AppConfig) {
    if (!config.firebaseProjectId) {
      this.logger.warn(
        'FIREBASE_PROJECT_ID is not set: Firebase sign-in is disabled',
      );
      return;
    }
    this.app =
      getApps().find((app) => app.name === 'repairme') ??
      initializeApp({ projectId: config.firebaseProjectId }, 'repairme');
  }

  /** Returns the identity, or null when the token is invalid or Firebase is disabled. */
  async verify(idToken: string): Promise<VerifiedIdentity | null> {
    if (!this.app) return null;
    try {
      const decoded = await getAuth(this.app).verifyIdToken(idToken);
      return {
        firebaseUid: decoded.uid,
        phoneNumber: decoded.phone_number ?? null,
        authTime: decoded.auth_time ?? null,
      };
    } catch (error) {
      this.logger.debug(`Rejected Firebase ID token: ${String(error)}`);
      return null;
    }
  }
}
