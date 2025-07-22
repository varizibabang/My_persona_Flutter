import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService with ChangeNotifier {
  bool _darkMode;
  static const String _themeKey = 'isDarkMode';

  ThemeService({bool initialDarkMode = true}) : _darkMode = initialDarkMode {
    _loadThemeFromPreferences();
  }

  bool get darkMode => _darkMode;

  Future<void> _loadThemeFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _darkMode = prefs.getBool(_themeKey) ?? false; // Default to light mode if not set
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _darkMode = !_darkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _darkMode);
    notifyListeners();
  }
}
