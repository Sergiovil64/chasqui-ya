import 'package:chasqui_ya/data/http_service.dart';
import 'package:chasqui_ya/data/models/api_response_model.dart';
import 'package:chasqui_ya/data/models/menu_item_model.dart';

class MenuItemRepository {
  final HttpService _httpService = HttpService();

  /// GET /api/menu-items
  /// Lista todos los items del menu con nombre del restaurante
  Future<List<MenuItem>> getAll() async {
    try {
      final response = await _httpService.get('/api/menu-items');

      if (_httpService.isSuccessful(response)) {
        final jsonData = _httpService.parseResponse(response);
        final apiResponse = ApiResponse.fromJson(
          jsonData,
          (data) => (data as List)
              .map(
                (json) => MenuItem.fromJson(json as Map<String, dynamic>),
              )
              .toList(),
        );

        return apiResponse.data ?? [];
      }
      return [];
    } catch (e) {
      print('Error getting menu items: $e');
      return [];
    }
  }

  /// GET /api/menu-items/restaurant/:restaurant_id
  /// Items de un restaurante, ordenados por categoria y nombre
  Future<List<MenuItem>> getByRestaurantId(int restaurantId) async {
    try {
      final response =
          await _httpService.get('/api/menu-items/restaurant/$restaurantId');

      if (_httpService.isSuccessful(response)) {
        final jsonData = _httpService.parseResponse(response);
        final apiResponse = ApiResponse.fromJson(
          jsonData,
          (data) => (data as List)
              .map(
                (json) => MenuItem.fromJson(json as Map<String, dynamic>),
              )
              .toList(),
        );

        return apiResponse.data ?? [];
      }
      return [];
    } catch (e) {
      print('Error getting menu items by restaurant: $e');
      return [];
    }
  }

  /// GET /api/menu-items/restaurant/:restaurant_id/available
  /// Items disponibles (is_available=true) de un restaurante
  Future<List<MenuItem>> getAvailableByRestaurantId(int restaurantId) async {
    try {
      final response = await _httpService
          .get('/api/menu-items/restaurant/$restaurantId/available');

      if (_httpService.isSuccessful(response)) {
        final jsonData = _httpService.parseResponse(response);
        final apiResponse = ApiResponse.fromJson(
          jsonData,
          (data) => (data as List)
              .map(
                (json) {
                  try {
                    return MenuItem.fromJson(json as Map<String, dynamic>);
                  } catch (e) {
                    rethrow;
                  }
                },
              )
              .toList(),
        );

        return apiResponse.data ?? [];
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  /// GET /api/menu-items/category/:category
  /// Items disponibles de una categoria con nombre del restaurante
  Future<List<MenuItem>> getByCategory(String category) async {
    try {
      final response = await _httpService.get('/api/menu-items/category/$category');

      if (_httpService.isSuccessful(response)) {
        final jsonData = _httpService.parseResponse(response);
        final apiResponse = ApiResponse.fromJson(
          jsonData,
          (data) => (data as List)
              .map(
                (json) => MenuItem.fromJson(json as Map<String, dynamic>),
              )
              .toList(),
        );

        return apiResponse.data ?? [];
      }
      return [];
    } catch (e) {
      print('Error getting menu items by category: $e');
      return [];
    }
  }

  /// GET /api/menu-items/:id
  /// Detalle de un item con datos y direccion del restaurante
  Future<MenuItem?> getById(int id) async {
    try {
      final response = await _httpService.get('/api/menu-items/$id');

      if (_httpService.isSuccessful(response)) {
        final jsonData = _httpService.parseResponse(response);
        final apiResponse = ApiResponse.fromJson(
          jsonData,
          (data) => MenuItem.fromJson(data as Map<String, dynamic>),
        );

        return apiResponse.data;
      }

      return null;
    } catch (e) {
      print('Error getting menu item by id: $e');
      return null;
    }
  }

  /// POST /api/menu-items
  /// Crea un item del menú

  Future<MenuItem?> create(Map<String, dynamic> menuItemData) async {
    try {
      final response = await _httpService.post(
        '/api/menu-items',
        body: menuItemData,
      );

      if (_httpService.isSuccessful(response)) {
        final jsonData = _httpService.parseResponse(response);
        final apiResponse = ApiResponse.fromJson(
          jsonData,
          (data) => MenuItem.fromJson(data as Map<String, dynamic>),
        );

        return apiResponse.data;
      }

      return null;
    } catch (e) {
      print('Error creating menu item: $e');
      return null;
    }
  }

  /// PUT /api/menu-items/:id
  /// Actualiza campos de un item

  Future<MenuItem?> update(
    int id,
    Map<String, dynamic> menuItemData,
  ) async {
    try {
      final response = await _httpService.put(
        '/api/menu-items/$id',
        body: menuItemData,
      );

      if (_httpService.isSuccessful(response)) {
        final jsonData = _httpService.parseResponse(response);
        final apiResponse = ApiResponse.fromJson(
          jsonData,
          (data) => MenuItem.fromJson(data as Map<String, dynamic>),
        );

        return apiResponse.data;
      }

      return null;
    } catch (e) {
      print('Error updating menu item: $e');
      return null;
    }
  }

  /// PATCH /api/menu-items/:id/availability
  /// Cambia is_available de un item

  Future<MenuItem?> updateAvailability(int id, bool isAvailable) async {
    try {
      final response = await _httpService.patch(
        '/api/menu-items/$id/availability',
        body: {'is_available': isAvailable},
      );

      if (_httpService.isSuccessful(response)) {
        final jsonData = _httpService.parseResponse(response);
        final apiResponse = ApiResponse.fromJson(
          jsonData,
          (data) => MenuItem.fromJson(data as Map<String, dynamic>),
        );

        return apiResponse.data;
      }

      return null;
    } catch (e) {
      print('Error updating menu item availability: $e');
      return null;
    }
  }

  /// DELETE /api/menu-items/:id
  /// Elimina un item por ID
  Future<bool> delete(int id) async {
    try {
      final response = await _httpService.delete('/api/menu-items/$id');
      return _httpService.isSuccessful(response);
    } catch (e) {
      print('Error deleting menu item: $e');
      return false;
    }
  }
}

