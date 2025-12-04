import 'package:chasqui_ya/aplication/customer/restaurant_menu_state.dart';
import 'package:chasqui_ya/data/repositories/menu_item_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantMenuNotifier extends StateNotifier<RestaurantMenuState> {
  final MenuItemRepository _repository;

  RestaurantMenuNotifier(this._repository)
      : super(const RestaurantMenuState());

  Future<void> loadMenuItems(int restaurantId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // Usar endpoint real: /api/menu_items/restaurant/:restaurant_id/available
      final items =
          await _repository.getAvailableByRestaurantId(restaurantId);
      state = state.copyWith(
        items: items,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al cargar el menú: ${e.toString()}',
      );
    }
  }

  void clearMenu() {
    state = const RestaurantMenuState();
  }
}

