import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The customer's light / dark / system appearance choice, saved on the device.
class Appearance extends ChangeNotifier {
  Appearance(this._prefs) : _mode = _parse(_prefs.getString(_key));

  static const _key = 'theme_mode';

  final SharedPreferences _prefs;
  ThemeMode _mode;

  ThemeMode get mode => _mode;

  Future<void> setMode(ThemeMode mode) async {
    if (mode == _mode) return;
    _mode = mode;
    notifyListeners();
    await _prefs.setString(_key, mode.name);
  }

  /// The brightness to draw with, given the phone's own setting.
  Brightness resolve(Brightness platform) => switch (_mode) {
        ThemeMode.light => Brightness.light,
        ThemeMode.dark => Brightness.dark,
        ThemeMode.system => platform,
      };

  static ThemeMode _parse(String? value) =>
      ThemeMode.values.where((m) => m.name == value).firstOrNull ?? ThemeMode.system;
}
