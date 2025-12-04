import 'package:chasqui_ya/data/models/restaurant_model.dart';

class CustomerState {
  final List<Restaurant> restaurants;
  final List<Restaurant> filteredRestaurants;
  final bool isLoading;
  final String? error;
  final String searchQuery;

  const CustomerState({
    this.restaurants = const [],
    this.filteredRestaurants = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
  });

  CustomerState copyWith({
    List<Restaurant>? restaurants,
    List<Restaurant>? filteredRestaurants,
    bool? isLoading,
    String? error,
    String? searchQuery,
  }) {
    return CustomerState(
      restaurants: restaurants ?? this.restaurants,
      filteredRestaurants: filteredRestaurants ?? this.filteredRestaurants,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

