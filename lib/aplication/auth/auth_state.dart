import 'package:chasqui_ya/data/models/user_model.dart';

// Estado de autenticación
class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final User? user;
  final Map<String, dynamic>? profile;
  final String? error;

  AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.user,
    this.profile,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    User? user,
    Map<String, dynamic>? profile,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      profile: profile ?? this.profile,
      error: error,
    );
  }

  // Estado inicial
  factory AuthState.initial() {
    return AuthState();
  }

  // Estado de carga
  AuthState setLoading() {
    return copyWith(isLoading: true, error: null);
  }

  // Estado autenticado
  AuthState setAuthenticated(User user, Map<String, dynamic>? profile) {
    return copyWith(
      isLoading: false,
      isAuthenticated: true,
      user: user,
      profile: profile,
      error: null,
    );
  }

  // Estado de error
  AuthState setError(String error) {
    return copyWith(isLoading: false, error: error);
  }

  // Estado de logout
  AuthState logout() {
    return AuthState.initial();
  }
}
