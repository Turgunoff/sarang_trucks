// lib/models/vehicle.dart
import 'category.dart';

enum EngineType { diesel, petrol }

enum TransmissionType { manual, automatic }

class Vehicle {
  final String id;
  final String name;
  final String model;
  final Category category;
  final int? year;
  final double capacityTons;
  final EngineType engineType;
  final TransmissionType transmission;
  final String? bodyType;
  final double? priceHourly;
  final double priceDaily;
  final double? priceWeekly;
  final bool hasDriver;
  final bool hasAC;
  final bool hasGPS;
  final String? description;
  final bool isAvailable;
  final bool isFeatured;
  final DateTime createdAt;
  final List<String> images; // Soddalashtirilgan rasm ro'yxati

  Vehicle({
    required this.id,
    required this.name,
    required this.model,
    required this.category,
    this.year,
    required this.capacityTons,
    required this.engineType,
    required this.transmission,
    this.bodyType,
    this.priceHourly,
    required this.priceDaily,
    this.priceWeekly,
    required this.hasDriver,
    required this.hasAC,
    required this.hasGPS,
    this.description,
    required this.isAvailable,
    required this.isFeatured,
    required this.createdAt,
    required this.images,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    // Rasmlarni 5 ta ustundan yig'ish
    List<String> imageList = [];
    for (int i = 1; i <= 5; i++) {
      final imageUrl = json['image_$i'] as String?;
      if (imageUrl != null && imageUrl.isNotEmpty) {
        imageList.add(imageUrl);
      }
    }

    return Vehicle(
      id: json['id'] as String,
      name: json['name'] as String,
      model: json['model'] as String,
      category: Category.fromJson(json['categories'] as Map<String, dynamic>),
      year: json['year'] as int?,
      capacityTons: (json['capacity_tons'] as num).toDouble(),
      engineType: EngineType.values.firstWhere(
        (e) => e.name == json['engine_type'],
        orElse: () => EngineType.diesel,
      ),
      transmission: TransmissionType.values.firstWhere(
        (t) => t.name == json['transmission'],
        orElse: () => TransmissionType.manual,
      ),
      bodyType: json['body_type'] as String?,
      priceHourly: json['price_hourly'] != null
          ? (json['price_hourly'] as num).toDouble()
          : null,
      priceDaily: (json['price_daily'] as num).toDouble(),
      priceWeekly: json['price_weekly'] != null
          ? (json['price_weekly'] as num).toDouble()
          : null,
      hasDriver: json['has_driver'] as bool? ?? false,
      hasAC: json['has_ac'] as bool? ?? false,
      hasGPS: json['has_gps'] as bool? ?? false,
      description: json['description'] as String?,
      isAvailable: json['is_available'] as bool? ?? true,
      isFeatured: json['is_featured'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      images: imageList,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      'id': id,
      'name': name,
      'model': model,
      'category_id': category.id,
      'year': year,
      'capacity_tons': capacityTons,
      'engine_type': engineType.name,
      'transmission': transmission.name,
      'body_type': bodyType,
      'price_hourly': priceHourly,
      'price_daily': priceDaily,
      'price_weekly': priceWeekly,
      'has_driver': hasDriver,
      'has_ac': hasAC,
      'has_gps': hasGPS,
      'description': description,
      'is_available': isAvailable,
      'is_featured': isFeatured,
      'created_at': createdAt.toIso8601String(),
    };

    // Rasmlarni 5 ta ustunга joylash
    for (int i = 1; i <= 5; i++) {
      data['image_$i'] = i <= images.length ? images[i - 1] : null;
    }

    return data;
  }

  String? get primaryImageUrl {
    return images.isNotEmpty ? images.first : null;
  }

  String get engineTypeText {
    switch (engineType) {
      case EngineType.diesel:
        return 'Dizel';
      case EngineType.petrol:
        return 'Benzin';
    }
  }

  String get transmissionText {
    switch (transmission) {
      case TransmissionType.manual:
        return 'Mexanik';
      case TransmissionType.automatic:
        return 'Avtomatik';
    }
  }

  @override
  String toString() {
    return 'Vehicle(id: $id, name: $name, model: $model, category: ${category.name})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Vehicle && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
