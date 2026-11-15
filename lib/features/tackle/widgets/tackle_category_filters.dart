import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../providers/tackle_provider.dart';

/// Фільтри категорій снастей з лічильниками (Wrap з chips).
class TackleCategoryFilters extends StatelessWidget {
  final TackleProvider provider;

  const TackleCategoryFilters({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final labels = [
      'Усі',
      ...provider.categories.where((c) => c != 'Інше'),
      if (provider.categories.contains('Інше')) 'Інше',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: labels.map((label) {
        final bool isSelected = label == 'Усі'
            ? provider.filterCategory == null
            : provider.filterCategory == label;
        final int count = label == 'Усі'
            ? provider.allTackles.length
            : provider.allTackles.where((t) => t.category == label).length;

        return InkWell(
          onTap: () => provider.setFilterCategory(
            label == 'Усі' ? null : label,
          ),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.lightTealBg
                  : Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryTeal
                    : AppColors.cardBorder,
                width: 1.2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isSelected
                        ? AppColors.primaryTeal
                        : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryTeal
                        : const Color(0xFFE4ECE9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: isSelected
                          ? Colors.white
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
