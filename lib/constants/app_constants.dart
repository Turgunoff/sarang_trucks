class AppConstants {
  // App Info
  static const String appName = 'Sarang Trucks';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Professional yuk mashinalari ijarasi';

  // Supabase Configuration
  static const String supabaseUrl =
      'https://rlqvwuylaphnfdlxspkn.supabase.co'; // SupabaseConfig.url ni ishlating
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJscXZ3dXlsYXBobmZkbHhzcGtuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTU3NDg3NTAsImV4cCI6MjA3MTMyNDc1MH0.1DIztj64kMERBkmxSYTIpeJahLmYim1A5O2NLY9I1H0'; // SupabaseConfig.anonKey ni ishlating

  // Storage Buckets
  static const String vehicleImagesBucket = 'vehicle-images';

  // API Endpoints
  static const String categoriesTable = 'categories';
  static const String vehiclesTable = 'vehicles';
  static const String vehicleImagesTable = 'vehicle_images';
  static const String companyInfoTable = 'company_info';

  // SharedPreferences Keys
  static const String favoritesKey = 'favorites';
  static const String languageKey = 'language';
  static const String themeKey = 'theme';
  static const String onboardingKey = 'onboarding_completed';

  // Languages
  static const String uzLanguage = 'uz';
  static const String ruLanguage = 'ru';

  // Themes
  static const String lightTheme = 'light';
  static const String darkTheme = 'dark';
  static const String systemTheme = 'system';

  // Default Values
  static const int defaultPageSize = 20;
  static const double minCapacity = 1.0;
  static const double maxCapacity = 25.0;

  // Animation Durations
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);

  // Contact Information (Fallback)
  static const String fallbackPhone = '+998901234567';
  static const String fallbackTelegram = '@sarang_trucks';
  static const String fallbackWhatsApp = '+998901234567';
  static const String fallbackEmail = 'info@sarangtrucks.uz';

  // Error Messages
  static const String networkError = 'Internet aloqasi yo\'q';
  static const String generalError = 'Xatolik yuz berdi';
  static const String noDataFound = 'Ma\'lumot topilmadi';

  // Success Messages
  static const String dataLoaded = 'Ma\'lumotlar yuklandi';
  static const String favoriteAdded = 'Sevimlilarga qo\'shildi';
  static const String favoriteRemoved = 'Sevimlilardan olib tashlandi';
}
