import 'package:chasqui_ya/data/models/order_response_model.dart';

class OrderState {
  final OrderResponse? order;
  final bool isLoading;
  final String? error;

  const OrderState({
    this.order,
    this.isLoading = false,
    this.error,
  });

  OrderState copyWith({
    OrderResponse? order,
    bool? isLoading,
    String? error,
  }) {
    return OrderState(
      order: order ?? this.order,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

