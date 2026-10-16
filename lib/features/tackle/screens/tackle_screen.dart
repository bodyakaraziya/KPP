import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/tackle_card.dart';
import '../../../core/widgets/app_fab.dart';
import 'tackle_detail_screen.dart';

class TackleScreen extends StatefulWidget {
  const TackleScreen({super.key});

  @override
  State<TackleScreen> createState() => _TackleScreenState();
}

class _TackleScreenState extends State<TackleScreen> {
  String _selectedFilter = 'Усі';

  // Hardcoded-список із 7 снастей відповідно до макета Figma
  static const List<Map<String, String>> _allTackle = [
    {
      'category': 'Вудка',
      'name': 'Спінінг Favorite X1 2.1м',
      'notes': 'Тест 7–28г. Основний спінінг для щуки.',
      'tripsCount': '12 виїздів',
    },
    {
      'category': 'Котушка',
      'name': 'Shimano Nasci C3000',
      'notes': 'Передавальне число 6.2:1. Бездоганна намотка.',
      'tripsCount': '12 виїздів',
    },
    {
      'category': 'Вудка',
      'name': 'Brain Apex Feeder 3.6м',
      'notes': 'Фідерне вудилище, тест до 90г.',
      'tripsCount': '7 виїздів',
    },
    {
      'category': 'Приманка',
      'name': 'Lucky John Tioga 3.5" Pearl',
      'notes': 'Їстівний силікон для джигу на судака та щуку.',
      'tripsCount': '9 виїздів',
    },
    {
      'category': 'Приманка',
      'name': 'Воблер Rapala X-Rap 10',
      'notes': 'Суспендер для твічингу на глибині 1.2–1.8м.',
      'tripsCount': '5 виїздів',
    },
    {
      'category': 'Наживка',
      'name': 'Helicopter Rig з кукурудзою',
      'notes': 'Монтаж для лову коропа та великого ляща.',
      'tripsCount': '4 виїзди',
    },
    {
      'category': 'Наживка',
      'name': "Черв'як дощовий",
      'notes': 'Універсальна наживка для поплавця та фідера.',
      'tripsCount': '6 виїздів',
    },
  ];

  List<Map<String, String>> get _filteredTackle {
    if (_selectedFilter == 'Усі') return _allTackle;
    return _allTackle
        .where((item) => item['category'] == _selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredTackle;

    return Scaffold(
      backgroundColor: AppColors.backgroundBottom,
      floatingActionButton: AppFab(
        onPressed: () => showTackleFormSheet(context),
        icon: Icons.add,
        heroTag: 'tackle_screen_fab',
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.backgroundTop, AppColors.backgroundBottom],
            stops: [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Кнопка "< Головна"
                InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(8),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.chevron_left,
                          color: AppColors.primaryTeal,
                          size: 20,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Назад',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryTeal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // 1. Шапка: Заголовок "Снасті" + Кнопка "+ Додати снасть"
                _buildHeader(context),
                const SizedBox(height: 20),

                // 2. Фільтри категорій з лічильниками
                _buildCategoryFilters(),
                const SizedBox(height: 18),

                const Divider(color: AppColors.cardBorder, height: 1),
                const SizedBox(height: 20),

                // 3. Заголовок "Мій арсенал [7]"
                Row(
                  children: [
                    const Text(
                      'Мій арсенал',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lightTealBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${items.length}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryTeal,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 4. Список карток снастей
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return TackleCard(
                      category: item['category']!,
                      name: item['name']!,
                      notes: item['notes']!,
                      tripsCount: item['tripsCount']!,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TackleDetailScreen(
                              category: item['category']!,
                              name: item['name']!,
                              notes: item['notes']!,
                              tripsCount: item['tripsCount']!,
                            ),
                          ),
                        );
                      },
                      onEdit: () => showTackleFormSheet(
                        context,
                        isEditing: true,
                        initialCategory: item['category'],
                        initialName: item['name'],
                        initialNotes: item['notes'],
                      ),
                      onDelete: () => showDeleteTackleDialog(context),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Снасті',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Ваше спорядження\nзавжди під рукою',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.syncDotGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Синхронізовано',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryFilters() {
    final List<Map<String, dynamic>> filters = [
      {'label': 'Усі', 'count': 7},
      {'label': 'Вудка', 'count': 2},
      {'label': 'Котушка', 'count': 1},
      {'label': 'Приманка', 'count': 2},
      {'label': 'Наживка', 'count': 2},
      {'label': 'Інше', 'count': null},
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: filters.map((f) {
        final String label = f['label'] as String;
        final int? count = f['count'] as int?;
        final bool isSelected = _selectedFilter == label;

        return InkWell(
          onTap: () => setState(() => _selectedFilter = label),
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
                if (count != null) ...[
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
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
