import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_filter_dropdown.dart';
import '../providers/trips_provider.dart';

/// Панель фільтрів виїздів (Водойма, Дата, Вид риби) зі сховаючим розгортанням.
class TripsFiltersBar extends StatefulWidget {
  final TripsProvider provider;

  const TripsFiltersBar({super.key, required this.provider});

  @override
  State<TripsFiltersBar> createState() => _TripsFiltersBarState();
}

class _TripsFiltersBarState extends State<TripsFiltersBar> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final provider = widget.provider;
    final customRange = provider.customDateRange;
    final periodItems = const <String>['За тиждень', 'За місяць', 'За рік'];

    String periodHint;
    if (customRange != null) {
      periodHint = 'З ${_fmt(customRange.start)} по ${_fmt(customRange.end)}';
    } else {
      periodHint = 'Оберіть період';
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Верхня шапка (клікабельна)
          InkWell(
            onTap: () => setState(() => isExpanded = !isExpanded),
            borderRadius: BorderRadius.circular(22),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.lightTealBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.filter_alt_outlined,
                      color: AppColors.primaryTeal,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Фільтри виїздів',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isExpanded
                              ? 'Оберіть потрібні параметри'
                              : 'Показано всі виїзди',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.textSecondary,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),

          // Розгорнута частина
          if (isExpanded) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(color: AppColors.cardBorder, height: 1),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Фільтр за водоймою — пов'язаний з TripsProvider
                  AppFilterDropdown<String>(
                    label: 'Водойма',
                    hint: 'Оберіть водойму',
                    allOptionLabel: 'Усі водойми',
                    value: provider.filterWaterBody,
                    items: provider.waterBodies
                        .map((name) => AppFilterItem(value: name, label: name))
                        .toList(),
                    onChanged: provider.setFilterWaterBody,
                  ),
                  const SizedBox(height: 14),
                  // Період + календар (власна дата)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Період',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: AppFilterDropdown<String>(
                              label: null,
                              hint: periodHint,
                              allOptionLabel: 'За весь час',
                              value: provider.filterPeriod,
                              items: periodItems
                                  .map((name) => AppFilterItem(
                                        value: name,
                                        label: name,
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                if (val == null) {
                                  provider.setFilterPeriod(null);
                                  provider.setCustomDateRange(null);
                                } else {
                                  provider.setFilterPeriod(val);
                                  provider.setCustomDateRange(null);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          _buildCalendarButton(),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  AppFilterDropdown<String>(
                    label: 'Вид риби',
                    hint: 'Оберіть вид риби',
                    allOptionLabel: 'Усі види',
                    value: provider.filterFishType,
                    items: provider.fishTypes
                        .map((name) => AppFilterItem(value: name, label: name))
                        .toList(),
                    onChanged: provider.setFilterFishType,
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => setState(() => isExpanded = false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryTeal,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Показати виїзди',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Кнопка календаря для вибору власного періоду (свої дати).
  Widget _buildCalendarButton() {
    final range = widget.provider.customDateRange;
    return InkWell(
      onTap: _pickCustomDateRange,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: range != null ? AppColors.primaryTeal : Colors.white.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(14),
          border: range == null ? Border.all(color: AppColors.cardBorder, width: 1.2) : null,
        ),
        child: Icon(
          Icons.calendar_today,
          size: 20,
          color: range != null ? Colors.white : AppColors.textSecondary,
        ),
      ),
    );
  }

  /// Вибір власного проміжку дат через календар (як на екрані статистики).
  Future<void> _pickCustomDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: widget.provider.customDateRange ??
          DateTimeRange(
            start: DateTime.now().subtract(const Duration(days: 7)),
            end: DateTime.now(),
          ),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      cancelText: 'СКАСУВАТИ',
      confirmText: 'ОБРАТИ',
      helpText: 'ОБЕРІТЬ ПРОМІЖОК ДАТ',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryTeal,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      widget.provider.setCustomDateRange(picked);
      widget.provider.setFilterPeriod(null);
    }
  }

  String _fmt(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
  }
}
