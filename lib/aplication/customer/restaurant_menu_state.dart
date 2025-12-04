import 'package:chasqui_ya/data/models/menu_item_model.dart';

class RestaurantMenuState {
  final List<MenuItem> items;
  final bool isLoading;
  final String? error;

  const RestaurantMenuState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  RestaurantMenuState copyWith({
    List<MenuItem>? items,
    bool? isLoading,
    String? error,
  }) {
    return RestaurantMenuState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

