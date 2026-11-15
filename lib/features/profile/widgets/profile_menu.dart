import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// Випадаюче меню "Додатково" на екрані Профіль.
class ProfileMenu extends StatelessWidget {
  final bool isMenuOpen;
  final VoidCallback onClose;
  final VoidCallback onTackleTap;
  final VoidCallback onStatisticsTap;

  const ProfileMenu({
    super.key,
    required this.isMenuOpen,
    required this.onClose,
    required this.onTackleTap,
    required this.onStatisticsTap,
  });

  @override
  Widget build(BuildContext context) {
    if (!isMenuOpen) return const SizedBox.shrink();

    return Positioned(
      top: 68.0,
      right: 20.0,
      width: 220,
      child: Material(
        elevation: 12,
        shadowColor: Colors.black.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.cardBorder,
              width: 1.2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 14, 16, 8),
                child: Text(
                  'Додатково',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const Divider(color: AppColors.cardBorder, height: 1),
              _buildMenuItem(
                icon: Icons.phishing_rounded,
                label: 'Снасті',
                onTap: () {
                  onClose();
                  onTackleTap();
                },
              ),
              _buildMenuItem(
                icon: Icons.bar_chart_rounded,
                label: 'Статистика',
                onTap: () {
                  onClose();
                  onStatisticsTap();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.textPrimary),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
