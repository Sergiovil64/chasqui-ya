import 'package:chasqui_ya/aplication/customer/cart_provider.dart';
import 'package:chasqui_ya/aplication/customer/customer_provider.dart';
import 'package:chasqui_ya/config/app_theme.dart';
import 'package:chasqui_ya/ui/customer/restaurant_detail_screen.dart';
import 'package:chasqui_ya/ui/customer/widgets/cart_bottom_sheet.dart';
import 'package:chasqui_ya/ui/customer/widgets/restaurant_card.dart';
import 'package:chasqui_ya/ui/widgets/empty_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClientHomeScreen extends ConsumerStatefulWidget {
  const ClientHomeScreen({super.key});

  @override
  ConsumerState<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends ConsumerState<ClientHomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Cargar restaurantes al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(customerProvider.notifier).loadRestaurants();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customerState = ref.watch(customerProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chasqui Ya',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
            ),
            Text(
              'Encuentra tu comida favorita',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ],
        ),
        actions: [
          Consumer(
            builder: (context, ref, child) {
              final cartState = ref.watch(cartProvider);
              return Badge(
                isLabelVisible: cartState.totalItems > 0,
                label: Text('${cartState.totalItems}'),
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart_rounded),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const CartBottomSheet(),
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(customerProvider.notifier).loadRestaurants(),
        child: CustomScrollView(
          slivers: [
            // Barra de búsqueda
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar restaurante...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              _searchController.clear();
                              ref
                                  .read(customerProvider.notifier)
                                  .clearSearch();
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    ref.read(customerProvider.notifier).setSearchQuery(value);
                  },
                ),
              ),
            ),

            // Lista de restaurantes
            if (customerState.isLoading)
              const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (customerState.error != null)
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
                          customerState.error!,
                          style: const TextStyle(color: AppTheme.errorRed),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(customerProvider.notifier).loadRestaurants();
                        },
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                ),
              )
            else if (customerState.filteredRestaurants.isEmpty)
              SliverFillRemaining(
                child: EmptyStateWidget(
                  title: 'No se encontraron restaurantes',
                  subtitle: customerState.searchQuery.isNotEmpty
                      ? 'Intenta con otros términos de búsqueda'
                      : 'No hay restaurantes disponibles en este momento',
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final restaurant =
                          customerState.filteredRestaurants[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: RestaurantCard(
                          restaurant: restaurant,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => RestaurantDetailScreen(
                                  restaurant: restaurant,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                    childCount: customerState.filteredRestaurants.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

