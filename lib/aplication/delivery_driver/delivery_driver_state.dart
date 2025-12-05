import 'package:chasqui_ya/data/models/delivery_order_model.dart';

class DeliveryDriverState {
  final List<DeliveryOrder> orders;
  final bool isLoading;
  final String? error;

  const DeliveryDriverState({
    this.orders = const [],
    this.isLoading = false,
    this.error,
  });

  /// Pedidos confirmados (listos para asignar o recoger)
  List<DeliveryOrder> get confirmedOrders {
    return orders.where((order) => order.isConfirmed || order.isPrepared).toList();
  }

  /// Pedidos en camino (asignados al repartidor actual)
  List<DeliveryOrder> get inTransitOrders {
    return orders.where((order) => order.isInTransit).toList();
  }

  /// Pedidos entregados
  List<DeliveryOrder> get deliveredOrders {
    return orders.where((order) => order.isDelivered).toList();
  }

  DeliveryDriverState copyWith({
    List<DeliveryOrder>? orders,
    bool? isLoading,
    String? error,
  }) {
    return DeliveryDriverState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}


