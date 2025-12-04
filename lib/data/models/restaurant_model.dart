class Restaurant {
  const Restaurant({
    required this.id,
    required this.name,
    required this.userId,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required this.isActive,
  });

  final int id;
  final String name;
  final String description;
  final String address;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final bool isActive;
  final String userId;

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] as int,
      name: json['name'] as String,
      // user_id viene como int desde la API, pero el modelo lo espera como String
      // TODO: Evaluar cambiar userId a int para coincidir con la BD
      userId: (json['user_id'] as num).toString(),
      // Campos opcionales según la BD (description, image_url pueden ser null)
      description: json['description'] as String? ?? '',
      address: json['address'] as String? ?? '',
      // latitude y longitude pueden venir como String o num desde la API
      latitude: _parseDouble(json['latitude']),
      longitude: _parseDouble(json['longitude']),
      imageUrl: json['image_url'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? true,
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
    return {'name': name, 'description': description, 'address': address, 'latitude': latitude, 'longitude': longitude, 'image_url': imageUrl, 'is_active': isActive, 'user_id': userId};
  }

  Restaurant copyWith({
    String? name,
    String? description,
    String? address,
    double? latitude,
    double? longitude,
    String? imageUrl,
    bool? isActive,
    String? userId,
  }) {
    return Restaurant(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
      userId: userId ?? this.userId,
    );
  }
}
