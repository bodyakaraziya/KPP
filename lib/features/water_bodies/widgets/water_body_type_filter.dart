import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_filter_dropdown.dart';
import '../providers/water_bodies_provider.dart';

/// Фільтр водойм за типом — кастомний випадаючий список.
class WaterBodyTypeFilter extends StatelessWidget {
  final WaterBodiesProvider provider;

  const WaterBodyTypeFilter({super.key, required this.provider});

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
          value: provider.filterType,
          searchable: provider.types.length > 6,
          items: provider.types
              .map((type) => AppFilterItem(value: type, label: type))
              .toList(),
          onChanged: provider.setFilterType,
        ),
      ],
    );
  }
}
