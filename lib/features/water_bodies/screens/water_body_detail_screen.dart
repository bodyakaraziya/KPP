import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/water_body_card.dart';
import '../providers/water_bodies_provider.dart';

/// Детальний перегляд однієї водойми з можливістю редагування та видалення.
class WaterBodyDetailScreen extends StatelessWidget {
  final String id;

  const WaterBodyDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WaterBodiesProvider>();
    final matches = provider.allWaterBodies.where((w) => w.id == id).toList();
    final body = matches.isEmpty ? null : matches.first;
    if (body == null) {
      // Водойму видалено — повертаємося до списку.
      WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.pop(context));
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundBottom,
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
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                          'До списку водойм',
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
                const SizedBox(height: 12),

                // Фото водойми
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(
                    body.imageUrl,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 220,
                      width: double.infinity,
                      color: Colors.grey[300],
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.image,
                        size: 28,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Назва + кнопки Редагувати/Видалити
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            body.type.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryTeal,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            body.name,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton.filledTonal(
                          onPressed: () => showWaterBodyFormSheet(
                            context,
                            isEditing: true,
                            id: id,
                            initialTripsCount: body.tripsCount,
                            onSave: (updated) =>
                                context
                                    .read<WaterBodiesProvider>()
                                    .updateWaterBody(id, updated),
                            initialName: body.name,
                            initialType: body.type,
                            initialLocation: body.location,
                            initialNotes: body.notes,
                            initialImageUrl: body.imageUrl,
                          ),
                          icon: const Icon(Icons.edit_outlined),
                        ),
                        const SizedBox(width: 8),
                        IconButton.filledTonal(
                          onPressed: () => showDeleteWaterBodyDialog(
                            context,
                            onDelete: () {
                              context
                                  .read<WaterBodiesProvider>()
                                  .deleteWaterBody(id);
                              Navigator.pop(context);
                            },
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFFFCEEEE),
                            foregroundColor: const Color(0xFFB3261E),
                          ),
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Картка з деталями локації та нотатками
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.cardBorder, width: 1.2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.map_outlined,
                            color: AppColors.primaryTeal,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              body.location,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Divider(color: AppColors.cardBorder, height: 1),
                      ),
                      const Text(
                        'Нотатки про місце',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        body.notes,
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.textPrimary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
