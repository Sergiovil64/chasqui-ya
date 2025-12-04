import 'package:chasqui_ya/aplication/customer/cart_provider.dart';
import 'package:chasqui_ya/config/app_theme.dart';
import 'package:chasqui_ya/data/models/cart_item_model.dart';
import 'package:chasqui_ya/data/models/restaurant_model.dart';
import 'package:chasqui_ya/ui/customer/cart_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CartBottomSheet extends ConsumerWidget {
  const CartBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final currencyFormat = NumberFormat.currency(symbol: 'Bs ', decimalDigits: 0);

    if (cartState.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Icon(
              Icons.shopping_cart_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Tu carrito está vacío',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Agrega platillos del menú',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      );
    }

    final restaurantIds = cartState.itemsByRestaurant.keys.toList();
    final sortedRestaurants = restaurantIds.toList();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Text(
                  'Tus carritos',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          // Lista de restaurantes
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: sortedRestaurants.length,
              itemBuilder: (context, index) {
                final restaurantId = sortedRestaurants[index];
                final restaurant = cartState.getRestaurant(restaurantId);
                final items = cartState.getItemsByRestaurant(restaurantId);
                final subtotal = cartState.getSubtotalByRestaurant(restaurantId);
                final totalItems = items.fold(0, (sum, item) => sum + item.quantity);

                if (restaurant == null) return const SizedBox.shrink();

                return _RestaurantCartCard(
                  restaurant: restaurant,
                  items: items,
                  subtotal: subtotal,
                  totalItems: totalItems,
                  currencyFormat: currencyFormat,
                  isFirst: index == 0,
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _RestaurantCartCard extends ConsumerWidget {
  const _RestaurantCartCard({
    required this.restaurant,
    required this.items,
    required this.subtotal,
    required this.totalItems,
    required this.currencyFormat,
    this.isFirst = false,
  });

  final Restaurant restaurant;
  final List<CartItem> items;
  final double subtotal;
  final int totalItems;
  final NumberFormat currencyFormat;
  final bool isFirst;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop(); // Cerrar bottom sheet
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CartDetailScreen(restaurant: restaurant),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // "Último modificado" solo para el primero
              if (isFirst) ...[
                Text(
                  'Último modificado',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                        fontSize: 11,
                      ),
                ),
                const SizedBox(height: 8),
              ],
              Row(
                children: [
                  // Logo del restaurante
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryRed.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: restaurant.imageUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.network(
                              restaurant.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.restaurant_rounded,
                                color: AppTheme.primaryRed,
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.restaurant_rounded,
                            color: AppTheme.primaryRed,
                          ),
                  ),
                  const SizedBox(width: 12),
                  // Información del restaurante
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          restaurant.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$totalItems ${totalItems == 1 ? 'producto' : 'productos'}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                        ),
                      ],
                    ),
                  ),
                  // Precio y eliminar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        currencyFormat.format(subtotal),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryRed,
                            ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          ref.read(cartProvider.notifier).clearRestaurant(restaurant.id);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Eliminar',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

