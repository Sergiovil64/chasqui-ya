import 'package:chasqui_ya/data/models/menu_item_model.dart';

class MenuItemsState {
  final List<MenuItem> items;
  final MenuItem? selectedItem;
  final bool isLoading;
  final String? error;

  const MenuItemsState({
    this.items = const [],
    this.selectedItem,
    this.isLoading = false,
    this.error,
  });

  MenuItemsState copyWith({
    List<MenuItem>? items,
    MenuItem? selectedItem,
    bool? isLoading,
    String? error,
  }) {
    return MenuItemsState(
      items: items ?? this.items,
      selectedItem: selectedItem ?? this.selectedItem,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

