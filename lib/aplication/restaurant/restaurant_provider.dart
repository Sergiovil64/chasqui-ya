import 'package:chasqui_ya/aplication/restaurant/restaurant_notifier.dart';
import 'package:chasqui_ya/aplication/restaurant/restaurant_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantProvider =
    StateNotifierProvider<RestaurantNotifier, RestaurantState>(
  (ref) => RestaurantNotifier(),
);
