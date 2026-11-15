import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// Чіп погоди (сонячно, температура і т.п.).
class TripDetailWeatherChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isHighlighted;

  const TripDetailWeatherChip({
    super.key,
    required this.icon,
    required this.label,
    required this.isHighlighted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: isHighlighted ? AppColors.lightTealBg : const Color(0xFFF3F7F6),
        borderRadius: BorderRadius.circular(12),
        border: isHighlighted
            ? null
            : Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isHighlighted
                ? AppColors.primaryTeal
                : AppColors.textPrimary,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isHighlighted
                  ? AppColors.primaryTeal
                  : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Чіп спорядження (вудка, котушка, приманка).
class TripDetailGearChip extends StatelessWidget {
  final String text;

  const TripDetailGearChip({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F7F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.wb_sunny_outlined,
            size: 16,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
