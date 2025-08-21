class VehicleImage {
  final String id;
  final String vehicleId;
  final String imagePath;
  final bool isPrimary;
  final int orderIndex;
  final DateTime createdAt;

  VehicleImage({
    required this.id,
    required this.vehicleId,
    required this.imagePath,
    required this.isPrimary,
    required this.orderIndex,
    required this.createdAt,
  });

  factory VehicleImage.fromJson(Map<String, dynamic> json) {
    return VehicleImage(
      id: json['id'] as String,
      vehicleId: json['vehicle_id'] as String,
      imagePath: json['image_path'] as String,
      isPrimary: json['is_primary'] as bool? ?? false,
      orderIndex: json['order_index'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicle_id': vehicleId,
      'image_path': imagePath,
      'is_primary': isPrimary,
      'order_index': orderIndex,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'VehicleImage(id: $id, vehicleId: $vehicleId, isPrimary: $isPrimary)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VehicleImage && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
