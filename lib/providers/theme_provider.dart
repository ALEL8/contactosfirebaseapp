// providers/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:myapp/services/preferences_services.dart';


class ThemeProvider with ChangeNotifier {
  final PreferencesService _preferencesService = PreferencesService();
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadTheme();
  }

  void _loadTheme() async {
    _isDarkMode = await _preferencesService.isDarkMode();
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _preferencesService.setDarkMode(_isDarkMode);
    notifyListeners();
  }

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
}
