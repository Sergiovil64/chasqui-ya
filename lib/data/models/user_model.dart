class User {
  final int id;
  final String email;
  final String? phone;
  final String role;
  final String status;
  final DateTime? createdAt;

  User({
    required this.id,
    required this.email,
    this.phone,
    required this.role,
    required this.status,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      role: json['role'] as String,
      status: json['status'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      if (phone != null) 'phone': phone,
      'role': role,
      'status': status,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }
}

class AuthResponse {
  final String? token;
  final User user;
  final Map<String, dynamic>? profile;

  AuthResponse({
    this.token,
    required this.user,
    this.profile,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] as String?,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      profile: json['profile'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (token != null) 'token': token,
      'user': user.toJson(),
      if (profile != null) 'profile': profile,
    };
  }
}
