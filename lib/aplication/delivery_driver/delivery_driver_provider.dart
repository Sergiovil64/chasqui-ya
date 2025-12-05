import 'package:chasqui_ya/aplication/delivery_driver/delivery_driver_notifier.dart';
import 'package:chasqui_ya/aplication/delivery_driver/delivery_driver_state.dart';
import 'package:chasqui_ya/data/repositories/order_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deliveryDriverProvider =
    StateNotifierProvider<DeliveryDriverNotifier, DeliveryDriverState>(
  (ref) => DeliveryDriverNotifier(OrderRepository()),
);


