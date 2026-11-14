import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_fab.dart';
import '../../../core/widgets/tackle_card.dart';
import '../providers/tackle_provider.dart';
import 'tackle_detail_screen.dart';

class TackleScreen extends StatelessWidget {
  const TackleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Снасті беруться з TackleProvider (лаба №5, завдання 3.3–3.4).
    final provider = context.watch<TackleProvider>();
    final tackles = provider.tackles;

    return Scaffold(
      backgroundColor: AppColors.backgroundBottom,
      floatingActionButton: AppFab(
        onPressed: () => showTackleFormSheet(
          context,
          onSave: (item) => context.read<TackleProvider>().addTackle(item),
        ),
        icon: Icons.add,
        heroTag: 'tackle_screen_fab',
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
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
                _buildCategoryFilters(context, provider),
                const SizedBox(height: 18),

                const Divider(color: AppColors.cardBorder, height: 1),
                const SizedBox(height: 20),

                // 3. Заголовок "Мій арсенал [N]"
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
                        '${tackles.length}',
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

                // 4. Список карток снастей (даних з TackleProvider)
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: tackles.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final t = tackles[index];
                    return TackleCard(
                      category: t.category,
                      name: t.name,
                      notes: t.notes,
                      tripsCount: '${t.tripsCount} виїздів',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TackleDetailScreen(
                              category: t.category,
                              name: t.name,
                              notes: t.notes,
                              tripsCount: '${t.tripsCount} виїздів',
                            ),
                          ),
                        );
                      },
                      onEdit: () => showTackleFormSheet(
                        context,
                        isEditing: true,
                        id: t.id,
                        initialTripsCount: t.tripsCount,
                        onSave: (updated) =>
                            context.read<TackleProvider>().updateTackle(t.id, updated),
                        initialCategory: t.category,
                        initialName: t.name,
                        initialNotes: t.notes,
                      ),
                      onDelete: () => showDeleteTackleDialog(
                        context,
                        onDelete: () =>
                            context.read<TackleProvider>().deleteTackle(t.id),
                      ),
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

  Widget _buildCategoryFilters(BuildContext context, TackleProvider provider) {
    final labels = ['Усі', ...provider.categories];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: labels.map((label) {
        final bool isSelected = provider.filterCategory == label;
        final int count = label == 'Усі'
            ? provider.tackles.length
            : provider.tackles.where((t) => t.category == label).length;

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
