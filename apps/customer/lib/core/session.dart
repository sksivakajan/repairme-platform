import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/env.dart';

/// Where the customer is in sign-in.
///
/// signedOut -> (number + code) -> needsProfile (new number), needsTerms (the
/// current Terms & Privacy not accepted yet) or signedIn. offline means we could not ask the server which of
/// the two it is.
enum SessionStatus { loading, signedOut, needsProfile, needsTerms, signedIn, offline }

/// What the server says is still missing for a verified number.
enum AccountStage { needsProfile, needsTerms, ready }

enum AuthIssue {
  incorrectCodeDev,
  requestNewCode,
  incorrectCode,
  invalidPhone,
  tooManyAttempts,
  expired,
  phoneInUse,
  failed,
}

/// A sign-in problem. The screen turns it into text in the customer's language.
class AuthError implements Exception {
  const AuthError(this.issue, {this.detail});

  final AuthIssue issue;

  /// Extra text for the message (the development code), or the provider's own message.
  final String? detail;

  @override
  String toString() => detail ?? issue.name;
}

/// Sign-in state. Uses Firebase phone auth when configured, otherwise the
/// development login accepted by the API's AUTH_DEV_BYPASS. Firebase keeps the
/// customer signed in between app launches until they log out.
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

  /// Set by main(): asks the server whether this verified number already has a
  /// finished account (true) or is new and still has to complete its profile.
  Future<AccountStage> Function()? accountChecker;

  // For re-verifying the number (change number, delete account) without
  // touching the sign-in verification above.
  String? _extraVerificationId;
  PhoneAuthCredential? _extraAutoCredential;

  bool get hasOnboarded => _prefs.getBool(_onboardedKey) ?? false;

  Future<void> markOnboarded() => _prefs.setBool(_onboardedKey, true);

  void start() {
    if (Env.useFirebase) {
      _authSub = FirebaseAuth.instance.authStateChanges().listen((user) {
        phoneNumber = user?.phoneNumber;
        if (user == null) {
          _set(SessionStatus.signedOut);
        } else {
          resolveAccount();
        }
      });
    } else {
      phoneNumber = _prefs.getString(_devPhoneKey);
      if (phoneNumber == null) {
        _set(SessionStatus.signedOut);
      } else {
        resolveAccount();
      }
    }
  }

  bool get _hasCredentials => Env.useFirebase ? FirebaseAuth.instance.currentUser != null : _prefs.getString(_devPhoneKey) != null;

  /// Decides between Home and "Complete your profile". Retries briefly, then
  /// shows the offline screen rather than guessing.
  Future<void> resolveAccount() async {
    final check = accountChecker;
    if (check == null) {
      _set(SessionStatus.signedIn);
      return;
    }
    for (var attempt = 0; attempt < 3; attempt++) {
      try {
        final stage = await check();
        if (!_hasCredentials) return; // signed out while we were asking
        _set(switch (stage) {
          AccountStage.needsProfile => SessionStatus.needsProfile,
          AccountStage.needsTerms => SessionStatus.needsTerms,
          AccountStage.ready => SessionStatus.signedIn,
        });
        return;
      } catch (_) {
        if (!_hasCredentials) return;
        await Future<void>.delayed(Duration(milliseconds: 600 * (attempt + 1)));
      }
    }
    if (_hasCredentials) _set(SessionStatus.offline);
  }

  /// The profile was just completed: the account now exists.
  void profileCompleted() => _set(SessionStatus.signedIn);

  /// The customer accepted the current Terms & Privacy Policy.
  void termsAccepted() => _set(SessionStatus.signedIn);

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
      if (code != Env.devOtpCode) throw const AuthError(AuthIssue.incorrectCodeDev, detail: Env.devOtpCode);
      await _prefs.setString(_devPhoneKey, phoneNumber!);
      await resolveAccount();
      return;
    }
    final verificationId = _verificationId;
    if (verificationId == null) throw const AuthError(AuthIssue.requestNewCode);
    try {
      await FirebaseAuth.instance.signInWithCredential(
        PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code),
      );
    } on FirebaseAuthException catch (error) {
      throw _friendlyError(error);
    }
  }

  /// Sends a code to [e164Phone] to prove it is the customer: the current
  /// number for sensitive actions, or a new number when changing it.
  Future<void> sendVerification(String e164Phone) async {
    _extraAutoCredential = null;
    if (!Env.useFirebase) return;

    final completer = Completer<void>();
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: e164Phone,
      verificationCompleted: (credential) {
        _extraAutoCredential = credential;
        if (!completer.isCompleted) completer.complete();
      },
      verificationFailed: (error) {
        if (!completer.isCompleted) completer.completeError(_friendlyError(error));
      },
      codeSent: (verificationId, _) {
        _extraVerificationId = verificationId;
        if (!completer.isCompleted) completer.complete();
      },
      codeAutoRetrievalTimeout: (verificationId) => _extraVerificationId = verificationId,
    );
    return completer.future;
  }

  /// Checks the code from [sendVerification]. With [newPhone] the account
  /// moves to that number; without it this only refreshes the sign-in, which
  /// the server requires for deleting the account.
  Future<void> confirmVerification(String code, {String? newPhone}) async {
    if (!Env.useFirebase) {
      if (code != Env.devOtpCode) throw const AuthError(AuthIssue.incorrectCodeDev, detail: Env.devOtpCode);
      return;
    }
    final user = FirebaseAuth.instance.currentUser;
    final verificationId = _extraVerificationId;
    if (user == null || (verificationId == null && _extraAutoCredential == null)) {
      throw const AuthError(AuthIssue.requestNewCode);
    }
    final credential = _extraAutoCredential ?? PhoneAuthProvider.credential(verificationId: verificationId!, smsCode: code);
    try {
      if (newPhone == null) {
        await user.reauthenticateWithCredential(credential);
      } else {
        await user.updatePhoneNumber(credential);
        phoneNumber = newPhone;
      }
      await user.getIdToken(true);
    } on FirebaseAuthException catch (error) {
      if (error.code == 'credential-already-in-use' || error.code == 'account-exists-with-different-credential') {
        throw const AuthError(AuthIssue.phoneInUse);
      }
      throw _friendlyError(error);
    }
  }

  /// Development login only: the API switched the number, so use it from now on.
  Future<void> adoptPhone(String e164Phone) async {
    phoneNumber = e164Phone;
    if (!Env.useFirebase) await _prefs.setString(_devPhoneKey, e164Phone);
    notifyListeners();
  }

  /// Signs out and clears the saved sign-in. The account itself is untouched.
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

  static AuthError _friendlyError(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-verification-code':
        return const AuthError(AuthIssue.incorrectCode);
      case 'invalid-phone-number':
        return const AuthError(AuthIssue.invalidPhone);
      case 'too-many-requests':
        return const AuthError(AuthIssue.tooManyAttempts);
      case 'session-expired':
        return const AuthError(AuthIssue.expired);
      default:
        return const AuthError(AuthIssue.failed);
    }
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}
