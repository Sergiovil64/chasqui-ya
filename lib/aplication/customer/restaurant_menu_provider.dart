import 'package:chasqui_ya/aplication/customer/restaurant_menu_notifier.dart';
import 'package:chasqui_ya/aplication/customer/restaurant_menu_state.dart';
import 'package:chasqui_ya/data/repositories/menu_item_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantMenuProvider =
    StateNotifierProvider.family<RestaurantMenuNotifier, RestaurantMenuState,
        int>(
  (ref, restaurantId) {
    final repository = MenuItemRepository();
    final notifier = RestaurantMenuNotifier(repository);
    notifier.loadMenuItems(restaurantId);
    return notifier;
  },
);

