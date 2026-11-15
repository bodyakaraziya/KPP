import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// Картка зі стовпчастою діаграмою активності виїздів.
class ActivityChartCard extends StatelessWidget {
  final Map<String, dynamic> stats;

  const ActivityChartCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> bars = List<Map<String, dynamic>>.from(
      stats['bars'] as List,
    );
    final int maxVal = stats['maxVal'] as int;
    final List<int> yLabels = List<int>.from(stats['yLabels'] as List);

    const double topValueHeight = 24.0;
    const double maxBarAreaHeight = 110.0;
    const double bottomLabelsHeight = 24.0;

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
                'Активність виїздів',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 11,
                    height: 11,
                    decoration: BoxDecoration(
                      color: AppColors.primaryTeal,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Виїзди',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            stats['chartSubtitle'] as String,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            height: topValueHeight + maxBarAreaHeight + bottomLabelsHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: topValueHeight,
                    bottom: bottomLabelsHeight,
                    right: 10,
                  ),
                  child: SizedBox(
                    height: maxBarAreaHeight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: yLabels.map((val) {
                        return Text(
                          '$val-',
                          style: const TextStyle(
                            fontSize: 11,
                            height: 1.0,
                            color: AppColors.textSecondary,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                Expanded(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: topValueHeight,
                          bottom: bottomLabelsHeight,
                        ),
                        child: SizedBox(
                          height: maxBarAreaHeight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: yLabels.map((_) {
                              return Container(
                                height: 1,
                                color: AppColors.cardBorder.withValues(
                                  alpha: 0.5,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(bars.length, (index) {
                          final bar = bars[index];
                          final int value = bar['value'] as int;
                          final String label = bar['label'] as String;

                          final double rawHeight = maxVal > 0
                              ? (value / maxVal) * maxBarAreaHeight
                              : 0.0;
                          final double barHeight = value == 0
                              ? 4.0
                              : rawHeight.clamp(10.0, maxBarAreaHeight);

                          return Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: 18,
                                  child: Center(
                                    child: Text(
                                      '$value',
                                      style: TextStyle(
                                        fontSize: 11,
                                        height: 1.0,
                                        fontWeight: FontWeight.w700,
                                        color: value > 0
                                            ? AppColors.textPrimary
                                            : AppColors.textSecondary
                                                  .withValues(alpha: 0.6),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOutCubic,
                                  width: bars.length <= 4
                                      ? 42
                                      : bars.length <= 8
                                          ? 30
                                          : 22,
                                  height: barHeight,
                                  decoration: BoxDecoration(
                                    color: value > 0
                                        ? AppColors.primaryTeal
                                        : const Color(0xFFDCE5E3),
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(8),
                                      bottom: Radius.circular(3),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  height: 16,
                                  child: Text(
                                    label.length > 3 ? label.substring(0, 3) : label,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      height: 1.1,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
