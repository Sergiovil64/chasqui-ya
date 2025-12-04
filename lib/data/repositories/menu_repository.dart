import '../http_service.dart';
import '../models/api_response_model.dart';

class MenuRepository {
  final HttpService _httpService = HttpService();

  // Obtener items del menú de un restaurante
  Future<ApiResponse<List<dynamic>>> getRestaurantMenuItems(
    int restaurantId,
  ) async {
    try {
      final response = await _httpService.get(
        '/api/menu-items/restaurant/$restaurantId',
      );

      final jsonResponse = _httpService.parseResponse(response);

      if (_httpService.isSuccessful(response)) {
        return ApiResponse(
          success: true,
          data: jsonResponse['data'] as List<dynamic>,
        );
      } else {
        final errorData = _httpService.handleHttpError(response);
        return ApiResponse(success: false, error: errorData['error']);
      }
    } catch (e) {
      return ApiResponse(success: false, error: 'Error de conexión: $e');
    }
  }
}
