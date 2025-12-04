import 'package:chasqui_ya/data/models/register_request_model.dart';
import 'package:chasqui_ya/data/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_state.dart';

// Proveedor del repositorio
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

// Proveedor del notifier de autenticación
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(AuthState.initial());

  // Registro de cliente
  Future<bool> registerCustomer(CustomerRegisterRequest request) async {
    state = state.setLoading();

    final response = await _repository.registerCustomer(request);

    if (response.isSuccess && response.data != null) {
      final authData = response.data!;
      state = state.setAuthenticated(authData.user, authData.profile);
      return true;
    } else {
      state = state.setError(response.errorMessage);
      return false;
    }
  }

  // Registro de restaurante
  Future<bool> registerRestaurant(RestaurantRegisterRequest request) async {
    state = state.setLoading();

    final response = await _repository.registerRestaurant(request);

    if (response.isSuccess && response.data != null) {
      final authData = response.data!;
      state = state.setAuthenticated(authData.user, authData.profile);
      return true;
    } else {
      state = state.setError(response.errorMessage);
      return false;
    }
  }

  // Registro de repartidor
  Future<bool> registerDeliveryDriver(
    DeliveryDriverRegisterRequest request,
  ) async {
    state = state.setLoading();

    final response = await _repository.registerDeliveryDriver(request);

    if (response.isSuccess && response.data != null) {
      final authData = response.data!;
      state = state.setAuthenticated(authData.user, authData.profile);
      return true;
    } else {
      state = state.setError(response.errorMessage);
      return false;
    }
  }

  // Login
  Future<bool> login({required String email, required String password}) async {
    state = state.setLoading();

    final response = await _repository.login(email: email, password: password);

    if (response.isSuccess && response.data != null) {
      final authData = response.data!;
      state = state.setAuthenticated(authData.user, authData.profile);

      // PRUEBA: Si es restaurante, hacer petición al endpoint de menu
      if (authData.user.role == 'restaurante' && authData.profile != null) {
        final restaurantId = authData.profile!['id'];
        print('PRUEBA: Obteniendo menú del restaurante ID: $restaurantId');
        await _repository.testMenuEndpoint(restaurantId);
      }

      return true;
    } else {
      state = state.setError(response.errorMessage);
      return false;
    }
  }

  // Verificar token (para auto-login)
  Future<void> verifyToken() async {
    state = state.setLoading();

    final response = await _repository.verifyToken();

    if (response.isSuccess && response.data != null) {
      state = state.setAuthenticated(response.data!, null);
    } else {
      state = state.logout();
    }
  }

  // Logout
  Future<void> logout() async {
    await _repository.logout();
    state = state.logout();
  }

  // Limpiar error
  void clearError() {
    state = state.copyWith(error: null);
  }
}
