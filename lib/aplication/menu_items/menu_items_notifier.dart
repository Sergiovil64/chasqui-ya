import 'package:chasqui_ya/aplication/menu_items/menu_items_state.dart';
import 'package:chasqui_ya/data/models/menu_item_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuItemsNotifier extends StateNotifier<MenuItemsState> {
  MenuItemsNotifier()
      : super(const MenuItemsState(
          items: _initialItems,
        ));

  static const List<MenuItem> _initialItems = [
    MenuItem(
      id: 1,
      restaurantId: 1,
      name: 'Pizza margarita',
      description: 'Clásica con albahaca fresca y mozzarella.',
      price: 25.5,
      imageUrl: 'https://example.com/image.jpg',
      category: 'pizza',
      isAvailable: true,
    ),
    MenuItem(
      id: 2,
      restaurantId: 1,
      name: 'Pizza cuatro quesos',
      description: 'Mezcla de quesos locales y europeos.',
      price: 27,
      imageUrl: 'https://example.com/image.jpg',
      category: 'pizza',
      isAvailable: true,
    ),
    MenuItem(
      id: 3,
      restaurantId: 1,
      name: 'Seco de chivo',
      description: 'Receta casera acompañada de arroz y aguacate.',
      price: 18,
      imageUrl: 'https://example.com/image.jpg',
      category: 'plato fuerte',
      isAvailable: true,
    ),
    MenuItem(
      id: 4,
      restaurantId: 1,
      name: 'Ensalada andina',
      description: 'Quinua, choclo, tomate cherry y aliño de limón.',
      price: 12.5,
      imageUrl: 'https://example.com/image.jpg',
      category: 'ensaladas',
      isAvailable: false,
    ),
  ];

  void addItem(MenuItem item) {
    state = state.copyWith(items: [...state.items, item]);
  }

  void updateItem(MenuItem updated) {
    final updatedList = [
      for (final item in state.items)
        if (item.id == updated.id) updated else item
    ];
    state = state.copyWith(items: updatedList);
  }

  void deleteItem(int id) {
    final filteredItems = state.items.where((item) => item.id != id).toList();
    state = state.copyWith(items: filteredItems);
  }

  void toggleAvailability(int id, bool isAvailable) {
    final updatedList = [
      for (final item in state.items)
        if (item.id == id) item.copyWith(isAvailable: isAvailable) else item,
    ];
    state = state.copyWith(items: updatedList);
  }

  void clearAll() {
    state = state.copyWith(items: []);
  }

  void restoreDemo() {
    state = const MenuItemsState(items: _initialItems);
  }

  void selectItem(MenuItem? item) {
    state = state.copyWith(selectedItem: item);
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }
}
