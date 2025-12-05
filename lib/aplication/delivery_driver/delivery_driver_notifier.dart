import 'package:chasqui_ya/aplication/delivery_driver/delivery_driver_state.dart';
import 'package:chasqui_ya/data/repositories/order_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeliveryDriverNotifier extends StateNotifier<DeliveryDriverState> {
  final OrderRepository _repository;

  DeliveryDriverNotifier(this._repository)
      : super(const DeliveryDriverState());

  /// Cargar pedidos confirmados y disponibles para el repartidor
  Future<void> loadConfirmedOrders() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final orders = await _repository.getConfirmedOrders();
      
      state = state.copyWith(
        orders: orders,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      // Capturar el mensaje de error real del servidor
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      state = state.copyWith(
        isLoading: false,
        error: errorMessage.isNotEmpty 
            ? errorMessage 
            : 'Error al cargar pedidos. Verifica tu conexión.',
      );
    }
  }

  /// Refrescar la lista de pedidos
  Future<void> refreshOrders() async {
    await loadConfirmedOrders();
  }
}

