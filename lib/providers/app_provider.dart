// lib/providers/app_provider.dart - YAXSHILANGAN VERSIYA
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class AppProvider extends ChangeNotifier {
  bool _isOnboardingCompleted = false;
  bool _isLoading = false;
  bool _isFirstTime = true;
  bool _isInitialized = false;

  // Getters
  bool get isOnboardingCompleted => _isOnboardingCompleted;
  bool get isLoading => _isLoading;
  bool get isFirstTime => _isFirstTime;
  bool get isInitialized => _isInitialized;

  AppProvider() {
    _initialize();
  }

  // 🔧 YANGI: Initialize metodi
  Future<void> _initialize() async {
    try {
      await _loadSettings();
      _isInitialized = true;
      notifyListeners();
      debugPrint('✅ AppProvider: Muvaffaqiyatli ishga tushirildi');
    } catch (e) {
      debugPrint('❌ AppProvider: Ishga tushirishda xatolik - $e');
      _isInitialized = true;
      notifyListeners();
    }
  }

  // Load saved settings
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 🔧 YAXSHILASH: Onboarding holati
      _isOnboardingCompleted =
          prefs.getBool(AppConstants.onboardingKey) ?? false;

      // 🔧 YAXSHILASH: Birinchi marta tekshirish
      _isFirstTime = !prefs.containsKey(AppConstants.onboardingKey);

      debugPrint('📱 App settings yuklandi:');
      debugPrint('   - Onboarding yakunlangan: $_isOnboardingCompleted');
      debugPrint('   - Birinchi marta: $_isFirstTime');
      debugPrint(
        '   - Key mavjud: ${prefs.containsKey(AppConstants.onboardingKey)}',
      );
    } catch (e) {
      debugPrint('❌ Settings yuklashda xatolik: $e');
      // Default qiymatlar
      _isOnboardingCompleted = false;
      _isFirstTime = true;
    }
  }

  // Save settings
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.onboardingKey, _isOnboardingCompleted);
      debugPrint('✅ Settings saqlandi: onboarding = $_isOnboardingCompleted');
    } catch (e) {
      debugPrint('❌ Settings saqlashda xatolik: $e');
      throw Exception('Settings saqlashda xatolik: $e');
    }
  }

  // 🔧 YAXSHILANGAN: Complete onboarding
  Future<void> completeOnboarding() async {
    try {
      setLoading(true);

      _isOnboardingCompleted = true;
      _isFirstTime = false;

      await _saveSettings();

      debugPrint('✅ Onboarding muvaffaqiyatli yakunlandi va saqlandi');
    } catch (e) {
      debugPrint('❌ Onboarding yakunlashda xatolik: $e');
      // Xatolik bo'lsa, o'zgarishlarni qaytarish
      _isOnboardingCompleted = false;
      throw Exception('Onboarding yakunlashda xatolik: $e');
    } finally {
      setLoading(false);
    }
  }

  // 🔧 YAXSHILANGAN: Reset onboarding (testing uchun)
  Future<void> resetOnboarding() async {
    try {
      setLoading(true);

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.onboardingKey);

      _isOnboardingCompleted = false;
      _isFirstTime = true;

      debugPrint('✅ Onboarding status qayta o\'rnatildi');
    } catch (e) {
      debugPrint('❌ Onboarding qayta o\'rnatishda xatolik: $e');
      throw Exception('Onboarding qayta o\'rnatishda xatolik: $e');
    } finally {
      setLoading(false);
    }
  }

  // 🔧 YAXSHILANGAN: Check onboarding status (asenkron)
  Future<bool> checkOnboardingStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final status = prefs.getBool(AppConstants.onboardingKey) ?? false;

      // State ni yangilash
      _isOnboardingCompleted = status;
      _isFirstTime = !prefs.containsKey(AppConstants.onboardingKey);

      debugPrint('📱 Onboarding status tekshirildi:');
      debugPrint('   - Status: ${status ? "Yakunlangan" : "Yakunlanmagan"}');
      debugPrint('   - Birinchi marta: $_isFirstTime');

      notifyListeners();
      return status;
    } catch (e) {
      debugPrint('❌ Onboarding status tekshirishda xatolik: $e');
      // Xatolik bo'lsa, false qaytarish (onboardingga yo'naltirish)
      return false;
    }
  }

  // 🔧 YANGI: Force refresh settings
  Future<void> refreshSettings() async {
    try {
      setLoading(true);
      await _loadSettings();
      debugPrint('✅ Settings muvaffaqiyatli yangilandi');
    } catch (e) {
      debugPrint('❌ Settings yangilashda xatolik: $e');
    } finally {
      setLoading(false);
    }
  }

  // Set loading state
  void setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  // 🔧 YANGI: Clear all data (testing uchun)
  Future<void> clearAllData() async {
    try {
      setLoading(true);

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      _isOnboardingCompleted = false;
      _isFirstTime = true;

      debugPrint('✅ Barcha ma\'lumotlar tozalandi');
    } catch (e) {
      debugPrint('❌ Ma\'lumotlarni tozalashda xatolik: $e');
      throw Exception('Ma\'lumotlarni tozalashda xatolik: $e');
    } finally {
      setLoading(false);
    }
  }

  // 🔧 YANGI: Debug info
  Map<String, dynamic> get debugInfo => {
    'isOnboardingCompleted': _isOnboardingCompleted,
    'isFirstTime': _isFirstTime,
    'isLoading': _isLoading,
    'isInitialized': _isInitialized,
  };
}
