import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_fab.dart';
import '../../../core/widgets/tackle_card.dart';
import '../../trips/widgets/trip_form_helpers.dart';
import '../providers/tackle_provider.dart';
import '../widgets/tackle_category_filters.dart';

class TackleScreen extends StatefulWidget {
  const TackleScreen({super.key});

  @override
  State<TackleScreen> createState() => _TackleScreenState();
}

class _TackleScreenState extends State<TackleScreen> {
  late final TextEditingController _searchCtrl;

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

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
                TackleCategoryFilters(provider: provider),
                const SizedBox(height: 18),

                // 3. Пошук снасті за назвою
                TripFieldLabel(label: 'Пошук снасті'),
                TripInputField(
                  controller: _searchCtrl,
                  hintText: 'Назва або модель снасті',
                  onChanged: (val) =>
                      context.read<TackleProvider>().setSearchQuery(val),
                ),
                const SizedBox(height: 20),

                const Divider(color: AppColors.cardBorder, height: 1),
                const SizedBox(height: 20),

                // 4. Заголовок "Мій арсенал [N]"
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

                // 5. Список карток снастей (даних з TackleProvider)
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: tackles.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final t = tackles[index];
                    return TackleCard(
                      category: t.category,
                      name: t.name,
                      notes: t.notes,
                      tripsCount: '${t.tripsCount} виїздів',
                      onTap: () => showTackleFormSheet(
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
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
              'Ваше спорядження завжди під рукою',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.35,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
