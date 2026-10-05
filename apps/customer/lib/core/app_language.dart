import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The customer's language (English / Sinhala / Tamil), saved on the device.
/// Until they choose one it follows the phone's language, falling back to English.
class AppLanguage extends ChangeNotifier {
  AppLanguage(this._prefs) : _code = _prefs.getString(_key) ?? _fromPhone();

  static const _key = 'language';

  /// Server codes (the API's `Language` enum) with the name shown in each language.
  static const names = {'EN': 'English', 'SI': 'සිංහල', 'TA': 'தமிழ்'};

  final SharedPreferences _prefs;
  String _code;

  /// "EN", "SI" or "TA".
  String get code => _code;

  Locale get locale => Locale(_code.toLowerCase());

  Future<void> set(String code) async {
    if (code == _code || !names.containsKey(code)) return;
    _code = code;
    notifyListeners();
    await _prefs.setString(_key, code);
  }

  static String _fromPhone() {
    final code = WidgetsBinding.instance.platformDispatcher.locale.languageCode.toUpperCase();
    return names.containsKey(code) ? code : 'EN';
  }
}
