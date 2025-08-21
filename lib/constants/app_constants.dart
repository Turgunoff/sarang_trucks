// lib/constants/app_constants.dart
class AppConstants {
  // App Info
  static const String appName = 'Sarang Trucks';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Professional yuk mashinalari ijarasi';

  // Supabase Configuration
  static const String supabaseUrl = 'https://rlqvwuylaphnfdlxspkn.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJscXZ3dXlsYXBobmZkbHhzcGtuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTU3NDg3NTAsImV4cCI6MjA3MTMyNDc1MH0.1DIztj64kMERBkmxSYTIpeJahLmYim1A5O2NLY9I1H0';

  // Storage Buckets
  static const String vehicleImagesBucket = 'vehicle-images';

  // API Endpoints
  static const String categoriesTable = 'categories';
  static const String vehiclesTable = 'vehicles';

  // SharedPreferences Keys
  static const String onboardingKey = 'onboarding_completed';

  // Default Values
  static const int defaultPageSize = 20;
  static const double minCapacity = 1.0;
  static const double maxCapacity = 25.0;

  // Animation Durations
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);

  // Company Information (Static)
  static const String companyPhone = '+998933733118';
  static const String companyPhoneSecondary = '+998933733118';
  static const String companyTelegram = '@sarang_trucks';
  static const String companyWhatsApp = '+998933733118';
  static const String companyEmail = 'arisusarangllc@gmail.com';
  static const String companyAddress = 'Toshkent shahar, Mirobod tumani';
  static const String companyWorkingHours =
      'Dushanba-Juma: 9:00-18:00, Shanba: 9:00-15:00';
  static const String companyAbout =
      'Arisu Sarang MCHJ - yuk mashinalari ijarasi bo\'yicha ishonchli hamkor. 5 yildan ortiq tajriba.';

  // Error Messages
  static const String networkError = 'Internet aloqasi yo\'q';
  static const String generalError = 'Xatolik yuz berdi';
  static const String noDataFound = 'Ma\'lumot topilmadi';

  // Success Messages
  static const String dataLoaded = 'Ma\'lumotlar yuklandi';
}
