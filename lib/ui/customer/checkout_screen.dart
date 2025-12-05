import 'package:chasqui_ya/aplication/auth/auth_notifier.dart';
import 'package:chasqui_ya/aplication/customer/cart_provider.dart';
import 'package:chasqui_ya/aplication/customer/order_provider.dart';
import 'package:chasqui_ya/config/app_theme.dart';
import 'package:chasqui_ya/data/models/cart_item_model.dart';
import 'package:chasqui_ya/data/models/restaurant_model.dart';
import 'package:chasqui_ya/ui/customer/client_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({
    super.key,
    required this.restaurant,
    required this.cartItems,
  });

  final Restaurant restaurant;
  final List<CartItem> cartItems;

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final TextEditingController _notesController = TextEditingController();
  final currencyFormat = NumberFormat.currency(symbol: 'Bs ', decimalDigits: 0);

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  double get _subtotal {
    return widget.cartItems.fold(0.0, (sum, item) => sum + item.subtotal);
  }

  double get _deliveryFee => 0.0; // Por ahora gratis

  double get _serviceFee => 0.0; // Por ahora 0

  double get _total => _subtotal + _deliveryFee + _serviceFee;

  Future<void> _confirmOrder() async {
    final authState = ref.read(authNotifierProvider);
    final customerId = authState.profile?['id'] as int?;

    if (customerId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: No se pudo obtener la información del cliente'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
      return;
    }

    final orderState = ref.read(orderProvider);
    if (orderState.isLoading) return;

    // Preparar items para el pedido
    final items = widget.cartItems.map((cartItem) {
      return {
        'menu_item_id': cartItem.menuItem.id,
        'quantity': cartItem.quantity,
        'unit_price': cartItem.unitPrice,
        'subtotal': cartItem.subtotal,
        'special_instructions': cartItem.specialInstructions,
      };
    }).toList();

    final success = await ref.read(orderProvider.notifier).createOrder(
      customerId: customerId,
      restaurantId: widget.restaurant.id,
      subtotal: _subtotal,
      deliveryFee: _deliveryFee,
      total: _total,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      items: items,
    );

    if (mounted) {
      if (success) {
        // Limpiar el carrito para este restaurante
        for (final item in widget.cartItems) {
          ref.read(cartProvider.notifier).removeItem(
            item.menuItem.restaurantId,
            item.menuItem.id,
          );
        }

        // Navegar al home y mostrar mensaje de éxito
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const ClientHomeScreen()),
          (route) => false,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('¡Pedido confirmado exitosamente!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        final error = ref.read(orderProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Error al confirmar el pedido'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Resumen del pedido',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Resumen
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Resumen',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 16),
                        // Productos
                        _SummaryRow(
                          label: 'Productos',
                          value: currencyFormat.format(_subtotal),
                        ),
                        const SizedBox(height: 12),
                        // Envío
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Envío'),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.yellow.shade100,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'GRATIS',
                                    style: TextStyle(
                                      color: Colors.orange.shade800,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(currencyFormat.format(_deliveryFee)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Tarifa de servicio
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text('Tarifa de servicio'),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.info_outline_rounded,
                                  size: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ],
                            ),
                            Text(currencyFormat.format(_serviceFee)),
                          ],
                        ),
                        const Divider(height: 32),
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
                              currencyFormat.format(_total),
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryRed,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Datos de facturación (placeholder)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryRed.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.receipt_rounded,
                              color: AppTheme.primaryRed,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text('Agrega tus datos de facturación'),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Notas adicionales (opcional)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notas adicionales (opcional)',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _notesController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Instrucciones especiales para el pedido...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Botón de confirmar pedido
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: orderState.isLoading ? null : _confirmOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryRed,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor: Colors.grey.shade300,
                  ),
                  child: orderState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          'Confirmar pedido (${currencyFormat.format(_total)})',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

