import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// Банер "Очікується підтвердження пошти", що показується після зміни Email.
class EmailConfirmationBanner extends StatelessWidget {
  final String pendingEmail;

  const EmailConfirmationBanner({super.key, required this.pendingEmail});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightTealBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Очікується підтвердження пошти',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Перейдіть за посиланням у листі, надісланому на $pendingEmail.',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
