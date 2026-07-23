import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/models/user_profile.dart';

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _load();
  }

  static const _key = 'theme_mode';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    switch (saved) {
      case 'light':
        state = ThemeMode.light;
        break;
      case 'dark':
        state = ThemeMode.dark;
        break;
      default:
        state = ThemeMode.system;
    }
  }

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.name);
  }
}

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class UnitSystemNotifier extends StateNotifier<UnitSystem> {
  UnitSystemNotifier() : super(UnitSystem.metric) {
    _load();
  }

  static const _key = 'unit_system';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    state = saved == 'imperial' ? UnitSystem.imperial : UnitSystem.metric;
  }

  Future<void> setUnit(UnitSystem unit) async {
    state = unit;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, unit.name);
  }
}

final unitSystemProvider =
    StateNotifierProvider<UnitSystemNotifier, UnitSystem>((ref) {
  return UnitSystemNotifier();
});
