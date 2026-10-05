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

  await initializeDateFormatting();
  final prefs = await SharedPreferences.getInstance();
  final session = Session(prefs);
  final repo = Repository(ApiClient(authHeader: session.authHeader));
  // After the number is verified, the server says whether it already has an account.
  session.accountChecker = () async {
    final profile = await repo.profile();
    if (!profile.profileComplete) return AccountStage.needsProfile;
    return profile.pendingLegal.isEmpty ? AccountStage.ready : AccountStage.needsTerms;
  };
  session.start();
  runApp(RepairMeApp(
    session: session,
    repo: repo,
    appearance: Appearance(prefs),
    language: AppLanguage(prefs),
  ));
}
