import 'package:chasqui_ya/aplication/customer/customer_state.dart';
import 'package:chasqui_ya/data/models/restaurant_model.dart';
import 'package:chasqui_ya/data/repositories/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerNotifier extends StateNotifier<CustomerState> {
  final RestaurantRepository _repository;

  CustomerNotifier(this._repository) : super(const CustomerState()) {
    loadRestaurants();
  }

  Future<void> loadRestaurants() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final restaurants = await _repository.getAll();
      // Solo mostrar restaurantes activos (campo is_active de la BD)
      state = state.copyWith(
        restaurants: restaurants.where((r) => r.isActive).toList(),
        isLoading: false,
      );
      _applyFilters();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al cargar restaurantes: ${e.toString()}',
      );
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFilters();
  }

  void clearSearch() {
    state = state.copyWith(searchQuery: '');
    _applyFilters();
  }

  void _applyFilters() {
    var filtered = List<Restaurant>.from(state.restaurants);

    // Filtro de búsqueda por nombre o descripción (campos reales de la BD)
    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      filtered = filtered.where((restaurant) {
        final nameMatch = restaurant.name.toLowerCase().contains(query);
        final descMatch = restaurant.description.toLowerCase().contains(query);
        return nameMatch || descMatch;
      }).toList();
    }

    state = state.copyWith(filteredRestaurants: filtered);
  }
}

