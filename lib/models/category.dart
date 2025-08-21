class Category {
  final String id;
  final String name;
  final String? iconUrl;
  final int orderIndex;
  final DateTime createdAt;

  Category({
    required this.id,
    required this.name,
    this.iconUrl,
    required this.orderIndex,
    required this.createdAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      iconUrl: json['icon_url'] as String?,
      orderIndex: json['order_index'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon_url': iconUrl,
      'order_index': orderIndex,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Category(id: $id, name: $name, orderIndex: $orderIndex)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Category && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
