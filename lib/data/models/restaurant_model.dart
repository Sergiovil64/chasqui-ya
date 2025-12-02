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
      userId: json['user_id'] as String,
      description: json['description'] as String,
      address: json['address'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      imageUrl: json['image_url'] as String,
      isActive: json['is_active'] as bool,
    );
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
