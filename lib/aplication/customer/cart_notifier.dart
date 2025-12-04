import 'package:chasqui_ya/aplication/customer/cart_state.dart';
import 'package:chasqui_ya/data/models/cart_item_model.dart';
import 'package:chasqui_ya/data/models/menu_item_model.dart';
import 'package:chasqui_ya/data/models/restaurant_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier para gestionar el estado del carrito
class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState());

  /// Agrega un item al carrito (puede ser de cualquier restaurante)
  void addItem(MenuItem menuItem, Restaurant restaurant) {
    final restaurantId = restaurant.id;
    
    // Agregar restaurante al cache si no existe
    final updatedRestaurants = Map<int, Restaurant>.from(state.restaurants);
    if (!updatedRestaurants.containsKey(restaurantId)) {
      updatedRestaurants[restaurantId] = restaurant;
    }

    // Obtener items actuales del restaurante
    final currentItems = List<CartItem>.from(
      state.itemsByRestaurant[restaurantId] ?? [],
    );

    // Buscar si el item ya existe
    final existingIndex = currentItems.indexWhere(
      (item) => item.menuItem.id == menuItem.id,
    );

    if (existingIndex >= 0) {
      // Si ya existe, aumentar cantidad
      currentItems[existingIndex] = currentItems[existingIndex].copyWith(
        quantity: currentItems[existingIndex].quantity + 1,
      );
    } else {
      // Si no existe, agregar nuevo item
      currentItems.add(CartItem(menuItem: menuItem, quantity: 1));
    }

    // Actualizar items del restaurante
    final updatedItemsByRestaurant = Map<int, List<CartItem>>.from(
      state.itemsByRestaurant,
    );
    updatedItemsByRestaurant[restaurantId] = currentItems;

    state = state.copyWith(
      itemsByRestaurant: updatedItemsByRestaurant,
      restaurants: updatedRestaurants,
    );
  }

  /// Remueve un item completamente del carrito
  void removeItem(int restaurantId, int menuItemId) {
    final currentItems = List<CartItem>.from(
      state.itemsByRestaurant[restaurantId] ?? [],
    );

    final updatedItems = currentItems
        .where((item) => item.menuItem.id != menuItemId)
        .toList();

    final updatedItemsByRestaurant = Map<int, List<CartItem>>.from(
      state.itemsByRestaurant,
    );

    if (updatedItems.isEmpty) {
      // Si no quedan items, remover el restaurante
      updatedItemsByRestaurant.remove(restaurantId);
    } else {
      updatedItemsByRestaurant[restaurantId] = updatedItems;
    }

    state = state.copyWith(itemsByRestaurant: updatedItemsByRestaurant);
  }

  /// Actualiza la cantidad de un item
  /// Si quantity <= 0, remueve el item
  void updateQuantity(int restaurantId, int menuItemId, int quantity) {
    if (quantity <= 0) {
      removeItem(restaurantId, menuItemId);
      return;
    }

    final currentItems = List<CartItem>.from(
      state.itemsByRestaurant[restaurantId] ?? [],
    );

    final updatedItems = currentItems.map((item) {
      if (item.menuItem.id == menuItemId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();

    final updatedItemsByRestaurant = Map<int, List<CartItem>>.from(
      state.itemsByRestaurant,
    );
    updatedItemsByRestaurant[restaurantId] = updatedItems;

    state = state.copyWith(itemsByRestaurant: updatedItemsByRestaurant);
  }

  /// Limpia el carrito completamente
  void clearCart() {
    state = const CartState();
  }

  /// Limpia items de un restaurante específico
  void clearRestaurant(int restaurantId) {
    final updatedItemsByRestaurant = Map<int, List<CartItem>>.from(
      state.itemsByRestaurant,
    );
    updatedItemsByRestaurant.remove(restaurantId);

    state = state.copyWith(itemsByRestaurant: updatedItemsByRestaurant);
  }
}

