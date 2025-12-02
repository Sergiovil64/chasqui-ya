import 'package:chasqui_ya/config/app_theme.dart';
import 'package:chasqui_ya/data/models/menu_item_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MenuItemCard extends StatelessWidget {
  const MenuItemCard({
    super.key,
    required this.item,
    this.onAddToCart,
  });

  final MenuItem item;
  final VoidCallback? onAddToCart;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto (image_url de la BD, puede ser null)
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryRed.withValues(alpha: 0.2),
                    AppTheme.secondaryRed.withValues(alpha: 0.1),
                  ],
                ),
              ),
              child: item.imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        item.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.fastfood_rounded,
                            color: AppTheme.primaryRed,
                          );
                        },
                      ),
                    )
                  : const Icon(
                      Icons.fastfood_rounded,
                      color: AppTheme.primaryRed,
                    ),
            ),
            const SizedBox(width: 16),

            // Información del producto (solo campos de la BD)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // name (campo de la BD)
                  Text(
                    item.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  // description (campo de la BD, puede ser null)
                  if (item.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                            height: 1.3,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // price (campo de la BD)
                      Text(
                        currencyFormat.format(item.price),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryRed,
                            ),
                      ),
                      const Spacer(),
                      if (onAddToCart != null)
                        IconButton(
                          onPressed: onAddToCart,
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryRed,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

