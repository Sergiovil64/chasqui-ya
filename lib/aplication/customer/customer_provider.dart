import 'package:chasqui_ya/aplication/customer/customer_notifier.dart';
import 'package:chasqui_ya/aplication/customer/customer_state.dart';
import 'package:chasqui_ya/data/repositories/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final customerProvider =
    StateNotifierProvider<CustomerNotifier, CustomerState>(
  (ref) => CustomerNotifier(RestaurantRepository()),
);

