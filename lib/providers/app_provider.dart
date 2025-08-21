import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class AppProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  String _language = AppConstants.uzLanguage;
  bool _isOnboardingCompleted = false;
  bool _isLoading = false;

  // Getters
  ThemeMode get themeMode => _themeMode;
  String get language => _language;
  bool get isOnboardingCompleted => _isOnboardingCompleted;
  bool get isLoading => _isLoading;

  AppProvider() {
    _loadSettings();
  }

  // Load saved settings
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load theme
      final themeString = prefs.getString(AppConstants.themeKey);
      if (themeString != null) {
        switch (themeString) {
          case AppConstants.lightTheme:
            _themeMode = ThemeMode.light;
            break;
          case AppConstants.darkTheme:
            _themeMode = ThemeMode.dark;
            break;
          case AppConstants.systemTheme:
            _themeMode = ThemeMode.system;
            break;
        }
      }

      // Load language
      final languageString = prefs.getString(AppConstants.languageKey);
      if (languageString != null) {
        _language = languageString;
      }

      // Load onboarding status
      _isOnboardingCompleted = prefs.getBool(AppConstants.onboardingKey) ?? false;

      notifyListeners();
    } catch (e) {
      debugPrint('Settings yuklashda xatolik: $e');
    }
  }

  // Save settings
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save theme
      String themeString;
      switch (_themeMode) {
        case ThemeMode.light:
          themeString = AppConstants.lightTheme;
          break;
        case ThemeMode.dark:
          themeString = AppConstants.darkTheme;
          break;
        case ThemeMode.system:
          themeString = AppConstants.systemTheme;
          break;
      }
      await prefs.setString(AppConstants.themeKey, themeString);

      // Save language
      await prefs.setString(AppConstants.languageKey, _language);

      // Save onboarding status
      await prefs.setBool(AppConstants.onboardingKey, _isOnboardingCompleted);
    } catch (e) {
      debugPrint('Settings saqlashda xatolik: $e');
    }
  }

  // Change theme
  Future<void> changeTheme(ThemeMode themeMode) async {
    _themeMode = themeMode;
    await _saveSettings();
    notifyListeners();
  }

  // Change language
  Future<void> changeLanguage(String language) async {
    _language = language;
    await _saveSettings();
    notifyListeners();
  }

  // Complete onboarding
  Future<void> completeOnboarding() async {
    _isOnboardingCompleted = true;
    await _saveSettings();
    notifyListeners();
  }

  // Set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Get localized text
  String getLocalizedText(String uzbekText, String russianText) {
    return _language == AppConstants.uzLanguage ? uzbekText : russianText;
  }

  // Get current locale
  Locale getCurrentLocale() {
    return Locale(_language);
  }
}
