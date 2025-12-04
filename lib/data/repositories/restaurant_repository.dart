import 'package:chasqui_ya/data/http_service.dart';
import 'package:chasqui_ya/data/models/api_response_model.dart';
import 'package:chasqui_ya/data/models/restaurant_model.dart';

class RestaurantRepository {
  final HttpService _httpService = HttpService();

  /// GET /api/restaurants-complete
  /// Obtener todos los restaurantes
  Future<List<Restaurant>> getAll() async {
    try {
      print('🔍 [RestaurantRepository] Obteniendo restaurantes desde: /api/restaurants-complete');
      final response = await _httpService.get('/api/restaurants-complete');

      print('📡 [RestaurantRepository] Status Code: ${response.statusCode}');
      print('📦 [RestaurantRepository] Response Body: ${response.body}');

      if (_httpService.isSuccessful(response)) {
        final jsonData = _httpService.parseResponse(response);
        print('✅ [RestaurantRepository] Respuesta exitosa. Estructura: ${jsonData.keys}');
        
        // Log del primer item para ver estructura
        if (jsonData['data'] != null && (jsonData['data'] as List).isNotEmpty) {
          final firstItem = (jsonData['data'] as List).first;
          print('📋 [RestaurantRepository] Primer restaurante: $firstItem');
          print('📋 [RestaurantRepository] Tipo de user_id: ${firstItem['user_id'].runtimeType}');
        }

        final apiResponse = ApiResponse.fromJson(
          jsonData,
          (data) => (data as List)
              .map(
                (json) {
                  try {
                    return Restaurant.fromJson(json as Map<String, dynamic>);
                  } catch (e) {
                    print('❌ [RestaurantRepository] Error parseando restaurante: $e');
                    print('❌ [RestaurantRepository] JSON problemático: $json');
                    rethrow;
                  }
                },
              )
              .toList(),
        );

        final restaurants = apiResponse.data ?? [];
        print('🍽️ [RestaurantRepository] Restaurantes parseados exitosamente: ${restaurants.length}');
        return restaurants;
      } else {
        print('❌ [RestaurantRepository] Error en respuesta: ${response.statusCode}');
        final errorData = _httpService.handleHttpError(response);
        print('❌ [RestaurantRepository] Error: ${errorData['error']}');
        return [];
      }
    } catch (e, stackTrace) {
      print('💥 [RestaurantRepository] Excepción al obtener restaurantes: $e');
      print('💥 [RestaurantRepository] StackTrace: $stackTrace');
      return [];
    }
  }

  /// GET /api/restaurants/:id
  /// Obtener un restaurante por ID
  Future<Restaurant?> getById(int id) async {
    try {
      final response = await _httpService.get('/api/restaurants/$id');

      if (_httpService.isSuccessful(response)) {
        final jsonData = _httpService.parseResponse(response);
        final apiResponse = ApiResponse.fromJson(
          jsonData,
          (data) => Restaurant.fromJson(data as Map<String, dynamic>),
        );

        return apiResponse.data;
      }

      return null;
    } catch (e) {
      print('Error getting restaurant by id: $e');
      return null;
    }
  }

  /// GET /api/restaurants/user/:user_id
  /// Obtener restaurante por user_id
  Future<Restaurant?> getByUserId(String userId) async {
    try {
      final response = await _httpService.get('/api/restaurants/user/$userId');

      if (_httpService.isSuccessful(response)) {
        final jsonData = _httpService.parseResponse(response);
        final apiResponse = ApiResponse.fromJson(
          jsonData,
          (data) => Restaurant.fromJson(data as Map<String, dynamic>),
        );

        return apiResponse.data;
      }

      return null;
    } catch (e) {
      print('Error getting restaurant by user_id: $e');
      return null;
    }
  }

  /// POST /api/restaurants
  /// Crear un nuevo restaurante

  Future<Restaurant?> create(Map<String, dynamic> restaurantData) async {
    try {
      final response = await _httpService.post(
        '/api/restaurants',
        body: restaurantData,
      );

      if (_httpService.isSuccessful(response)) {
        final jsonData = _httpService.parseResponse(response);
        final apiResponse = ApiResponse.fromJson(
          jsonData,
          (data) => Restaurant.fromJson(data as Map<String, dynamic>),
        );

        return apiResponse.data;
      }

      return null;
    } catch (e) {
      print('Error creating restaurant: $e');
      return null;
    }
  }

  /// PUT /api/restaurants/:id
  /// Actualizar un restaurante

  Future<Restaurant?> update(
    int id,
    Map<String, dynamic> restaurantData,
  ) async {
    try {
      final response = await _httpService.put(
        '/api/restaurants/$id',
        body: restaurantData,
      );

      if (_httpService.isSuccessful(response)) {
        final jsonData = _httpService.parseResponse(response);
        final apiResponse = ApiResponse.fromJson(
          jsonData,
          (data) => Restaurant.fromJson(data as Map<String, dynamic>),
        );

        return apiResponse.data;
      }

      return null;
    } catch (e) {
      print('Error updating restaurant: $e');
      return null;
    }
  }

  /// DELETE /api/restaurants/:id
  /// Eliminar un restaurante
  Future<bool> delete(int id) async {
    try {
      final response = await _httpService.delete('/api/restaurants/$id');
      return _httpService.isSuccessful(response);
    } catch (e) {
      print('Error deleting restaurant: $e');
      return false;
    }
  }
}

