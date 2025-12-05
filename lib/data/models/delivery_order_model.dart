/// Modelo de pedido para el repartidor
/// Alineado con la estructura de la BD: orders y order_items
class DeliveryOrder {
  final int id;
  final int customerId;
  final int restaurantId;
  final int? deliveryDriverId;
  final String orderNumber;
  final String status; // 'nuevo', 'confirmado', 'preparado', 'en_camino', 'entregado', 'cancelado'
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String? notes;
  final String? cancelledReason;
  final DateTime createdAt;
  final DateTime? confirmedAt;
  final DateTime? preparedAt;
  final DateTime? pickedUpAt;
  final DateTime? deliveredAt;
  final DateTime? cancelledAt;
  
  // Información relacionada (desde joins)
  final String? restaurantName;
  final String? restaurantAddress;
  final String? customerName;
  final String? customerAddress;
  final List<DeliveryOrderItem> items;

  DeliveryOrder({
    required this.id,
    required this.customerId,
    required this.restaurantId,
    this.deliveryDriverId,
    required this.orderNumber,
    required this.status,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    this.notes,
    this.cancelledReason,
    required this.createdAt,
    this.confirmedAt,
    this.preparedAt,
    this.pickedUpAt,
    this.deliveredAt,
    this.cancelledAt,
    this.restaurantName,
    this.restaurantAddress,
    this.customerName,
    this.customerAddress,
    this.items = const [],
  });

  factory DeliveryOrder.fromJson(Map<String, dynamic> json) {
    return DeliveryOrder(
      id: _parseInt(json['id']),
      customerId: _parseInt(json['customer_id']),
      restaurantId: _parseInt(json['restaurant_id']),
      deliveryDriverId: json['delivery_driver_id'] != null
          ? _parseInt(json['delivery_driver_id'])
          : null,
      orderNumber: json['order_number'] as String,
      status: json['status'] as String,
      subtotal: _parseDouble(json['subtotal']),
      deliveryFee: _parseDouble(json['delivery_fee']),
      total: _parseDouble(json['total']),
      notes: json['notes'] as String?,
      cancelledReason: json['cancelled_reason'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      confirmedAt: json['confirmed_at'] != null
          ? DateTime.parse(json['confirmed_at'] as String)
          : null,
      preparedAt: json['prepared_at'] != null
          ? DateTime.parse(json['prepared_at'] as String)
          : null,
      pickedUpAt: json['picked_up_at'] != null
          ? DateTime.parse(json['picked_up_at'] as String)
          : null,
      deliveredAt: json['delivered_at'] != null
          ? DateTime.parse(json['delivered_at'] as String)
          : null,
      cancelledAt: json['cancelled_at'] != null
          ? DateTime.parse(json['cancelled_at'] as String)
          : null,
      restaurantName: json['restaurant_name'] as String?,
      restaurantAddress: json['restaurant_address'] as String?,
      customerName: json['customer_name'] as String?,
      customerAddress: json['customer_address'] as String?,
      items: json['items'] != null
          ? (json['items'] as List)
              .map((item) => DeliveryOrderItem.fromJson(item as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  // Helper para parsear int de manera segura
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  // Helper para parsear double de manera segura
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  bool get isConfirmed => status == 'confirmado';
  bool get isPrepared => status == 'preparado';
  bool get isInTransit => status == 'en_camino';
  bool get isDelivered => status == 'entregado';
  bool get isCancelled => status == 'cancelado';
}

/// Modelo de item del pedido para el repartidor
/// Alineado con la tabla order_items de la BD
class DeliveryOrderItem {
  final int id;
  final int orderId;
  final int menuItemId;
  final int quantity;
  final double unitPrice;
  final double subtotal;
  final String? specialInstructions;
  final String? menuItemName; // Información adicional

  DeliveryOrderItem({
    required this.id,
    required this.orderId,
    required this.menuItemId,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
    this.specialInstructions,
    this.menuItemName,
  });

  factory DeliveryOrderItem.fromJson(Map<String, dynamic> json) {
    return DeliveryOrderItem(
      id: _parseInt(json['id']),
      orderId: _parseInt(json['order_id']),
      menuItemId: _parseInt(json['menu_item_id']),
      quantity: _parseInt(json['quantity']),
      unitPrice: _parseDouble(json['unit_price']),
      subtotal: _parseDouble(json['subtotal']),
      specialInstructions: json['special_instructions'] as String?,
      menuItemName: json['menu_item_name'] as String?,
    );
  }

  // Helper para parsear int de manera segura
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  // Helper para parsear double de manera segura
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }
}


