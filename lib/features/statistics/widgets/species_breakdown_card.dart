import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// Картка "Рекорди за видами" із прогрес-барами найвагомих трофейів.
class SpeciesBreakdownCard extends StatelessWidget {
  final Map<String, dynamic> stats;

  const SpeciesBreakdownCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> records = List<Map<String, dynamic>>.from(
      stats['records'] as List,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Рекорди за видами',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Icon(
                Icons.emoji_events_outlined,
                color: AppColors.primaryTeal.withValues(alpha: 0.8),
                size: 22,
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Найвагоміші трофеї (особистий рекорд)',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 18),
          ...records.asMap().entries.map((entry) {
            final int index = entry.key;
            final Map<String, dynamic> item = entry.value;
            final bool isTopRecord = index == 0;

            return Padding(
              padding: EdgeInsets.only(
                bottom: index == records.length - 1 ? 0 : 16,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              item['name'] as String,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                '• ${item['spot']}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: isTopRecord
                              ? AppColors.primaryTeal.withValues(alpha: 0.12)
                              : const Color(0xFFF3F7F6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item['weight'] as String,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: isTopRecord
                                ? AppColors.primaryTeal
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(
                        begin: 0.0,
                        end: item['share'] as double,
                      ),
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, _) {
                        return LinearProgressIndicator(
                          value: value,
                          minHeight: 8,
                          backgroundColor: const Color(0xFFE9EFED),
                          color: isTopRecord
                              ? AppColors.primaryTeal
                              : AppColors.primaryTeal.withValues(alpha: 0.65),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
