import 'package:chasqui_ya/data/http_service.dart';
import 'package:chasqui_ya/data/models/api_response_model.dart';
import 'package:chasqui_ya/data/models/restaurant_model.dart';

class RestaurantRepository {
  final HttpService _httpService = HttpService();

  /// GET /api/restaurants
  /// Obtener todos los restaurantes
  Future<List<Restaurant>> getAll() async {
    try {
      final response = await _httpService.get('/api/restaurants');

      if (_httpService.isSuccessful(response)) {
        final jsonData = _httpService.parseResponse(response);
        final apiResponse = ApiResponse.fromJson(
          jsonData,
          (data) => (data as List)
              .map(
                (json) => Restaurant.fromJson(json as Map<String, dynamic>),
              )
              .toList(),
        );

        return apiResponse.data ?? [];
      }
      return [];
    } catch (e) {
      print('Error getting restaurants: $e');
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

