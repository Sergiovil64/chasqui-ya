import 'package:chasqui_ya/data/models/menu_item_model.dart';

/// Modelo para items del carrito
/// Alineado con la tabla order_items de la BD
class CartItem {
  const CartItem({
    required this.menuItem,
    required this.quantity,
    this.specialInstructions,
  });

  final MenuItem menuItem;
  final int quantity;
  final String? specialInstructions; // Campo nullable según BD (special_instructions text)

  /// unit_price: precio al momento de agregar al carrito (según BD)
  double get unitPrice => menuItem.price;

  /// subtotal: quantity * unit_price (según BD)
  double get subtotal => quantity * unitPrice;

  /// Para facilitar la creación de order_items
  Map<String, dynamic> toOrderItemJson() {
    return {
      'menu_item_id': menuItem.id,
      'quantity': quantity,
      'unit_price': unitPrice,
      'subtotal': subtotal,
      'special_instructions': specialInstructions,
    };
  }

  CartItem copyWith({
    MenuItem? menuItem,
    int? quantity,
    String? specialInstructions,
  }) {
    return CartItem(
      menuItem: menuItem ?? this.menuItem,
      quantity: quantity ?? this.quantity,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }
}

