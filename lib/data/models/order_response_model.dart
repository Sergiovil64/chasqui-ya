/// Modelo para la respuesta del API al crear un pedido
/// Alineado con la estructura de la BD: orders
class OrderResponse {
  final int id;
  final int customerId;
  final int restaurantId;
  final int? deliveryDriverId; // Nullable según BD
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

  OrderResponse({
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
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
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

