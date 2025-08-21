// lib/services/supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category.dart';
import '../models/vehicle.dart';
import '../constants/app_constants.dart';

class SupabaseService {
  static final SupabaseClient _client = Supabase.instance.client;

  // Categories
  static Future<List<Category>> getCategories() async {
    try {
      final response = await _client
          .from(AppConstants.categoriesTable)
          .select()
          .order('order_index');

      if (response != null) {
        return (response as List)
            .map((json) => Category.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Kategoriyalarni yuklashda xatolik: $e');
    }
  }

  // Vehicles - categories bilan join qilingan
  static Future<List<Vehicle>> getVehicles({
    String? categoryId,
    double? minCapacity,
    double? maxPrice,
    String? searchQuery,
    bool? isFeatured,
    int limit = AppConstants.defaultPageSize,
    int offset = 0,
  }) async {
    try {
      // Categories bilan join query - BU MUHIM!
      final response = await _client
          .from(AppConstants.vehiclesTable)
          .select('''
            *,
            categories!inner(*)
          ''')
          .eq('is_available', true)
          .order('created_at', ascending: false);

      if (response != null) {
        List<Vehicle> vehicles = (response as List)
            .map((json) => Vehicle.fromJson(json))
            .toList();

        // Apply filters in memory
        if (categoryId != null) {
          vehicles = vehicles
              .where((v) => v.category.id == categoryId)
              .toList();
        }
        if (minCapacity != null) {
          vehicles = vehicles
              .where((v) => v.capacityTons >= minCapacity)
              .toList();
        }
        if (maxPrice != null) {
          vehicles = vehicles.where((v) => v.priceDaily <= maxPrice).toList();
        }
        if (isFeatured != null) {
          vehicles = vehicles.where((v) => v.isFeatured == isFeatured).toList();
        }
        if (searchQuery != null && searchQuery.isNotEmpty) {
          vehicles = vehicles
              .where(
                (v) =>
                    v.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                    v.model.toLowerCase().contains(searchQuery.toLowerCase()),
              )
              .toList();
        }

        return vehicles.skip(offset).take(limit).toList();
      }
      return [];
    } catch (e) {
      print('Supabase xatoligi: $e'); // Debug uchun
      throw Exception('Mashinalarni yuklashda xatolik: $e');
    }
  }

  static Future<Vehicle?> getVehicleById(String vehicleId) async {
    try {
      final response = await _client
          .from(AppConstants.vehiclesTable)
          .select('''
            *,
            categories!inner(*)
          ''')
          .eq('id', vehicleId)
          .single();

      if (response != null) {
        return Vehicle.fromJson(response);
      }
      return null;
    } catch (e) {
      throw Exception('Mashina ma\'lumotlarini yuklashda xatolik: $e');
    }
  }

  static Future<List<Vehicle>> getFeaturedVehicles({int limit = 5}) async {
    return getVehicles(isFeatured: true, limit: limit);
  }

  // Search - categories bilan
  static Future<List<Vehicle>> searchVehicles(String query) async {
    return getVehicles(searchQuery: query);
  }

  // Storage
  static String getImageUrl(String imagePath) {
    if (imagePath.startsWith('http')) {
      return imagePath; // Already a full URL
    }
    return _client.storage
        .from(AppConstants.vehicleImagesBucket)
        .getPublicUrl(imagePath);
  }

  // Error handling
  static String getErrorMessage(dynamic error) {
    if (error is PostgrestException) {
      return error.message;
    } else if (error is AuthException) {
      return 'Autentifikatsiya xatosi: ${error.message}';
    } else if (error is StorageException) {
      return 'Fayl yuklashda xatolik: ${error.message}';
    } else {
      return error.toString();
    }
  }
}
