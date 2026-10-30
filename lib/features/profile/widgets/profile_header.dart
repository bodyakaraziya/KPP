import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// Шапка профілю: заголовок + кнопка розгортання меню.
class ProfileHeader extends StatelessWidget {
  final VoidCallback onMenuTap;
  final bool isMenuOpen;

  const ProfileHeader({
    super.key,
    required this.onMenuTap,
    required this.isMenuOpen,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70.0,
      child: Stack(
        children: [
          // Заголовок
          Positioned(
            left: 0,
            right: 60, // місце під кнопку меню
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Профіль',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Налаштування та особисті дані',
                  style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          // Кнопка меню
          Positioned(
            right: 0,
            child: GestureDetector(
              onTap: onMenuTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.cardBorder, width: 1.2),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return RotationTransition(
                      turns: Tween<double>(begin: 0.0, end: 0.5).animate(animation),
                      child: child,
                    );
                  },
                  child: isMenuOpen
                      ? const Icon(
                          Icons.clear,
                          color: AppColors.textPrimary,
                          size: 22,
                        )
                      : const Icon(
                          Icons.menu_rounded,
                          color: AppColors.textPrimary,
                          size: 22,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
