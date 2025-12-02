import 'package:chasqui_ya/data/models/restaurant_model.dart';

class RestaurantState {
  final Restaurant? restaurant;
  final bool isLoading;
  final String? error;

  const RestaurantState({
    this.restaurant,
    this.isLoading = false,
    this.error,
  });

  RestaurantState copyWith({
    Restaurant? restaurant,
    bool? isLoading,
    String? error,
  }) {
    return RestaurantState(
      restaurant: restaurant ?? this.restaurant,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

