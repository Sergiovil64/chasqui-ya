import 'package:chasqui_ya/aplication/customer/restaurant_menu_provider.dart';
import 'package:chasqui_ya/config/app_theme.dart';
import 'package:chasqui_ya/data/models/menu_item_model.dart';
import 'package:chasqui_ya/data/models/restaurant_model.dart';
import 'package:chasqui_ya/ui/customer/widgets/menu_item_card.dart';
import 'package:chasqui_ya/ui/widgets/empty_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantDetailScreen extends ConsumerWidget {
  const RestaurantDetailScreen({
    super.key,
    required this.restaurant,
  });

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuState = ref.watch(restaurantMenuProvider(restaurant.id));
    final groupedItems = _groupMenuItems(menuState.items);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: CustomScrollView(
        slivers: [
          // AppBar con imagen (image_url de la BD)
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryRed,
                          AppTheme.secondaryRed,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: restaurant.imageUrl.isNotEmpty
                        ? Image.network(
                            restaurant.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.restaurant_rounded,
                                size: 80,
                                color: Colors.white,
                              );
                            },
                          )
                        : const Icon(
                            Icons.restaurant_rounded,
                            size: 80,
                            color: Colors.white,
                          ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.5),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),

          // Información del restaurante (solo campos de la BD)
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // name (campo de la BD)
                  Text(
                    restaurant.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                  ),
                  // description (campo de la BD, puede ser null)
                  if (restaurant.description.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      restaurant.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade700,
                            height: 1.5,
                          ),
                    ),
                  ],
                  // address (campo de la BD)
                  if (restaurant.address.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 20,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            restaurant.address,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.grey.shade700,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Menú (usando menu_items de la BD)
          if (menuState.isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (menuState.error != null)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 64,
                      color: AppTheme.errorRed,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        menuState.error!,
                        style: const TextStyle(color: AppTheme.errorRed),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref
                            .read(restaurantMenuProvider(restaurant.id).notifier)
                            .loadMenuItems(restaurant.id);
                      },
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            )
          else if (groupedItems.isEmpty)
            SliverFillRemaining(
              child: EmptyStateWidget(
                title: 'Sin productos disponibles',
                subtitle: 'Este restaurante no tiene productos en su menú',
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final entry = groupedItems.entries.elementAt(index);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // category (campo de la BD)
                        Padding(
                          padding: EdgeInsets.only(
                            top: index > 0 ? 24 : 0,
                            bottom: 12,
                            left: 4,
                          ),
                          child: Text(
                            entry.key.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryRed,
                                  letterSpacing: 1.2,
                                ),
                          ),
                        ),
                        ...entry.value.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: MenuItemCard(item: item),
                          ),
                        ),
                      ],
                    );
                  },
                  childCount: groupedItems.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Map<String, List<MenuItem>> _groupMenuItems(List<MenuItem> items) {
    final sorted = [...items]
      ..sort(
        (a, b) => a.category == b.category
            ? a.name.compareTo(b.name)
            : a.category.compareTo(b.category),
      );
    final Map<String, List<MenuItem>> grouped = {};
    for (final item in sorted) {
      grouped.putIfAbsent(item.category, () => []).add(item);
    }
    return grouped;
  }
}

