# Sarang Trucks App - O'rnatish va sozlash bo'yicha ko'rsatma

## 🚀 Tezkor ishga tushirish

### 1. Dependencies o'rnatish

```bash
flutter pub get
```

### 2. Supabase sozlash (muhim!)

`lib/constants/app_constants.dart` faylida quyidagi ma'lumotlarni o'zgartiring:

```dart
// Supabase Configuration
static const String supabaseUrl = 'YOUR_ACTUAL_SUPABASE_URL';
static const String supabaseAnonKey = 'YOUR_ACTUAL_SUPABASE_ANON_KEY';
```

### 3. App ishga tushirish

```bash
flutter run
```

## 🗄 Supabase sozlash (batafsil)

### 1. Supabase loyiha yaratish

1. [supabase.com](https://supabase.com) ga kiring
2. "New Project" tugmasini bosing
3. Loyiha nomini kiriting: `sarang-trucks`
4. Database parolini saqlang
5. Region tanlang (Yevropa yoki AQSh)
6. "Create new project" tugmasini bosing

### 2. Database Schema yuklash

Database > SQL Editor ga o'ting va quyidagi SQL kodlarni ishga tushiring:

```sql
-- Kategoriyalar
CREATE TABLE categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  icon_url TEXT,
  order_index INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Mashinalar
CREATE TABLE vehicles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  model TEXT NOT NULL,
  category_id UUID REFERENCES categories(id),
  year INTEGER,
  capacity_tons DECIMAL NOT NULL,
  engine_type TEXT CHECK (engine_type IN ('diesel', 'petrol')),
  transmission TEXT CHECK (transmission IN ('manual', 'automatic')),
  body_type TEXT,
  price_hourly DECIMAL,
  price_daily DECIMAL NOT NULL,
  price_weekly DECIMAL,
  has_driver BOOLEAN DEFAULT false,
  has_ac BOOLEAN DEFAULT false,
  has_gps BOOLEAN DEFAULT false,
  description TEXT,
  is_available BOOLEAN DEFAULT true,
  is_featured BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Mashina rasmlari
CREATE TABLE vehicle_images (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  vehicle_id UUID REFERENCES vehicles(id) ON DELETE CASCADE,
  image_path TEXT NOT NULL,
  is_primary BOOLEAN DEFAULT false,
  order_index INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Kompaniya ma'lumotlari
CREATE TABLE company_info (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  phone_primary TEXT NOT NULL,
  phone_secondary TEXT,
  telegram_username TEXT,
  whatsapp_number TEXT,
  email TEXT,
  address TEXT,
  working_hours TEXT,
  about_text TEXT,
  updated_at TIMESTAMP DEFAULT NOW()
);
```

### 3. Storage Bucket yaratish

1. Storage > Buckets ga o'ting
2. "New bucket" tugmasini bosing
3. Bucket nomi: `vehicle-images`
4. Public bucket sifatida belgilang
5. "Create bucket" tugmasini bosing

### 4. RLS (Row Level Security) sozlash

Har bir jadval uchun:

1. Authentication > Policies ga o'ting
2. "New Policy" tugmasini bosing
3. "Enable read access to everyone" tanlang
4. "Review" va "Save policy" tugmalarini bosing

### 5. API Keys olish

1. Settings > API ga oting
2. Project URL ni nusxalang
3. `anon` public key ni nusxalang
4. Bu ma'lumotlarni `app_constants.dart` ga kiriting

## 📱 Test ma'lumotlari

### Namuna kategoriyalar qo'shish

```sql
INSERT INTO categories (name, order_index) VALUES
('Kichik yuk mashinalari', 1),
('O''rta yuk mashinalari', 2),
('Katta yuk mashinalari', 3),
('Furgonlar', 4);
```

### Namuna mashinalar qo'shish

```sql
INSERT INTO vehicles (name, model, category_id, year, capacity_tons, engine_type, transmission, price_daily, is_featured) VALUES
('Isuzu NPR', 'NPR 75K', (SELECT id FROM categories WHERE name = 'O''rta yuk mashinalari'), 2020, 7.5, 'diesel', 'manual', 800000, true),
('Hyundai Porter', 'Porter II', (SELECT id FROM categories WHERE name = 'Kichik yuk mashinalari'), 2019, 1.5, 'petrol', 'manual', 400000, true);
```

### Kompaniya ma'lumotlari qo'shish

```sql
INSERT INTO company_info (phone_primary, telegram_username, whatsapp_number, email, address, working_hours, about_text) VALUES
('+998901234567', '@sarang_trucks', '+998901234567', 'info@sarangtrucks.uz', 'Toshkent shahri, Chilonzor tumani', 'Dushanba - Shanba: 08:00 - 18:00', 'Professional yuk mashinalari ijarasi');
```

## 🔧 Android NDK muammosi

Agar Android NDK xatosi kelsa, `android/app/build.gradle.kts` faylida quyidagini qo'shing:

```kotlin
android {
    ndkVersion = "27.0.12077973"
    // ... boshqa sozlamalar
}
```

## 🚨 Xatoliklar va yechimlar

### 1. Supabase ulanish xatosi

- URL va API key to'g'ri kiritilganini tekshiring
- Internet aloqasini tekshiring
- Supabase loyiha faol ekanligini tekshiring

### 2. Database xatosi

- SQL kodlar to'g'ri ishga tushirilganini tekshiring
- RLS policy'lar to'g'ri sozlanganini tekshiring

### 3. Build xatosi

- `flutter clean` buyrug'ini ishga tushiring
- `flutter pub get` ni qayta ishga tushiring
- Android Studio'da "Invalidate Caches and Restart" qiling

## 📞 Yordam

Agar muammolar bo'lsa:

- README.md faylini o'qing
- PROJECT_SUMMARY.md da loyiha holatini ko'ring
- Flutter va Supabase hujjatlarini tekshiring

## 🎯 Keyingi qadamlar

1. **Supabase sozlash** - yuqorida ko'rsatilgan
2. **Test ma'lumotlari** - namuna ma'lumotlarni qo'shing
3. **App test qilish** - barcha funksiyalarni tekshiring
4. **UI to'ldirish** - qolgan ekranlarni yarating
5. **Production** - app store'ga yuklash

---

**Sarang Trucks** - Professional yuk mashinalari ijarasi 🚛
_Setup Guide v1.0 - 2025-yil avgust_
