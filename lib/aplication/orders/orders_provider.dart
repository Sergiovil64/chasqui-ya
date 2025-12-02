import 'package:chasqui_ya/aplication/orders/orders_notifier.dart';
import 'package:chasqui_ya/aplication/orders/orders_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ordersProvider = StateNotifierProvider<OrdersNotifier, OrdersState>((ref) {
  return OrdersNotifier();
});

