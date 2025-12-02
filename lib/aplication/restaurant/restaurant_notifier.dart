import 'package:chasqui_ya/aplication/restaurant/restaurant_state.dart';
import 'package:chasqui_ya/data/models/restaurant_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantNotifier extends StateNotifier<RestaurantState> {
  RestaurantNotifier()
      : super(const RestaurantState(
          restaurant: Restaurant(
            id: 1,
            name: 'Restaurante El Sabor',
            userId: '1',
            description: 'Comida tradicional ecuatoriana con enfoque casero.',
            address: 'Av. Principal 123, Quito',
            latitude: -0.1807,
            longitude: -78.4678,
            imageUrl: 'https://example.com/image.jpg',
            isActive: true,
          ),
        ));

  void updateRestaurant({
    required String name,
    required String description,
    required String address,
    required bool isActive,
  }) {
    if (state.restaurant == null) return;
    state = state.copyWith(
      restaurant: state.restaurant!.copyWith(
        name: name,
        description: description,
        address: address,
        isActive: isActive,
      ),
    );
  }

  void deleteRestaurant() {
    state = state.copyWith(restaurant: null);
  }

  void restoreDemo() {
    state = const RestaurantState(
      restaurant: Restaurant(
        id: 1,
        name: 'Restaurante El Sabor',
        userId: '1',
        description: 'Comida tradicional ecuatoriana con enfoque casero.',
        address: 'Av. Principal 123, Quito',
        latitude: -0.1807,
        longitude: -78.4678,
        imageUrl: 'https://example.com/image.jpg',
        isActive: true,
      ),
    );
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }
}
