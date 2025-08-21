// Supabase Configuration
// Bu faylni o'z Supabase ma'lumotlaringiz bilan to'ldiring

class SupabaseConfig {
  // Supabase loyiha URL'i
  static const String url = 'https://rlqvwuylaphnfdlxspkn.supabase.co';

  // Supabase anon key
  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJscXZ3dXlsYXBobmZkbHhzcGtuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTU3NDg3NTAsImV4cCI6MjA3MTMyNDc1MH0.1DIztj64kMERBkmxSYTIpeJahLmYim1A5O2NLY9I1H0';

  // Storage bucket nomi
  static const String storageBucket = 'vehicle-images';

  // Database jadvallar
  static const String categoriesTable = 'categories';
  static const String vehiclesTable = 'vehicles';
  static const String vehicleImagesTable = 'vehicle_images';
  static const String companyInfoTable = 'company_info';
}

// Supabase sozlash bo'yicha ko'rsatmalar:
//
// 1. https://supabase.com ga kiring
// 2. Yangi loyiha yarating
// 3. Database > SQL Editor ga o'ting
// 4. README.md dagi SQL kodlarni ishga tushiring
// 5. Storage > Buckets ga o'ting
// 6. "vehicle-images" nomli yangi bucket yarating
// 7. Settings > API ga o'ting
// 8. Project URL va anon public key ni nusxalang
// 9. Yuqoridagi o'zgaruvchilarga qo'yib bering
//
// RLS (Row Level Security) sozlash:
// - Har bir jadval uchun RLS ni yoqing
// - Kerakli policy'lar yarating
// - Storage bucket uchun ham RLS yoqing
