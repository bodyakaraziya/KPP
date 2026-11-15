import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// Один елемент улову з фото, назвою, вагою, довжиною та часом.
class TripDetailCatchItem extends StatelessWidget {
  final String imageUrl;
  final String fishName;
  final String weight;
  final String length;
  final String time;

  const TripDetailCatchItem({
    super.key,
    required this.imageUrl,
    required this.fishName,
    required this.weight,
    required this.length,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F7F6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              imageUrl,
              width: 88,
              height: 88,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 88,
                height: 88,
                color: Colors.grey[300],
                alignment: Alignment.center,
                child: Icon(
                  Icons.image,
                  size: 28,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fishName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    TripDetailCatchSubChip(
                      icon: Icons.set_meal_outlined,
                      label: weight,
                    ),
                    TripDetailCatchSubChip(label: length),
                    TripDetailCatchSubChip(
                      icon: Icons.access_time,
                      label: time,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Малий чіп усередині елемента улову.
class TripDetailCatchSubChip extends StatelessWidget {
  final IconData? icon;
  final String label;

  const TripDetailCatchSubChip({super.key, this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF2F0),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: AppColors.textPrimary),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
