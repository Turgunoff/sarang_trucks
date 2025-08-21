// lib/providers/app_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class AppProvider extends ChangeNotifier {
  bool _isOnboardingCompleted = false;
  bool _isLoading = false;

  // Getters
  bool get isOnboardingCompleted => _isOnboardingCompleted;
  bool get isLoading => _isLoading;

  AppProvider() {
    _loadSettings();
  }

  // Load saved settings
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load onboarding status
      _isOnboardingCompleted =
          prefs.getBool(AppConstants.onboardingKey) ?? false;

      notifyListeners();
    } catch (e) {
      debugPrint('Settings yuklashda xatolik: $e');
    }
  }

  // Save settings
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save onboarding status
      await prefs.setBool(AppConstants.onboardingKey, _isOnboardingCompleted);
    } catch (e) {
      debugPrint('Settings saqlashda xatolik: $e');
    }
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
}
