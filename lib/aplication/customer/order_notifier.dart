import 'package:chasqui_ya/aplication/customer/order_state.dart';
import 'package:chasqui_ya/data/models/order_request_model.dart';
import 'package:chasqui_ya/data/repositories/order_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderNotifier extends StateNotifier<OrderState> {
  final OrderRepository _repository;

  OrderNotifier(this._repository) : super(const OrderState());

  Future<bool> createOrder({
    required int customerId,
    required int restaurantId,
    required double subtotal,
    required double deliveryFee,
    required double total,
    String? notes,
    required List<Map<String, dynamic>> items,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final orderRequest = OrderRequest(
        customerId: customerId,
        restaurantId: restaurantId,
        subtotal: subtotal,
        deliveryFee: deliveryFee,
        total: total,
        notes: notes,
        items: items.map((item) => OrderItemRequest(
          menuItemId: item['menu_item_id'] as int,
          quantity: item['quantity'] as int,
          unitPrice: item['unit_price'] as double,
          subtotal: item['subtotal'] as double,
          specialInstructions: item['special_instructions'] as String?,
        )).toList(),
      );

      final orderResponse = await _repository.createOrder(orderRequest);
      
      if (orderResponse != null) {
        state = state.copyWith(
          isLoading: false,
          order: orderResponse,
          error: null,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'No se pudo crear el pedido',
        );
        return false;
      }
    } catch (e) {
      // Capturar el mensaje de error real del servidor
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      state = state.copyWith(
        isLoading: false,
        error: errorMessage.isNotEmpty ? errorMessage : 'Error al crear el pedido',
      );
      return false;
    }
  }

  void clearOrder() {
    state = const OrderState();
  }
}

