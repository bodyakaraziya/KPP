import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/models/tackle.dart';
import '../../../core/widgets/tackle_card.dart';
import '../../tackle/providers/tackle_provider.dart';

/// Картка "Мій арсенал" на екрані Головна.
/// Показує реальні останні додані снасті з TackleProvider замість захардкоджених.
class ArsenalCard extends StatelessWidget {
  final VoidCallback onTackleTap;

  const ArsenalCard({super.key, required this.onTackleTap});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TackleProvider>();
    final tackles = provider.allTackles;
    // Останні додані снасті (найсвіжіші першими)
    final recent = tackles.reversed.take(2).toList();

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
                'Мій арсенал',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Снасті під рукою',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 18),

          if (recent.isEmpty) ...[
            // Порожній стан — снастей ще немає
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F8F6),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.cardBorder, width: 1.2),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.set_meal_outlined,
                    color: AppColors.primaryTeal,
                    size: 32,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Снастей ще немає',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryTeal,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Додайте першу снасть в розділі «Снасті», і вона тут з\'явиться.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            ...recent.map((t) => _buildTackleItem(t)),
          ],
          SizedBox(height: recent.isEmpty ? 30 : 18),

          SizedBox(
            width: double.infinity,
            height: 44,
            child: TextButton(
              onPressed: onTackleTap,
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
                    'Весь арсенал',
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

  Widget _buildTackleItem(Tackle t) {
    final style = TackleStyle.fromCategory(t.category);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: style.bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(style.icon, color: style.accentColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.category.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  t.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
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
