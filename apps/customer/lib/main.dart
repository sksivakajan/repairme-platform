import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'config/env.dart';
import 'core/app_language.dart';
import 'core/appearance.dart';
import 'core/api_client.dart';
import 'core/session.dart';
import 'data/repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Env.useFirebase) {
    await Firebase.initializeApp(options: Env.firebaseOptions);
  }

  // Only the three languages the app has, not all ~400 that the date library knows.
  await Future.wait([for (final locale in const ['en', 'si', 'ta']) initializeDateFormatting(locale)]);
  final prefs = await SharedPreferences.getInstance();
  final session = Session(prefs);
  final repo = Repository(ApiClient(authHeader: session.authHeader));
  // After the number is verified, the server says whether it already has an account.
  session.accountChecker = () async {
    final profile = await repo.profile();
    repo.primeProfile(profile); // Home reuses this instead of asking again
    if (!profile.profileComplete) return AccountStage.needsProfile;
    return profile.pendingLegal.isEmpty ? AccountStage.ready : AccountStage.needsTerms;
  };
  // Nothing cached for one customer may be shown to the next.
  session.addListener(() {
    if (session.status == SessionStatus.signedOut) repo.clearCache();
  });
  session.start();
  runApp(RepairMeApp(
    session: session,
    repo: repo,
    appearance: Appearance(prefs),
    language: AppLanguage(prefs),
  ));
}
