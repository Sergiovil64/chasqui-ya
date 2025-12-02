import 'package:chasqui_ya/aplication/customer/cart_notifier.dart';
import 'package:chasqui_ya/aplication/customer/cart_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartProvider =
    StateNotifierProvider<CartNotifier, CartState>(
  (ref) => CartNotifier(),
);

