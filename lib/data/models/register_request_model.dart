// Modelo base para registro
abstract class RegisterRequest {
  Map<String, dynamic> toJson();
}

// Modelo para registro de cliente
class CustomerRegisterRequest implements RegisterRequest {
  final String email;
  final String password;
  final String phone;
  final String firstName;
  final String lastName;
  final String address;
  final double latitude;
  final double longitude;

  CustomerRegisterRequest({
    required this.email,
    required this.password,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'phone': phone,
      'first_name': firstName,
      'last_name': lastName,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

// Modelo para registro de restaurante
class RestaurantRegisterRequest implements RegisterRequest {
  final String email;
  final String password;
  final String phone;
  final String name;
  final String description;
  final String address;
  final double latitude;
  final double longitude;
  final String? imageUrl;

  RestaurantRegisterRequest({
    required this.email,
    required this.password,
    required this.phone,
    required this.name,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.imageUrl,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'phone': phone,
      'name': name,
      'description': description,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      if (imageUrl != null) 'image_url': imageUrl,
    };
  }
}

// Modelo para registro de repartidor
class DeliveryDriverRegisterRequest implements RegisterRequest {
  final String email;
  final String password;
  final String phone;
  final String firstName;
  final String lastName;
  final String vehicleType;
  final String licensePlate;
  final double currentLatitude;
  final double currentLongitude;

  DeliveryDriverRegisterRequest({
    required this.email,
    required this.password,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.vehicleType,
    required this.licensePlate,
    required this.currentLatitude,
    required this.currentLongitude,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'phone': phone,
      'first_name': firstName,
      'last_name': lastName,
      'vehicle_type': vehicleType,
      'license_plate': licensePlate,
      'current_latitude': currentLatitude,
      'current_longitude': currentLongitude,
    };
  }
}

// Enum para tipo de usuario
enum UserType {
  customer,
  restaurant,
  delivery;

  String get endpoint {
    switch (this) {
      case UserType.customer:
        return '/api/customers-complete/register';
      case UserType.restaurant:
        return '/api/restaurants-complete/register';
      case UserType.delivery:
        return '/api/delivery-drivers-complete/register';
    }
  }
}
