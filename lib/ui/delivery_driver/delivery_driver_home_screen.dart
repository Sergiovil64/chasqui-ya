import 'package:chasqui_ya/aplication/auth/auth_notifier.dart';
import 'package:chasqui_ya/aplication/delivery_driver/delivery_driver_provider.dart';
import 'package:chasqui_ya/aplication/delivery_driver/delivery_driver_state.dart';
import 'package:chasqui_ya/config/app_theme.dart';
import 'package:chasqui_ya/data/models/delivery_order_model.dart';
import 'package:chasqui_ya/ui/auth/login_ui.dart';
import 'package:chasqui_ya/ui/widgets/empty_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DeliveryDriverHomeScreen extends ConsumerStatefulWidget {
  const DeliveryDriverHomeScreen({super.key});

  @override
  ConsumerState<DeliveryDriverHomeScreen> createState() =>
      _DeliveryDriverHomeScreenState();
}

class _DeliveryDriverHomeScreenState
    extends ConsumerState<DeliveryDriverHomeScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar pedidos al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(deliveryDriverProvider.notifier).loadConfirmedOrders();
    });
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Cerrar sesión'),
          content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await ref.read(authNotifierProvider.notifier).logout();
                if (mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginUI()),
                    (route) => false,
                  );
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.errorRed,
              ),
              child: const Text('Cerrar sesión'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final driverState = ref.watch(deliveryDriverProvider);
    final currencyFormat = NumberFormat.currency(symbol: 'Bs ', decimalDigits: 0);

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
              'Panel Repartidor',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Cerrar sesión',
            onPressed: () => _showLogoutDialog(context),
          ),
          const SizedBox(width: 8),
        ],
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(deliveryDriverProvider.notifier).refreshOrders(),
        child: _buildBody(driverState, currencyFormat),
      ),
    );
  }

  Widget _buildBody(DeliveryDriverState state, NumberFormat currencyFormat) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
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
                state.error!,
                style: const TextStyle(color: AppTheme.errorRed),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(deliveryDriverProvider.notifier).loadConfirmedOrders();
              },
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    final confirmedOrders = state.confirmedOrders;

    if (confirmedOrders.isEmpty) {
      return EmptyStateWidget(
        title: 'No hay pedidos disponibles',
        subtitle: 'No hay pedidos confirmados en este momento',
      );
    }

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final order = confirmedOrders[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _OrderCard(
                    order: order,
                    currencyFormat: currencyFormat,
                  ),
                );
              },
              childCount: confirmedOrders.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.order,
    required this.currencyFormat,
  });

  final DeliveryOrder order;
  final NumberFormat currencyFormat;

  String _getStatusLabel(String status) {
    switch (status) {
      case 'confirmado':
        return 'Confirmado';
      case 'preparado':
        return 'Preparado';
      case 'en_camino':
        return 'En camino';
      case 'entregado':
        return 'Entregado';
      case 'cancelado':
        return 'Cancelado';
      default:
        return 'Nuevo';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmado':
        return Colors.orange;
      case 'preparado':
        return Colors.blue;
      case 'en_camino':
        return Colors.purple;
      case 'entregado':
        return Colors.green;
      case 'cancelado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con número de pedido y estado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pedido #${order.orderNumber}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('dd/MM/yyyy HH:mm').format(order.createdAt),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getStatusColor(order.status),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    _getStatusLabel(order.status),
                    style: TextStyle(
                      color: _getStatusColor(order.status),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            // Información del restaurante
            if (order.restaurantName != null) ...[
              Row(
                children: [
                  Icon(
                    Icons.restaurant_rounded,
                    size: 20,
                    color: AppTheme.primaryRed,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.restaurantName!,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        if (order.restaurantAddress != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            order.restaurantAddress!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            // Información del cliente
            if (order.customerName != null) ...[
              Row(
                children: [
                  Icon(
                    Icons.person_rounded,
                    size: 20,
                    color: AppTheme.primaryRed,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.customerName!,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        if (order.customerAddress != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            order.customerAddress!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            // Items del pedido
            if (order.items.isNotEmpty) ...[
              const Text(
                'Items:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              ...order.items.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Text(
                          '${item.quantity}x',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryRed,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.menuItemName ?? 'Item ${item.menuItemId}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        Text(
                          currencyFormat.format(item.subtotal),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 16),
            ],
            const Divider(),
            const SizedBox(height: 16),
            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  currencyFormat.format(order.total),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryRed,
                      ),
                ),
              ],
            ),
            // Notas si existen
            if (order.notes != null && order.notes!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.note_rounded,
                      size: 16,
                      color: Colors.blue.shade700,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        order.notes!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

