import 'package:chasqui_ya/aplication/menu_items/menu_items_provider.dart';
import 'package:chasqui_ya/aplication/orders/orders_provider.dart';
import 'package:chasqui_ya/aplication/restaurant/restaurant_provider.dart';
import 'package:chasqui_ya/data/models/menu_item_model.dart';
import 'package:chasqui_ya/data/models/order_model.dart';
import 'package:chasqui_ya/ui/restaurant/restaurant_editor_screen.dart';
import 'package:chasqui_ya/ui/restaurant/widgets/menu_item_tile.dart';
import 'package:chasqui_ya/ui/restaurant/widgets/pending_orders_tab.dart';
import 'package:chasqui_ya/ui/restaurant/widgets/restaurant_header_card.dart';
import 'package:chasqui_ya/ui/widgets/empty_state_widget.dart';
import 'package:chasqui_ya/ui/widgets/restaurant_deleted_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantHomeScreen extends ConsumerStatefulWidget {
  const RestaurantHomeScreen({super.key});

  @override
  ConsumerState<RestaurantHomeScreen> createState() => _RestaurantHomeScreenState();
}

class _RestaurantHomeScreenState extends ConsumerState<RestaurantHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final restaurantState = ref.watch(restaurantProvider);
    final restaurant = restaurantState.restaurant;
    final ordersState = ref.watch(ordersProvider);
    final pendingOrdersCount = ordersState.orders
        .where((order) => order.status == OrderStatus.pending)
        .length;

    if (restaurant == null) {
      return RestaurantDeletedWidget(
        onRestore: () {
          ref.read(restaurantProvider.notifier).restoreDemo();
          ref.read(menuItemsProvider.notifier).restoreDemo();
        },
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              restaurant.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'Panel restaurante',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              tooltip: 'Editar restaurante',
              icon: Icon(
                Icons.settings_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const RestaurantEditorScreen(),
                  ),
                );
              },
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Colors.grey.shade600,
          indicatorColor: Theme.of(context).colorScheme.primary,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          tabs: [
            const Tab(
              icon: Icon(Icons.restaurant_menu_rounded),
              text: 'Menú',
            ),
            Tab(
              icon: Badge(
                isLabelVisible: pendingOrdersCount > 0,
                label: Text('$pendingOrdersCount'),
                child: const Icon(Icons.receipt_long_rounded),
              ),
              text: 'Pedidos',
            ),
          ],
        ),
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _tabController,
        builder: (context, child) {
          // Mostrar FAB solo en el tab de Menú (index 0)
          if (_tabController.index == 0) {
            return FloatingActionButton.extended(
              onPressed: () => _openMenuItemForm(context, ref),
              label: const Text('Agregar producto'),
              icon: const Icon(Icons.add_rounded),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
            );
          }
          return const SizedBox.shrink();
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: RestaurantHeaderCard(restaurant: restaurant),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMenuTab(),
                const PendingOrdersTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTab() {
    final menuItemsState = ref.watch(menuItemsProvider);
    final menuItems = menuItemsState.items;
    final groupedItems = _groupedMenuItems(menuItems);

    if (groupedItems.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: EmptyStateWidget(
          title: 'Sin productos',
          subtitle:
              'Agrega tus primeros platos para que los clientes puedan verlos.',
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        for (final entry in groupedItems.entries) ...[
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              bottom: 8,
              left: 16,
              right: 16,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.1),
                    Theme.of(context)
                        .colorScheme
                        .secondary
                        .withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    entry.key.toUpperCase(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ],
              ),
            ),
          ),
          ...entry.value.map(
            (item) => MenuItemTile(
              item: item,
              onEdit: () => _openMenuItemForm(
                context,
                ref,
                existing: item,
              ),
              onDelete: () => _confirmDeleteItem(context, ref, item),
              onAvailabilityChanged: (value) {
                ref
                    .read(menuItemsProvider.notifier)
                    .toggleAvailability(item.id, value);
              },
            ),
          ),
        ],
        const SizedBox(height: 80),
      ],
    );
  }

  Map<String, List<MenuItem>> _groupedMenuItems(List<MenuItem> items) {
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

  void _openMenuItemForm(
    BuildContext context,
    WidgetRef ref, {
    MenuItem? existing,
  }) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: existing?.name ?? '');
    final descriptionController =
        TextEditingController(text: existing?.description ?? '');
    final priceController =
        TextEditingController(
            text: existing != null ? existing.price.toStringAsFixed(2) : '');
    final categoryController =
        TextEditingController(text: existing?.category ?? 'pizza');
    bool isAvailable = existing?.isAvailable ?? true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(ctx).colorScheme.primary,
                                Theme.of(ctx).colorScheme.secondary,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.restaurant_menu_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            existing == null ? 'Nuevo producto' : 'Editar producto',
                            style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                        filled: true,
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                        filled: true,
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: priceController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Precio',
                        prefixText: '\$ ',
                        filled: true,
                      ),
                      validator: (value) {
                        final parsed = double.tryParse(value ?? '');
                        if (parsed == null || parsed <= 0) {
                          return 'Ingresa un monto válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: categoryController,
                      decoration: const InputDecoration(
                        labelText: 'Categoría',
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: isAvailable,
                      title: const Text('Disponible para clientes'),
                      onChanged: (value) {
                        setModalState(() {
                          isAvailable = value;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(ctx).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 2,
                        ),
                        onPressed: () {
                          if (formKey.currentState?.validate() != true) {
                            return;
                          }
                          final notifier =
                              ref.read(menuItemsProvider.notifier);
                          if (existing == null) {
                            final newId =
                                (ref.read(menuItemsProvider).items.map((e) => e.id).fold(
                                      0,
                                      (previousValue, element) =>
                                          element > previousValue
                                              ? element
                                              : previousValue,
                                    ) +
                                    1);
                            notifier.addItem(
                              MenuItem(
                                id: newId,
                                restaurantId: 1,
                                name: nameController.text.trim(),
                                description: descriptionController.text.trim(),
                                price: double.parse(priceController.text),
                                category: categoryController.text.trim(),
                                isAvailable: isAvailable,
                                imageUrl: 'https://example.com/image.jpg',
                              ),
                            );
                          } else {
                            notifier.updateItem(
                              existing.copyWith(
                                name: nameController.text.trim(),
                                description:
                                    descriptionController.text.trim(),
                                price: double.parse(priceController.text),
                                category: categoryController.text.trim(),
                                isAvailable: isAvailable,
                              ),
                            );
                          }
                          Navigator.of(ctx).pop();
                        },
                        child:
                            Text(existing == null ? 'Crear producto' : 'Guardar'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _confirmDeleteItem(
    BuildContext context,
    WidgetRef ref,
    MenuItem item,
  ) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.delete_rounded,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              const SizedBox(width: 12),
              const Text('Eliminar producto'),
            ],
          ),
          content: Text(
            '¿Eliminar "${item.name}" del menú?',
            style: const TextStyle(height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(menuItemsProvider.notifier).deleteItem(item.id);
                Navigator.of(ctx).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Colors.white,
              ),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}

