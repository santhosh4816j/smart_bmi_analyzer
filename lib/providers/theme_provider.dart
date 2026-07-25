import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';
import '../theme/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider(this._prefs) {
    _restore();
  }

  final SharedPreferences _prefs;

  ThemeMode _themeMode = ThemeMode.system;
  Color _accentColor = AppTheme.accentOptions.first;

  ThemeMode get themeMode => _themeMode;
  Color get accentColor => _accentColor;

  void _restore() {
    final String? modeStr = _prefs.getString(AppConstants.prefThemeMode);
    _themeMode = switch (modeStr) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };

    final int? accentValue = _prefs.getInt(AppConstants.prefAccentColor);
    if (accentValue != null) {
      _accentColor = Color(accentValue);
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    await _prefs.setString(AppConstants.prefThemeMode, mode.name);
  }

  Future<void> setAccentColor(Color color) async {
    _accentColor = color;
    notifyListeners();
    await _prefs.setInt(AppConstants.prefAccentColor, color.toARGB32());
  }
}
