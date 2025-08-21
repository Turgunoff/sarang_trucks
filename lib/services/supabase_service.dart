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

  // Vehicles - simplified for now
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
      // For now, just get all vehicles and filter in memory
      // This can be optimized later with proper Supabase queries
      final response = await _client
          .from(AppConstants.vehiclesTable)
          .select()
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

        return vehicles.take(limit).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Mashinalarni yuklashda xatolik: $e');
    }
  }

  static Future<Vehicle?> getVehicleById(String vehicleId) async {
    try {
      final response = await _client
          .from(AppConstants.vehiclesTable)
          .select()
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

  // Search - simplified
  static Future<List<Vehicle>> searchVehicles(String query) async {
    try {
      final response = await _client
          .from(AppConstants.vehiclesTable)
          .select()
          .eq('is_available', true);

      if (response != null) {
        List<Vehicle> vehicles = (response as List)
            .map((json) => Vehicle.fromJson(json))
            .toList();

        // Filter by search query
        vehicles = vehicles
            .where(
              (v) =>
                  v.name.toLowerCase().contains(query.toLowerCase()) ||
                  v.model.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

        return vehicles.take(AppConstants.defaultPageSize).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Qidiruvda xatolik: $e');
    }
  }

  // Storage
  static String getImageUrl(String imagePath) {
    return _client.storage
        .from(AppConstants.vehicleImagesBucket)
        .getPublicUrl(imagePath);
  }

  // Real-time subscriptions (simplified for now)
  static RealtimeChannel subscribeToVehicles({
    required Function(List<Vehicle>) onData,
    required Function(String) onError,
  }) {
    return _client.channel('vehicles').subscribe((status, [error]) {
      if (error != null) {
        onError(error.toString());
      }
    });
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
