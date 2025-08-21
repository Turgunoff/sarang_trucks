// lib/services/supabase_service.dart - TUZATILGAN VERSIYA
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

      if (response != null && response is List) {
        return response.map((json) => Category.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Categories xatoligi: $e');
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
      // 🔧 TUZATILDI: To'g'ri join sintaksisi
      var query = _client
          .from(AppConstants.vehiclesTable)
          .select('''
            id,
            name,
            model,
            category_id,
            year,
            capacity_tons,
            engine_type,
            transmission,
            body_type,
            price_hourly,
            price_daily,
            price_weekly,
            has_driver,
            has_ac,
            has_gps,
            description,
            is_available,
            is_featured,
            created_at,
            images,
            categories!vehicles_category_id_fkey(
              id,
              name,
              icon_url,
              order_index,
              created_at
            )
          ''')
          .eq('is_available', true);

      // Apply database-level filters
      if (categoryId != null) {
        query = query.eq('category_id', categoryId);
      }
      if (minCapacity != null) {
        query = query.gte('capacity_tons', minCapacity);
      }
      if (maxPrice != null) {
        query = query.lte('price_daily', maxPrice);
      }
      if (isFeatured != null) {
        query = query.eq('is_featured', isFeatured);
      }
      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query.or(
          'name.ilike.%$searchQuery%,model.ilike.%$searchQuery%',
        );
      }

      final response = await query
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      if (response != null && response is List) {
        return response.map((json) => Vehicle.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Vehicles xatoligi: $e');
      // Fallback: Agar join ishlamasa, alohida query
      return await _getVehiclesWithSeparateQueries(
        categoryId: categoryId,
        minCapacity: minCapacity,
        maxPrice: maxPrice,
        searchQuery: searchQuery,
        isFeatured: isFeatured,
        limit: limit,
        offset: offset,
      );
    }
  }

  // 🔧 FALLBACK: Alohida query'lar bilan
  static Future<List<Vehicle>> _getVehiclesWithSeparateQueries({
    String? categoryId,
    double? minCapacity,
    double? maxPrice,
    String? searchQuery,
    bool? isFeatured,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      // 1. Mashinalarni olish
      var vehiclesQuery = _client
          .from(AppConstants.vehiclesTable)
          .select()
          .eq('is_available', true);

      if (categoryId != null) {
        vehiclesQuery = vehiclesQuery.eq('category_id', categoryId);
      }
      if (minCapacity != null) {
        vehiclesQuery = vehiclesQuery.gte('capacity_tons', minCapacity);
      }
      if (maxPrice != null) {
        vehiclesQuery = vehiclesQuery.lte('price_daily', maxPrice);
      }
      if (isFeatured != null) {
        vehiclesQuery = vehiclesQuery.eq('is_featured', isFeatured);
      }
      if (searchQuery != null && searchQuery.isNotEmpty) {
        vehiclesQuery = vehiclesQuery.or(
          'name.ilike.%$searchQuery%,model.ilike.%$searchQuery%',
        );
      }

      final vehiclesResponse = await vehiclesQuery
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      if (vehiclesResponse == null || vehiclesResponse is! List) {
        return [];
      }

      // 2. Kategoriyalarni olish
      final categoriesResponse = await _client
          .from(AppConstants.categoriesTable)
          .select();

      Map<String, dynamic> categoriesMap = {};
      if (categoriesResponse != null && categoriesResponse is List) {
        for (var category in categoriesResponse) {
          categoriesMap[category['id']] = category;
        }
      }

      // 3. Mashinalarni kategoriyalar bilan birlashtirish
      List<Vehicle> vehicles = [];
      for (var vehicleJson in vehiclesResponse) {
        final categoryData = categoriesMap[vehicleJson['category_id']];
        if (categoryData != null) {
          // Kategoriya ma'lumotlarini qo'shish
          vehicleJson['categories'] = categoryData;
          vehicles.add(Vehicle.fromJson(vehicleJson));
        }
      }

      return vehicles;
    } catch (e) {
      print('Fallback query xatoligi: $e');
      throw Exception('Mashinalarni yuklashda xatolik: $e');
    }
  }

  static Future<Vehicle?> getVehicleById(String vehicleId) async {
    try {
      final response = await _client
          .from(AppConstants.vehiclesTable)
          .select('''
            *,
            categories!vehicles_category_id_fkey(*)
          ''')
          .eq('id', vehicleId)
          .single();

      if (response != null) {
        return Vehicle.fromJson(response);
      }
      return null;
    } catch (e) {
      print('Vehicle by ID xatoligi: $e');
      throw Exception('Mashina ma\'lumotlarini yuklashda xatolik: $e');
    }
  }

  static Future<List<Vehicle>> getFeaturedVehicles({int limit = 5}) async {
    return getVehicles(isFeatured: true, limit: limit);
  }

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
