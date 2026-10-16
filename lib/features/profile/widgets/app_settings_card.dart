import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// Картка "Налаштування застосунку": тема та мова.
class AppSettingsCard extends StatelessWidget {
  final bool isDarkTheme;
  final String selectedLang;
  final VoidCallback onThemeLight;
  final VoidCallback onThemeDark;
  final ValueChanged<String> onLangChanged;

  const AppSettingsCard({
    super.key,
    required this.isDarkTheme,
    required this.selectedLang,
    required this.onThemeLight,
    required this.onThemeDark,
    required this.onLangChanged,
  });

  Widget _buildThemeOptionCard({
    required bool isLightCard,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.lightTealBg : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.primaryTeal : AppColors.cardBorder,
            width: isSelected ? 1.6 : 1.2,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isLightCard
                    ? const Color(0xFFEAF2F0)
                    : const Color(0xFF152627),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: isLightCard
                          ? const Color(0xFFC5D5D2)
                          : const Color(0xFF2B4243),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: isLightCard
                          ? const Color(0xFFC5D5D2)
                          : const Color(0xFF2B4243),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Icon(
              isLightCard
                  ? Icons.wb_sunny_outlined
                  : Icons.nightlight_round_outlined,
              size: 18,
              color: isSelected
                  ? AppColors.primaryTeal
                  : AppColors.textSecondary,
            ),
            const SizedBox(height: 6),
            Text(
              isLightCard ? 'Світла' : 'Темна',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? AppColors.primaryTeal
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLangSegment(String lang) {
    final bool isSelected = selectedLang == lang;
    return GestureDetector(
      onTap: () => onLangChanged(lang),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Text(
          lang,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: isSelected ? AppColors.primaryTeal : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.wb_sunny_outlined,
                color: AppColors.textPrimary,
                size: 20,
              ),
              SizedBox(width: 10),
              Text(
                'Налаштування застосунку',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          const Text(
            'Тема оформлення',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _buildThemeOptionCard(
                  isLightCard: true,
                  isSelected: !isDarkTheme,
                  onTap: onThemeLight,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildThemeOptionCard(
                  isLightCard: false,
                  isSelected: isDarkTheme,
                  onTap: onThemeDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(color: Color(0xFFEEF3F1), height: 1),
          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.language, color: AppColors.primaryTeal, size: 22),
                  SizedBox(width: 12),
                  Text(
                    'Мова',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9EFED),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _buildLangSegment('УКР'),
                    _buildLangSegment('ENG'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
