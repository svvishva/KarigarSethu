import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ValueNotifier<ThemeMode> {
  static const String _themePrefKey = 'theme_preference';

  ThemeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final String? themeStr = prefs.getString(_themePrefKey);
    
    if (themeStr == 'light') {
      value = ThemeMode.light;
    } else if (themeStr == 'dark') {
      value = ThemeMode.dark;
    } else {
      value = ThemeMode.system;
    }
  }

  Future<void> setTheme(ThemeMode mode) async {
    value = mode;
    final prefs = await SharedPreferences.getInstance();
    if (mode == ThemeMode.light) {
      await prefs.setString(_themePrefKey, 'light');
    } else if (mode == ThemeMode.dark) {
      await prefs.setString(_themePrefKey, 'dark');
    } else {
      await prefs.setString(_themePrefKey, 'system');
    }
  }
}
