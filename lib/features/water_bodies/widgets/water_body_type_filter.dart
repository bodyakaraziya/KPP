import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_filter_dropdown.dart';

/// Фільтр водойм за типом — кастомний випадаючий список.
///
/// Стан фільтра керується викликаючим екраном; цей віджет лише приймає
/// поточне значення та викликає колбек при зміні.
class WaterBodyTypeFilter extends StatelessWidget {
  final String? type;
  final List<AppFilterItem<String>> items;
  final ValueChanged<String?> onChanged;

  const WaterBodyTypeFilter({
    super.key,
    required this.type,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Фільтр за типом',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        AppFilterDropdown<String>(
          label: null,
          hint: 'Оберіть тип водойми',
          allOptionLabel: 'Усі типи',
          value: type,
          searchable: items.length > 6,
          items: items,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
