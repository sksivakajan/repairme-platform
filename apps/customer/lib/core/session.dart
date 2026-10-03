import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/env.dart';

enum SessionStatus { loading, signedOut, signedIn }

/// Sign-in state. Uses Firebase phone auth when configured, otherwise the
/// development login accepted by the API's AUTH_DEV_BYPASS.
class Session extends ChangeNotifier {
  Session(this._prefs);

  final SharedPreferences _prefs;
  static const _devPhoneKey = 'dev_phone';
  static const _onboardedKey = 'onboarded';

  SessionStatus status = SessionStatus.loading;
  String? phoneNumber;
  String? _verificationId;
  int? _resendToken;
  StreamSubscription<User?>? _authSub;

  bool get hasOnboarded => _prefs.getBool(_onboardedKey) ?? false;

  Future<void> markOnboarded() => _prefs.setBool(_onboardedKey, true);

  void start() {
    if (Env.useFirebase) {
      _authSub = FirebaseAuth.instance.authStateChanges().listen((user) {
        phoneNumber = user?.phoneNumber;
        _set(user == null ? SessionStatus.signedOut : SessionStatus.signedIn);
      });
    } else {
      phoneNumber = _prefs.getString(_devPhoneKey);
      _set(phoneNumber == null ? SessionStatus.signedOut : SessionStatus.signedIn);
    }
  }

  /// The Authorization header for API calls.
  Future<String?> authHeader() async {
    if (Env.useFirebase) {
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      return token == null ? null : 'Bearer $token';
    }
    return phoneNumber == null ? null : 'Dev $phoneNumber';
  }

  /// Sends the SMS code. Completes when the code is sent (or auto-verified).
  Future<void> sendCode(String e164Phone) async {
    phoneNumber = e164Phone;
    if (!Env.useFirebase) return;

    final completer = Completer<void>();
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: e164Phone,
      forceResendingToken: _resendToken,
      verificationCompleted: (credential) async {
        // Android can read the SMS automatically.
        await FirebaseAuth.instance.signInWithCredential(credential);
        if (!completer.isCompleted) completer.complete();
      },
      verificationFailed: (error) {
        if (!completer.isCompleted) {
          completer.completeError(_friendlyError(error));
        }
      },
      codeSent: (verificationId, resendToken) {
        _verificationId = verificationId;
        _resendToken = resendToken;
        if (!completer.isCompleted) completer.complete();
      },
      codeAutoRetrievalTimeout: (verificationId) => _verificationId = verificationId,
    );
    return completer.future;
  }

  Future<void> verifyCode(String code) async {
    if (!Env.useFirebase) {
      if (code != Env.devOtpCode) throw 'Incorrect code. In development use ${Env.devOtpCode}.';
      await _prefs.setString(_devPhoneKey, phoneNumber!);
      _set(SessionStatus.signedIn);
      return;
    }
    final verificationId = _verificationId;
    if (verificationId == null) throw 'Please request a new code.';
    try {
      await FirebaseAuth.instance.signInWithCredential(
        PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code),
      );
    } on FirebaseAuthException catch (error) {
      throw _friendlyError(error);
    }
  }

  Future<void> signOut() async {
    if (Env.useFirebase) {
      await FirebaseAuth.instance.signOut();
    } else {
      await _prefs.remove(_devPhoneKey);
      phoneNumber = null;
      _set(SessionStatus.signedOut);
    }
  }

  void _set(SessionStatus next) {
    status = next;
    notifyListeners();
  }

  static String _friendlyError(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-verification-code':
        return 'Incorrect code. Please check the SMS and try again.';
      case 'invalid-phone-number':
        return 'That mobile number is not valid.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait and try again.';
      case 'session-expired':
        return 'The code expired. Please request a new one.';
      default:
        return error.message ?? 'Sign-in failed. Please try again.';
    }
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}
