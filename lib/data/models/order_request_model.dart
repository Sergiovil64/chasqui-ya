/// Modelo para crear un pedido (request)
/// Alineado con la estructura de la BD: orders y order_items
class OrderRequest {
  final int customerId;
  final int restaurantId;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String? notes; // Campo nullable según BD
  final List<OrderItemRequest> items;

  OrderRequest({
    required this.customerId,
    required this.restaurantId,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    this.notes,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'restaurant_id': restaurantId,
      'subtotal': subtotal,
      'delivery_fee': deliveryFee,
      'total': total,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

/// Modelo para items del pedido (request)
/// Alineado con la tabla order_items de la BD
class OrderItemRequest {
  final int menuItemId;
  final int quantity;
  final double unitPrice;
  final double subtotal;
  final String? specialInstructions; // Campo nullable según BD

  OrderItemRequest({
    required this.menuItemId,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
    this.specialInstructions,
  });

  Map<String, dynamic> toJson() {
    return {
      'menu_item_id': menuItemId,
      'quantity': quantity,
      'unit_price': unitPrice,
      'subtotal': subtotal,
      if (specialInstructions != null && specialInstructions!.isNotEmpty)
        'special_instructions': specialInstructions,
    };
  }
}

