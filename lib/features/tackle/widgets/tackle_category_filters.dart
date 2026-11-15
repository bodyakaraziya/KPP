import 'package:flutter/material.dart';

import '../../../core/models/tackle.dart';
import '../../../core/theme/app_theme.dart';

/// Фільтри категорій снастей з лічильниками (Wrap з chips).
///
/// Стан фільтра керується викликаючим екраном; цей віджет лише приймає
/// поточне значення та викликає колбек при зміні.
class TackleCategoryFilters extends StatelessWidget {
  final String? category;
  final List<Tackle> allTackles;
  final ValueChanged<String?> onChanged;

  const TackleCategoryFilters({
    super.key,
    required this.category,
    required this.allTackles,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final categories = allTackles.map((t) => t.category).toSet().toList()..sort();
    final labels = [
      'Усі',
      ...categories.where((c) => c != 'Інше'),
      if (categories.contains('Інше')) 'Інше',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: labels.map((label) {
        final bool isSelected = label == 'Усі'
            ? category == null
            : category == label;
        final int count = label == 'Усі'
            ? allTackles.length
            : allTackles.where((t) => t.category == label).length;

        return InkWell(
          onTap: () => onChanged(
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
