import 'package:flutter/foundation.dart';

import '../http_service.dart';
import '../models/api_response_model.dart';
import '../models/register_request_model.dart';
import '../models/user_model.dart';

class AuthRepository {
  final HttpService _httpService = HttpService();

  // Registro genérico para cualquier tipo de usuario
  Future<ApiResponse<AuthResponse>> register({
    required UserType userType,
    required RegisterRequest request,
  }) async {
    try {
      final response = await _httpService.postPublic(
        userType.endpoint,
        body: request.toJson(),
      );

      final jsonResponse = _httpService.parseResponse(response);

      if (_httpService.isSuccessful(response)) {
        // Verificar que la respuesta tenga la estructura esperada
        if (jsonResponse['data'] == null) {
          return ApiResponse(
            success: false,
            error: 'Respuesta inválida del servidor',
          );
        }

        final data = jsonResponse['data'] as Map<String, dynamic>;

        Map<String, dynamic>? profile;
        if (data.containsKey('restaurant')) {
          profile = data['restaurant'];
        } else if (data.containsKey('customer')) {
          profile = data['customer'];
        } else if (data.containsKey('delivery_driver')) {
          profile = data['delivery_driver'];
        }

        final authResponse = AuthResponse(
          token: null, // No hay token en registro
          user: User.fromJson(data['user']),
          profile: profile,
        );

        return ApiResponse(
          success: true,
          message: jsonResponse['message'],
          data: authResponse,
        );
      } else {
        final errorData = _httpService.handleHttpError(response);
        return ApiResponse(success: false, error: errorData['error']);
      }
    } catch (e) {
      return ApiResponse(success: false, error: 'Error de conexión: $e');
    }
  }

  // Registro de cliente
  Future<ApiResponse<AuthResponse>> registerCustomer(
    CustomerRegisterRequest request,
  ) {
    return register(userType: UserType.customer, request: request);
  }

  // Registro de restaurante
  Future<ApiResponse<AuthResponse>> registerRestaurant(
    RestaurantRegisterRequest request,
  ) {
    return register(userType: UserType.restaurant, request: request);
  }

  // Registro de repartidor
  Future<ApiResponse<AuthResponse>> registerDeliveryDriver(
    DeliveryDriverRegisterRequest request,
  ) {
    return register(userType: UserType.delivery, request: request);
  }

  Future<ApiResponse<AuthResponse>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _httpService.postPublic(
        '/api/auth/login',
        body: {'email': email, 'password': password},
      );

      final jsonResponse = _httpService.parseResponse(response);

      if (_httpService.isSuccessful(response)) {
        // Guardar token (solo en login)
        final authResponse = AuthResponse.fromJson(jsonResponse['data']);
        if (authResponse.token != null) {
          await _httpService.saveToken(authResponse.token!);
        }

        return ApiResponse.fromJson(jsonResponse, (data) => authResponse);
      } else {
        final errorData = _httpService.handleHttpError(response);
        return ApiResponse(success: false, error: errorData['error']);
      }
    } catch (e) {
      return ApiResponse(success: false, error: 'Error de conexión: $e');
    }
  }

  // Verificar token
  Future<ApiResponse<User>> verifyToken() async {
    try {
      final response = await _httpService.post('/api/auth/verify');

      final jsonResponse = _httpService.parseResponse(response);

      if (_httpService.isSuccessful(response)) {
        return ApiResponse.fromJson(
          jsonResponse,
          (data) => User.fromJson(data['user']),
        );
      } else {
        final errorData = _httpService.handleHttpError(response);
        return ApiResponse(success: false, error: errorData['error']);
      }
    } catch (e) {
      return ApiResponse(success: false, error: 'Error de conexión: $e');
    }
  }

  // Logout
  Future<void> logout() async {
    await _httpService.deleteToken();
  }

  // PRUEBA: Obtener items del menú (solo para verificar token)
  Future<void> testMenuEndpoint(int restaurantId) async {
    try {
      print('Haciendo petición a: /api/menu-items/restaurant/$restaurantId');

      final response = await _httpService.get(
        '/api/menu-items/restaurant/$restaurantId',
      );

      final jsonResponse = _httpService.parseResponse(response);

      if (_httpService.isSuccessful(response)) {
        print('exito: Token válido. Respuesta:');
        print('- Success: ${jsonResponse['success']}');
        print('- Count: ${jsonResponse['count']}');
        print('- Data: ${jsonResponse['data']}');
      } else {
        print('ERROR: ${jsonResponse['error']}');
      }
    } catch (e) {
      print('EXCEPCIÓN: $e');
    }
  }
}
