import 'package:chasqui_ya/data/models/cart_item_model.dart';
import 'package:chasqui_ya/data/models/restaurant_model.dart';

/// Estado del carrito de compras
/// Permite múltiples restaurantes con sus respectivos items
class CartState {
  final Map<int, List<CartItem>> itemsByRestaurant; // Agrupa por restaurant_id
  final Map<int, Restaurant> restaurants; // Cache de restaurantes

  const CartState({
    this.itemsByRestaurant = const {},
    this.restaurants = const {},
  });

  /// Obtener todos los items de todos los restaurantes
  List<CartItem> get allItems {
    return itemsByRestaurant.values.expand((items) => items).toList();
  }

  /// Total de items (suma de quantities)
  int get totalItems => allItems.fold(0, (sum, item) => sum + item.quantity);

  /// Subtotal total (suma de todos los subtotals)
  double get totalSubtotal => allItems.fold(0.0, (sum, item) => sum + item.subtotal);

  /// Obtener items de un restaurante específico
  List<CartItem> getItemsByRestaurant(int restaurantId) {
    return itemsByRestaurant[restaurantId] ?? [];
  }

  /// Subtotal de un restaurante específico
  double getSubtotalByRestaurant(int restaurantId) {
    final items = getItemsByRestaurant(restaurantId);
    return items.fold(0.0, (sum, item) => sum + item.subtotal);
  }

  /// Obtener restaurante por ID
  Restaurant? getRestaurant(int restaurantId) {
    return restaurants[restaurantId];
  }

  /// Verificar si hay items
  bool get isEmpty => itemsByRestaurant.isEmpty;

  CartState copyWith({
    Map<int, List<CartItem>>? itemsByRestaurant,
    Map<int, Restaurant>? restaurants,
  }) {
    return CartState(
      itemsByRestaurant: itemsByRestaurant ?? this.itemsByRestaurant,
      restaurants: restaurants ?? this.restaurants,
    );
  }
}

