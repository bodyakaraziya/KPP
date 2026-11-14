import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_fab.dart';
import '../../../core/widgets/water_body_card.dart';
import '../providers/water_bodies_provider.dart';
import 'water_body_detail_screen.dart';

class WaterBodiesScreen extends StatelessWidget {
  const WaterBodiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Водойми беруться з WaterBodiesProvider (лаба №5, завдання 3.3–3.4).
    final provider = context.watch<WaterBodiesProvider>();
    final waterBodies = provider.waterBodies;

    final bool canPop = Navigator.canPop(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundBottom,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.backgroundTop, AppColors.backgroundBottom],
            stops: [0.0, 0.35],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (canPop) ...[
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(8),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
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
                ],

                // Шапка
                _buildHeader(context),
                const SizedBox(height: 16),

                // Фільтр за типом водойми
                _buildTypeFilter(context, provider),
                const SizedBox(height: 20),

                // Лічильник записів
                Text(
                  '${waterBodies.length} записів',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),

                // Список карток водойм (даних з WaterBodiesProvider)
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: waterBodies.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final wb = waterBodies[index];
                    return WaterBodyCard(
                      imageUrl: wb.imageUrl,
                      type: wb.type,
                      name: wb.name,
                      subtitle: '${wb.location} · ${wb.tripsCount} виїздів',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WaterBodyDetailScreen(
                              name: wb.name,
                              type: wb.type,
                              location: wb.location,
                              notes: wb.notes,
                              imageUrl: wb.imageUrl,
                            ),
                          ),
                        );
                      },
                      onEdit: () => showWaterBodyFormSheet(
                        context,
                        isEditing: true,
                        id: wb.id,
                        initialTripsCount: wb.tripsCount,
                        onSave: (updated) =>
                            context.read<WaterBodiesProvider>().updateWaterBody(wb.id, updated),
                        initialName: wb.name,
                        initialType: wb.type,
                        initialLocation: wb.location,
                        initialNotes: wb.notes,
                        initialImageUrl: wb.imageUrl,
                      ),
                      onDelete: () => showDeleteWaterBodyDialog(
                        context,
                        onDelete: () =>
                            context.read<WaterBodiesProvider>().deleteWaterBody(wb.id),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: AppFab(
        heroTag: 'water_bodies_screen_fab',
        onPressed: () => showWaterBodyFormSheet(
          context,
          onSave: (body) =>
              context.read<WaterBodiesProvider>().addWaterBody(body),
        ),
        icon: Icons.add,
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
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
                'Водойми',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Місця, куди хочеться\nповертатися',
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

  Widget _buildTypeFilter(BuildContext context, WaterBodiesProvider provider) {
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
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cardBorder, width: 1.2),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: provider.filterType ?? 'Усі типи',
              isExpanded: true,
              items: ['Усі типи', ...provider.types]
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      ))
                  .toList(),
              onChanged: (val) {
                provider.setFilterType(val == 'Усі типи' ? null : val);
              },
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
