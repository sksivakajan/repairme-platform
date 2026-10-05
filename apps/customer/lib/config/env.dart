import 'package:firebase_core/firebase_core.dart';

/// Build-time configuration, passed with --dart-define (see README).
class Env {
  /// The RepairMe API. 10.0.2.2 is the host machine from the Android emulator.
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000',
  );

  // Firebase web/app config values are public identifiers, not secrets.
  static const _firebaseProjectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
  static const _firebaseApiKey = String.fromEnvironment('FIREBASE_API_KEY');
  static const _firebaseAppId = String.fromEnvironment('FIREBASE_APP_ID');
  static const _firebaseSenderId = String.fromEnvironment('FIREBASE_SENDER_ID');

  /// Real SMS login when Firebase is configured; otherwise development login
  /// (any number, code 123456) against an API running with AUTH_DEV_BYPASS.
  static bool get useFirebase => _firebaseProjectId.isNotEmpty;

  static FirebaseOptions get firebaseOptions => const FirebaseOptions(
        apiKey: _firebaseApiKey,
        appId: _firebaseAppId,
        messagingSenderId: _firebaseSenderId,
        projectId: _firebaseProjectId,
      );

  static const devOtpCode = '123456';

  // Company details and links, passed with --dart-define (see README). They are
  // empty until RepairMe provides the real ones; screens show only what is set.
  static const supportPhone = String.fromEnvironment('REPAIRME_SUPPORT_PHONE');
  static const supportEmail = String.fromEnvironment('REPAIRME_SUPPORT_EMAIL');
  static const supportChat = String.fromEnvironment('REPAIRME_SUPPORT_CHAT');
  static const email = String.fromEnvironment('REPAIRME_EMAIL');
  static const privacyEmail = String.fromEnvironment('REPAIRME_PRIVACY_EMAIL');
  static const phone = String.fromEnvironment('REPAIRME_PHONE');
  static const website = String.fromEnvironment('REPAIRME_WEBSITE');
  static const address = String.fromEnvironment('REPAIRME_ADDRESS');
  static const instagramUrl = String.fromEnvironment('REPAIRME_INSTAGRAM_URL');
  static const facebookUrl = String.fromEnvironment('REPAIRME_FACEBOOK_URL');
  static const linkedinUrl = String.fromEnvironment('REPAIRME_LINKEDIN_URL');
}
