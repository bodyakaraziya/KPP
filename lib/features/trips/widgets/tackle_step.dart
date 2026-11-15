import 'package:flutter/material.dart';

import '../../../core/models/tackle.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_filter_dropdown.dart';
import 'trip_form_helpers.dart';

/// Крок 3: Спорядження (снасті).
/// За замовчуванням показуються лише кілька найпопулярніших (за лічильником
/// виїздів). Решта доступні після натискання «Показати всі снасті».
class TackleStep extends StatefulWidget {
  final Set<String> selectedTackle;
  final ValueChanged<String> onTackleToggle;
  final VoidCallback onAddTackle;
  final List<Tackle> tackles;

  const TackleStep({
    super.key,
    required this.selectedTackle,
    required this.onTackleToggle,
    required this.onAddTackle,
    required this.tackles,
  });

  @override
  State<TackleStep> createState() => _TackleStepState();
}

class _TackleStepState extends State<TackleStep> {
  bool _showAll = false;
  final _searchCtrl = TextEditingController();
  String _query = '';
  String? _categoryFilter;

  /// Базовий порядок категорій.
  static const List<String> _categoryOrder = [
    'Вудка',
    'Котушка',
    'Приманка',
    'Наживка',
    'Інше',
  ];

  /// Найпопулярніші снасті (за лічильником виїздів) — перші троє.
  List<Tackle> get _popularTackles {
    final sorted = List<Tackle>.from(widget.tackles)
      ..sort((a, b) => b.tripsCount.compareTo(a.tripsCount));
    return sorted.take(3).toList();
  }

  /// Снасті для скороченого вигляду: популярні плюс вибрані,
  /// щоб новододана снасть відразу була видна як вибрана.
  List<Tackle> get _visibleDefaultTackles {
    final popularIds = _popularTackles.map((t) => t.id).toSet();
    final selectedOthers = widget.tackles.where((t) =>
        widget.selectedTackle.contains(t.name) && !popularIds.contains(t.id))
        .toList();
    return [..._popularTackles, ...selectedOthers];
  }

  /// Усі снасті з урахуванням пошуку та фільтра (для розгорнутого вигляду).
  List<Tackle> get _allFilteredTackles {
    final q = _query.trim().toLowerCase();
    return widget.tackles.where((tackle) {
      if (_categoryFilter != null && tackle.category != _categoryFilter) {
        return false;
      }
      if (q.isNotEmpty && !tackle.name.toLowerCase().contains(q)) {
        return false;
      }
      return true;
    }).toList();
  }

  List<String> _tackleFilterCategories() {
    final cats = widget.tackles.map((t) => t.category).toSet().toList()..sort();
    return cats;
  }

  Map<String, List<Tackle>> get _allByCategory {
    final result = <String, List<Tackle>>{};
    for (final tackle in _allFilteredTackles) {
      result.putIfAbsent(tackle.category, () => []).add(tackle);
    }
    return result;
  }

  List<String> _sortedCategories() {
    final present = _allByCategory.keys.toSet();
    final ordered = <String>[];
    for (final cat in _categoryOrder) {
      if (present.contains(cat)) ordered.add(cat);
    }
    final others = present.toList()..sort()..removeWhere((c) => _categoryOrder.contains(c));
    ordered.addAll(others);
    return ordered;
  }

  Color _categoryColor(String category) {
    switch (category) {
      case 'Вудка':
        return AppColors.primaryTeal;
      case 'Котушка':
        return AppColors.accentGreen;
      case 'Приманка':
        return AppColors.accentAmber;
      case 'Наживка':
        return const Color(0xFF5E4B8B);
      default:
        return AppColors.primaryTeal;
    }
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Вудка':
        return Icons.set_meal_outlined;
      case 'Котушка':
        return Icons.wb_sunny_outlined;
      case 'Приманка':
        return Icons.set_meal_outlined;
      case 'Наживка':
        return Icons.water_drop_outlined;
      default:
        return Icons.label_outlined;
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visibleDefaultTackles;

    return TripSectionCard(
      stepNumber: '3',
      title: 'Спорядження',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок Снасті + лічильник вибраних + кнопка "+ Нова снасть"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Снасті',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.lightTealBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check,
                          size: 14,
                          color: AppColors.primaryTeal,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.selectedTackle.length} вибрано',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryTeal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: widget.onAddTackle,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryTeal,
                      side: const BorderSide(
                        color: AppColors.primaryTeal,
                        width: 1,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.add, size: 15),
                    label: const Text(
                      'Нова снасть',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Найпопулярніші снасті — завжди видимі
          if (visible.isNotEmpty) ...[
            TripFieldLabel(label: 'Популярні снасті'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: visible.map((tackle) {
                return TripTackleChip(
                  label: tackle.name,
                  isSelected: widget.selectedTackle.contains(tackle.name),
                  onTap: () => widget.onTackleToggle(tackle.name),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],

          // Кнопка показу усіх інших снастей
          SizedBox(
            width: double.infinity,
            height: 40,
            child: TextButton.icon(
              onPressed: () => setState(() => _showAll = !_showAll),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryTeal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(
                _showAll ? Icons.expand_less : Icons.expand_more,
                size: 18,
              ),
              label: Text(
                _showAll ? 'Приховати усі снасті' : 'Показати усі снасті',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          if (_showAll) ...[
            // Фільтр за типом снасті
            TripFieldLabel(label: 'Тип снасті'),
            AppFilterDropdown<String>(
              label: null,
              hint: 'Оберіть тип снасті',
              allOptionLabel: 'Усі типи',
              value: _categoryFilter,
              items: _tackleFilterCategories()
                  .map((c) => AppFilterItem(value: c, label: c))
                  .toList(),
              onChanged: (val) => setState(() => _categoryFilter = val),
            ),
            const SizedBox(height: 16),

            // Пошук по назві снасті
            TripFieldLabel(label: 'Пошук снасті'),
            TripInputField(
              controller: _searchCtrl,
              hintText: 'Назва або модель снасті',
              onChanged: (_) => setState(() => _query = _searchCtrl.text),
            ),
            const SizedBox(height: 16),

            if (_allFilteredTackles.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    _query.isNotEmpty || _categoryFilter != null
                        ? 'Снасті за такими фільтрами не знайдено'
                        : 'Інших снастей ще не додано',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              )
            else
              ..._sortedCategories().expand((category) {
                final color = _categoryColor(category);
                return [
                  TripTackleCategoryHeader(
                    icon: _categoryIcon(category),
                    color: color,
                    title: category.toUpperCase(),
                  ),
                  ..._allByCategory[category]!.map((tackle) {
                    return TripTackleChip(
                      label: tackle.name,
                      isSelected: widget.selectedTackle.contains(tackle.name),
                      onTap: () => widget.onTackleToggle(tackle.name),
                    );
                  }),
                  const SizedBox(height: 12),
                ];
              }),
          ],
        ],
      ),
    );
  }
}
