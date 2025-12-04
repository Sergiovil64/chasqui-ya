class MenuItem {
  const MenuItem({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.isAvailable,
  });

  final int id;
  final int restaurantId;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final bool isAvailable;

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as int,
      restaurantId: json['restaurant_id'] as int,
      name: json['name'] as String,
      // Campos opcionales según la BD (description, image_url, category pueden ser null)
      description: json['description'] as String? ?? '',
      // price puede venir como String o num desde la API
      price: _parseDouble(json['price']),
      imageUrl: json['image_url'] as String? ?? '',
      category: json['category'] as String? ?? 'Sin categoría',
      isAvailable: json['is_available'] as bool? ?? true,
    );
  }

  // Método auxiliar para parsear double desde String o num
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'description': description, 'price': price, 'image_url': imageUrl, 'category': category, 'is_available': isAvailable};
  }

  MenuItem copyWith({
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    bool? isAvailable,
  }) {
    return MenuItem(
      id: id,
      restaurantId: restaurantId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
