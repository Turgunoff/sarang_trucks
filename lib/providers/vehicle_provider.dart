import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import '../models/category.dart';
import '../services/supabase_service.dart';

class VehicleProvider extends ChangeNotifier {
  List<Vehicle> _vehicles = [];
  List<Vehicle> _featuredVehicles = [];
  List<Category> _categories = [];
  List<Vehicle> _searchResults = [];
  List<String> _favorites = [];
  
  bool _isLoading = false;
  bool _isSearching = false;
  String? _error;
  
  // Filter states
  String? _selectedCategoryId;
  double? _minCapacity;
  double? _maxPrice;
  String? _searchQuery;
  bool _hasDriver = false;
  bool _hasAC = false;
  bool _hasGPS = false;

  // Getters
  List<Vehicle> get vehicles => _vehicles;
  List<Vehicle> get featuredVehicles => _featuredVehicles;
  List<Category> get categories => _categories;
  List<Vehicle> get searchResults => _searchResults;
  List<String> get favorites => _favorites;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String? get error => _error;
  
  // Filter getters
  String? get selectedCategoryId => _selectedCategoryId;
  double? get minCapacity => _minCapacity;
  double? get maxPrice => _maxPrice;
  String? get searchQuery => _searchQuery;
  bool get hasDriver => _hasDriver;
  bool get hasAC => _hasAC;
  bool get hasGPS => _hasGPS;

  VehicleProvider() {
    _loadFavorites();
    _loadInitialData();
  }

  // Load initial data
  Future<void> _loadInitialData() async {
    await Future.wait([
      loadCategories(),
      loadFeaturedVehicles(),
    ]);
  }

  // Load categories
  Future<void> loadCategories() async {
    try {
      setLoading(true);
      _categories = await SupabaseService.getCategories();
      _error = null;
    } catch (e) {
      _error = SupabaseService.getErrorMessage(e);
    } finally {
      setLoading(false);
    }
  }

  // Load vehicles with filters
  Future<void> loadVehicles({
    bool refresh = false,
    int offset = 0,
  }) async {
    try {
      if (refresh) {
        offset = 0;
        _vehicles.clear();
      }
      
      setLoading(true);
      _error = null;
      
      final newVehicles = await SupabaseService.getVehicles(
        categoryId: _selectedCategoryId,
        minCapacity: _minCapacity,
        maxPrice: _maxPrice,
        limit: 20,
        offset: offset,
      );
      
      if (refresh || offset == 0) {
        _vehicles = newVehicles;
      } else {
        _vehicles.addAll(newVehicles);
      }
    } catch (e) {
      _error = SupabaseService.getErrorMessage(e);
    } finally {
      setLoading(false);
    }
  }

  // Load featured vehicles
  Future<void> loadFeaturedVehicles() async {
    try {
      _featuredVehicles = await SupabaseService.getFeaturedVehicles();
      _error = null;
    } catch (e) {
      _error = SupabaseService.getErrorMessage(e);
    }
  }

  // Search vehicles
  Future<void> searchVehicles(String query) async {
    if (query.isEmpty) {
      _searchResults.clear();
      _isSearching = false;
      notifyListeners();
      return;
    }

    try {
      _isSearching = true;
      _searchQuery = query;
      _error = null;
      
      _searchResults = await SupabaseService.searchVehicles(query);
    } catch (e) {
      _error = SupabaseService.getErrorMessage(e);
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  // Apply filters
  Future<void> applyFilters({
    String? categoryId,
    double? minCapacity,
    double? maxPrice,
    bool? hasDriver,
    bool? hasAC,
    bool? hasGPS,
  }) async {
    _selectedCategoryId = categoryId;
    _minCapacity = minCapacity;
    _maxPrice = maxPrice;
    _hasDriver = hasDriver ?? _hasDriver;
    _hasAC = hasAC ?? _hasAC;
    _hasGPS = hasGPS ?? _hasGPS;
    
    await loadVehicles(refresh: true);
  }

  // Clear filters
  Future<void> clearFilters() async {
    _selectedCategoryId = null;
    _minCapacity = null;
    _maxPrice = null;
    _hasDriver = false;
    _hasAC = false;
    _hasGPS = false;
    
    await loadVehicles(refresh: true);
  }

  // Load favorites from SharedPreferences
  Future<void> _loadFavorites() async {
    // This would be implemented with SharedPreferences
    // For now, using empty list
    _favorites = [];
  }

  // Toggle favorite
  Future<void> toggleFavorite(String vehicleId) async {
    if (_favorites.contains(vehicleId)) {
      _favorites.remove(vehicleId);
    } else {
      _favorites.add(vehicleId);
    }
    
    // Save to SharedPreferences
    // await _saveFavorites();
    
    notifyListeners();
  }

  // Check if vehicle is favorite
  bool isFavorite(String vehicleId) {
    return _favorites.contains(vehicleId);
  }

  // Get favorite vehicles
  List<Vehicle> getFavoriteVehicles() {
    return _vehicles.where((vehicle) => _favorites.contains(vehicle.id)).toList();
  }

  // Set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Refresh all data
  Future<void> refresh() async {
    await Future.wait([
      loadCategories(),
      loadFeaturedVehicles(),
      loadVehicles(refresh: true),
    ]);
  }
}
