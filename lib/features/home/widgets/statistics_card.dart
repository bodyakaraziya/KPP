import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../trips/providers/trips_provider.dart';
import '../../statistics/models/statistics_data.dart';

/// Картка "Статистика сезону" на екрані Головна.
/// Показує реальну узагальнену статистику з TripsProvider за весь час.
class StatisticsCard extends StatelessWidget {
  final VoidCallback onStatisticsTap;

  const StatisticsCard({super.key, required this.onStatisticsTap});

  @override
  Widget build(BuildContext context) {
    final trips = context.watch<TripsProvider>().trips;
    final stats = computeStats(
      trips: trips,
      period: StatPeriod.allTime,
    );
    final records = stats['records'] as List;
    final topRecord = records.isNotEmpty ? records.first as Map<String, dynamic> : null;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Статистика сезону',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Ваші досягнення та динаміка улову',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildStatMiniBox(
                  icon: Icons.calendar_today_outlined,
                  iconBgColor: AppColors.lightTealBg,
                  iconColor: AppColors.primaryTeal,
                  label: 'ВИЇЗДІВ ЗА ВЕСЬ ЧАС',
                  value: stats['tripsCount'] as String,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatMiniBox(
                  icon: Icons.set_meal_outlined,
                  iconBgColor: AppColors.lightGreenBg,
                  iconColor: AppColors.accentGreen,
                  label: 'ЗАГАЛЬНИЙ УЛОВ',
                  value: stats['totalWeight'] as String,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.lightAmberBg.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.lightAmberBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.emoji_events_outlined,
                    color: AppColors.accentAmber,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'НАЙКРАЩИЙ ТРОФЕЙ',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                          letterSpacing: 0.4,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        topRecord != null
                            ? '${topRecord['name']} · ${topRecord['spot']}'
                            : 'Немає даних',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  topRecord != null ? topRecord['weight'] as String : '—',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.accentAmber,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 44,
            child: TextButton(
              onPressed: onStatisticsTap,
              style: TextButton.styleFrom(
                backgroundColor: AppColors.lightTealBg,
                foregroundColor: AppColors.primaryTeal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Детальна статистика',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.chevron_right, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatMiniBox({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    height: 1.1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
