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
      print('🔄 [RestaurantMenuNotifier] Cargando menú para restaurante ID: $restaurantId');
      // Usar endpoint real: /api/menu_items/restaurant/:restaurant_id/available
      final items =
          await _repository.getAvailableByRestaurantId(restaurantId);
      print('📊 [RestaurantMenuNotifier] Items recibidos: ${items.length}');
      state = state.copyWith(
        items: items,
        isLoading: false,
      );
      print('✅ [RestaurantMenuNotifier] Estado actualizado. Total items: ${state.items.length}');
    } catch (e, stackTrace) {
      print('❌ [RestaurantMenuNotifier] Error completo: $e');
      print('❌ [RestaurantMenuNotifier] StackTrace: $stackTrace');
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

