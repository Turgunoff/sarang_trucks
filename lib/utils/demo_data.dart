import '../models/category.dart';
import '../models/vehicle.dart';
import '../models/company_info.dart';

class DemoData {
  // Demo categories
  static List<Category> getDemoCategories() {
    return [
      Category(
        id: '1',
        name: 'Kichik yuk mashinalari',
        iconUrl: null,
        orderIndex: 1,
        createdAt: DateTime.now(),
      ),
      Category(
        id: '2',
        name: 'O\'rta yuk mashinalari',
        iconUrl: null,
        orderIndex: 2,
        createdAt: DateTime.now(),
      ),
      Category(
        id: '3',
        name: 'Katta yuk mashinalari',
        iconUrl: null,
        orderIndex: 3,
        createdAt: DateTime.now(),
      ),
      Category(
        id: '4',
        name: 'Furgonlar',
        iconUrl: null,
        orderIndex: 4,
        createdAt: DateTime.now(),
      ),
    ];
  }

  // Demo vehicles
  static List<Vehicle> getDemoVehicles() {
    final categories = getDemoCategories();
    
    return [
      Vehicle(
        id: '1',
        name: 'Isuzu NPR',
        model: 'NPR 75K',
        category: categories[1], // O'rta yuk mashinalari
        year: 2020,
        capacityTons: 7.5,
        engineType: EngineType.diesel,
        transmission: TransmissionType.manual,
        bodyType: 'Bortli',
        priceHourly: 50000,
        priceDaily: 800000,
        priceWeekly: 5000000,
        hasDriver: true,
        hasAC: true,
        hasGPS: true,
        description: 'Professional yuk tashish uchun ishonchli mashina',
        isAvailable: true,
        isFeatured: true,
        createdAt: DateTime.now(),
        images: [],
      ),
      Vehicle(
        id: '2',
        name: 'Hyundai Porter',
        model: 'Porter II',
        category: categories[0], // Kichik yuk mashinalari
        year: 2019,
        capacityTons: 1.5,
        engineType: EngineType.petrol,
        transmission: TransmissionType.manual,
        bodyType: 'Furgon',
        priceHourly: 25000,
        priceDaily: 400000,
        priceWeekly: 2500000,
        hasDriver: false,
        hasAC: true,
        hasGPS: false,
        description: 'Shahar ichida yuk tashish uchun qulay',
        isAvailable: true,
        isFeatured: true,
        createdAt: DateTime.now(),
        images: [],
      ),
      Vehicle(
        id: '3',
        name: 'Kamaz 5320',
        model: '5320',
        category: categories[2], // Katta yuk mashinalari
        year: 2018,
        capacityTons: 20.0,
        engineType: EngineType.diesel,
        transmission: TransmissionType.manual,
        bodyType: 'Tentli',
        priceHourly: 80000,
        priceDaily: 1200000,
        priceWeekly: 8000000,
        hasDriver: true,
        hasAC: false,
        hasGPS: true,
        description: 'Og\'ir yuklar uchun kuchli mashina',
        isAvailable: true,
        isFeatured: false,
        createdAt: DateTime.now(),
        images: [],
      ),
    ];
  }

  // Demo company info
  static CompanyInfo getDemoCompanyInfo() {
    return CompanyInfo(
      id: '1',
      phonePrimary: '+998901234567',
      phoneSecondary: '+998901234568',
      telegramUsername: '@sarang_trucks',
      whatsappNumber: '+998901234567',
      email: 'info@sarangtrucks.uz',
      address: 'Toshkent shahri, Chilonzor tumani, 1-mavze',
      workingHours: 'Dushanba - Shanba: 08:00 - 18:00',
      aboutText: 'Sarang Trucks - professional yuk mashinalari ijarasi bo\'yicha yetakchi kompaniya. Biz mijozlarimizga sifatli xizmat va qulay narxlarni taqdim etamiz.',
      updatedAt: DateTime.now(),
    );
  }
}
