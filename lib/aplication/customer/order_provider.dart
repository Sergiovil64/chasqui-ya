import 'package:chasqui_ya/aplication/customer/order_notifier.dart';
import 'package:chasqui_ya/aplication/customer/order_state.dart';
import 'package:chasqui_ya/data/repositories/order_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final orderProvider = StateNotifierProvider<OrderNotifier, OrderState>(
  (ref) => OrderNotifier(OrderRepository()),
);

