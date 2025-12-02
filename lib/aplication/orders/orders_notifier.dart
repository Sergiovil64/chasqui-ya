import 'package:chasqui_ya/aplication/orders/orders_state.dart';
import 'package:chasqui_ya/data/models/order_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrdersNotifier extends StateNotifier<OrdersState> {
  OrdersNotifier() : super(OrdersState(orders: _mockOrders()));

  // Datos mock para demostración
  static List<Order> _mockOrders() {
    final now = DateTime.now();
    return [
      Order(
        id: 1,
        restaurantId: 1,
        customerName: 'María González',
        customerPhone: '+56912345678',
        deliveryAddress: 'Av. Providencia 1234, Santiago',
        items: [
          OrderItem(
            menuItemId: 1,
            name: 'Pizza Margarita',
            quantity: 2,
            price: 12.99,
            notes: 'Sin cebolla',
          ),
          OrderItem(
            menuItemId: 3,
            name: 'Coca Cola 1.5L',
            quantity: 1,
            price: 2.50,
          ),
        ],
        totalAmount: 28.48,
        status: OrderStatus.pending,
        createdAt: now.subtract(const Duration(minutes: 5)),
        specialInstructions: 'Tocar timbre 2 veces',
      ),
      Order(
        id: 2,
        restaurantId: 1,
        customerName: 'Juan Pérez',
        customerPhone: '+56987654321',
        deliveryAddress: 'Los Leones 456, Providencia',
        items: [
          OrderItem(
            menuItemId: 2,
            name: 'Hamburguesa Deluxe',
            quantity: 3,
            price: 15.99,
          ),
          OrderItem(
            menuItemId: 4,
            name: 'Papas Fritas Grande',
            quantity: 2,
            price: 4.50,
          ),
        ],
        totalAmount: 56.97,
        status: OrderStatus.pending,
        createdAt: now.subtract(const Duration(minutes: 12)),
        specialInstructions: 'Sin pepinillos en las hamburguesas',
      ),
      Order(
        id: 3,
        restaurantId: 1,
        customerName: 'Ana Silva',
        customerPhone: '+56923456789',
        deliveryAddress: 'Apoquindo 2000, Las Condes',
        items: [
          OrderItem(
            menuItemId: 5,
            name: 'Ensalada César',
            quantity: 1,
            price: 10.50,
          ),
          OrderItem(
            menuItemId: 6,
            name: 'Pollo Grillado',
            quantity: 1,
            price: 14.99,
          ),
        ],
        totalAmount: 25.49,
        status: OrderStatus.pending,
        createdAt: now.subtract(const Duration(minutes: 3)),
      ),
      Order(
        id: 4,
        restaurantId: 1,
        customerName: 'Carlos Ramírez',
        customerPhone: '+56934567890',
        deliveryAddress: 'Vitacura 3500, Vitacura',
        items: [
          OrderItem(
            menuItemId: 1,
            name: 'Pizza Margarita',
            quantity: 1,
            price: 12.99,
          ),
          OrderItem(
            menuItemId: 7,
            name: 'Lasagna',
            quantity: 2,
            price: 13.50,
          ),
        ],
        totalAmount: 39.99,
        status: OrderStatus.pending,
        createdAt: now.subtract(const Duration(minutes: 8)),
        specialInstructions: 'Dejar en la puerta del edificio',
      ),
      Order(
        id: 5,
        restaurantId: 1,
        customerName: 'Laura Martínez',
        customerPhone: '+56945678901',
        deliveryAddress: 'Av. Kennedy 5600, Las Condes',
        items: [
          OrderItem(
            menuItemId: 8,
            name: 'Sushi Mix',
            quantity: 1,
            price: 22.99,
          ),
        ],
        totalAmount: 22.99,
        status: OrderStatus.pending,
        createdAt: now.subtract(const Duration(minutes: 15)),
      ),
    ];
  }

  void updateOrderStatus(int orderId, OrderStatus newStatus) {
    state = state.copyWith(
      orders: state.orders.map((order) {
        if (order.id == orderId) {
          return order.copyWith(status: newStatus);
        }
        return order;
      }).toList(),
    );
  }

  void acceptOrder(int orderId) {
    updateOrderStatus(orderId, OrderStatus.preparing);
  }

  void markAsReady(int orderId) {
    updateOrderStatus(orderId, OrderStatus.ready);
  }

  void cancelOrder(int orderId) {
    updateOrderStatus(orderId, OrderStatus.cancelled);
  }

  void refreshOrders() {
    // En producción, aquí se haría una llamada al API
    // Por ahora, solo simularemos una actualización
    state = state.copyWith(
      isLoading: true,
    );

    // Simular delay de red
    Future.delayed(const Duration(seconds: 1), () {
      state = state.copyWith(
        orders: _mockOrders(),
        isLoading: false,
      );
    });
  }
}

