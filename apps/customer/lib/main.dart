import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'config/env.dart';
import 'core/appearance.dart';
import 'core/api_client.dart';
import 'core/session.dart';
import 'data/repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Env.useFirebase) {
    await Firebase.initializeApp(options: Env.firebaseOptions);
  }

  final prefs = await SharedPreferences.getInstance();
  final session = Session(prefs)..start();
  final api = ApiClient(authHeader: session.authHeader);
  runApp(RepairMeApp(session: session, repo: Repository(api), appearance: Appearance(prefs)));
}
