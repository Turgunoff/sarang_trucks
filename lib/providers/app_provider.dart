// lib/providers/app_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class AppProvider extends ChangeNotifier {
  bool _isOnboardingCompleted = false;
  bool _isLoading = false;
  bool _isFirstTime = true;

  // Getters
  bool get isOnboardingCompleted => _isOnboardingCompleted;
  bool get isLoading => _isLoading;
  bool get isFirstTime => _isFirstTime;

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

      // Check if this is the first time running the app
      _isFirstTime = !prefs.containsKey(AppConstants.onboardingKey);

      notifyListeners();

      debugPrint('📱 App settings yuklandi:');
      debugPrint('   - Onboarding yakunlangan: $_isOnboardingCompleted');
      debugPrint('   - Birinchi marta: $_isFirstTime');
    } catch (e) {
      debugPrint('❌ Settings yuklashda xatolik: $e');
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
    try {
      _isOnboardingCompleted = true;
      await _saveSettings();
      notifyListeners();
      debugPrint('✅ Onboarding muvaffaqiyatli yakunlandi va saqlandi');
    } catch (e) {
      debugPrint('❌ Onboarding yakunlashda xatolik: $e');
      // Revert the change if saving failed
      _isOnboardingCompleted = false;
      notifyListeners();
    }
  }

  // Reset onboarding (for testing or user preference)
  Future<void> resetOnboarding() async {
    try {
      _isOnboardingCompleted = false;
      await _saveSettings();
      notifyListeners();
      debugPrint('✅ Onboarding status qayta o\'rnatildi');
    } catch (e) {
      debugPrint('❌ Onboarding qayta o\'rnatishda xatolik: $e');
    }
  }

  // Check if onboarding is completed (with error handling)
  Future<bool> checkOnboardingStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final status = prefs.getBool(AppConstants.onboardingKey) ?? false;
      _isOnboardingCompleted = status;
      notifyListeners();
      debugPrint(
        '📱 Onboarding status: ${status ? "Yakunlangan" : "Yakunlanmagan"}',
      );
      return status;
    } catch (e) {
      debugPrint('❌ Onboarding status tekshirishda xatolik: $e');
      return false;
    }
  }

  // Set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
