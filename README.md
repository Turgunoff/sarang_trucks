# Sarang Trucks Mobile App

Professional yuk mashinalari ijarasi ilovasi

## Features

- **Splash Screen** - Ilova ochilish ekrani
- **Onboarding** - 3 ta kirish sahifasi
- **Home Screen** - Bosh sahifa
- **Catalog** - Mashinalar katalogi
- **Contact** - Bog'lanish ma'lumotlari
- **Settings** - Sozlamalar

## 🛠 Tech Stack

- **Frontend**: Flutter 3.8+
- **Backend**: Supabase (PostgreSQL + Storage + Real-time)
- **State Management**: Provider
- **Local Storage**: SharedPreferences
- **UI**: Material Design 3

## 📱 Screenshots

(Screenshots will be added here)

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.8.0 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code
- Android SDK / Xcode (for mobile development)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd sarang_trucks
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Supabase**
   
   `lib/constants/app_constants.dart` faylida Supabase ma'lumotlarini kiriting:
   ```dart
   static const String supabaseUrl = 'YOUR_SUPABASE_URL';
   static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 🗄 Database Schema

### Categories Table
```sql
CREATE TABLE categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  icon_url TEXT,
  order_index INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW()
);
```

### Vehicles Table
```sql
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
```

### Vehicle Images Table
```sql
CREATE TABLE vehicle_images (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  vehicle_id UUID REFERENCES vehicles(id) ON DELETE CASCADE,
  image_path TEXT NOT NULL,
  is_primary BOOLEAN DEFAULT false,
  order_index INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW()
);
```

### Company Info Table
```sql
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

## 📁 Project Structure

```
lib/
├── constants/
│   └── app_constants.dart      # App constants and configuration
├── models/
│   ├── category.dart           # Category data model
│   ├── vehicle.dart            # Vehicle data model
│   ├── vehicle_image.dart      # Vehicle image model
│   └── company_info.dart       # Company info model
├── providers/
│   ├── app_provider.dart       # App-wide state management
│   └── vehicle_provider.dart   # Vehicle-related state
├── services/
│   └── supabase_service.dart   # Supabase API service
├── screens/
│   ├── splash_screen.dart      # App splash screen
│   ├── onboarding_screen.dart  # Onboarding screens
│   ├── main_screen.dart        # Main screen with navigation
│   ├── home_screen.dart        # Home screen
│   ├── catalog_screen.dart     # Catalog screen
│   └── contact_screen.dart     # Contact screen
├── widgets/
│   ├── hero_section.dart       # Hero section widget
│   ├── category_list.dart      # Category list widget
│   ├── featured_vehicles.dart  # Featured vehicles widget
│   └── quick_contact.dart      # Quick contact widget
└── main.dart                   # App entry point
```

## 🔧 Configuration

### Supabase Setup

1. [Supabase](https://supabase.com) da yangi loyiha yarating
2. Database schema'ni yuklang
3. Storage bucket yarating: `vehicle-images`
4. RLS (Row Level Security) sozlang
5. API keys'ni oling va `app_constants.dart` ga kiriting

### Environment Variables

`.env` fayl yarating (optional):
```env
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

## 📱 Building

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## 🧪 Testing

```bash
flutter test
```

## 📦 Dependencies

Key packages used:
- `supabase_flutter` - Backend integration
- `provider` - State management
- `cached_network_image` - Image caching
- `shared_preferences` - Local storage
- `url_launcher` - External app launching
- `photo_view` - Image viewing
- `shimmer` - Loading animations

## 🤝 Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

Agar savollaringiz bo'lsa:
- Email: info@sarangtrucks.uz
- Telegram: @sarang_trucks
- Phone: +998901234567

## 🎯 Roadmap

- [ ] Vehicle details screen
- [ ] Advanced filtering
- [ ] Push notifications
- [ ] Offline support
- [ ] Multi-language support (English)
- [ ] Admin panel
- [ ] Payment integration
- [ ] Driver management
- [ ] Route optimization
- [ ] Analytics dashboard

---

**Sarang Trucks** - Professional yuk mashinalari ijarasi 🚛
