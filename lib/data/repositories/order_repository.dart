import 'dart:convert';
import 'package:chasqui_ya/data/http_service.dart';
import 'package:chasqui_ya/data/models/api_response_model.dart';
import 'package:chasqui_ya/data/models/delivery_order_model.dart';
import 'package:chasqui_ya/data/models/order_request_model.dart';
import 'package:chasqui_ya/data/models/order_response_model.dart';

class OrderRepository {
  final HttpService _httpService = HttpService();

  /// POST /api/orders
  /// Crear un nuevo pedido
  Future<OrderResponse?> createOrder(OrderRequest orderRequest) async {
    try {
      final response = await _httpService.post(
        '/api/orders',
        body: orderRequest.toJson(),
      );

      if (_httpService.isSuccessful(response)) {
        final jsonData = _httpService.parseResponse(response);
        final apiResponse = ApiResponse.fromJson(
          jsonData,
          (data) => OrderResponse.fromJson(data as Map<String, dynamic>),
        );

        if (apiResponse.success && apiResponse.data != null) {
          return apiResponse.data;
        } else {
          // Si la respuesta tiene éxito pero no hay data, lanzar el error del API
          throw Exception(apiResponse.errorMessage);
        }
      } else {
        // Obtener el mensaje de error del servidor
        final errorInfo = _httpService.handleHttpError(response);
        throw Exception(errorInfo['error'] ?? 'Error al crear el pedido');
      }
    } catch (e) {
      // Re-lanzar la excepción para que el notifier pueda capturarla
      rethrow;
    }
  }

  /// GET /api/orders/confirmed
  /// Obtener pedidos confirmados para repartidores
  Future<List<DeliveryOrder>> getConfirmedOrders() async {
    try {
      final response = await _httpService.get('/api/orders/confirmed');

      if (_httpService.isSuccessful(response)) {
        // Parsear el body directamente para manejar arrays y objetos
        dynamic jsonData;
        try {
          jsonData = jsonDecode(response.body);
        } catch (e) {
          throw Exception('Error al parsear respuesta del servidor');
        }
        
        // Manejar diferentes formatos de respuesta
        List<dynamic> ordersList;
        
        // Si la respuesta viene directamente como array
        if (jsonData is List) {
          ordersList = jsonData;
        }
        // Si viene envuelta en ApiResponse
        else if (jsonData is Map<String, dynamic>) {
          if (jsonData.containsKey('success') || jsonData.containsKey('data')) {
            final apiResponse = ApiResponse.fromJson(
              jsonData,
              (data) => data is List ? data : null,
            );
            
            if (apiResponse.success && apiResponse.data != null) {
              ordersList = apiResponse.data as List;
            } else {
              throw Exception(apiResponse.errorMessage);
            }
          }
          // Si viene como objeto con una propiedad que contiene el array
          else if (jsonData.containsKey('orders')) {
            ordersList = jsonData['orders'] as List;
          }
          else {
            throw Exception('Formato de respuesta no reconocido');
          }
        } else {
          throw Exception('Formato de respuesta no reconocido');
        }

        // Parsear los pedidos
        final orders = ordersList.map((json) {
          try {
            return DeliveryOrder.fromJson(json as Map<String, dynamic>);
          } catch (e) {
            // Si falla el parsing de un pedido, continuar con los demás
            return null;
          }
        }).whereType<DeliveryOrder>().toList();

        return orders;
      } else {
        // Obtener el mensaje de error del servidor
        final errorInfo = _httpService.handleHttpError(response);
        throw Exception(errorInfo['error'] ?? 'Error al obtener pedidos');
      }
    } catch (e) {
      // Re-lanzar la excepción para que el notifier pueda capturarla
      rethrow;
    }
  }
}

