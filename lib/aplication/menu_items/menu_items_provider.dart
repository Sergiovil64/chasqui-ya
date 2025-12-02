import 'package:chasqui_ya/aplication/menu_items/menu_items_notifier.dart';
import 'package:chasqui_ya/aplication/menu_items/menu_items_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final menuItemsProvider =
    StateNotifierProvider<MenuItemsNotifier, MenuItemsState>(
  (ref) => MenuItemsNotifier(),
);
