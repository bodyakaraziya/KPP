import 'package:flutter/material.dart';

class AppColors {
  // Основні кольори фону
  static const Color backgroundTop = Color(0xFFD6F2EE);
  static const Color backgroundBottom = Color(0xFFF3F8F6);
  static const Color cardBackground = Colors.white;
  static const Color cardBorder = Color(0xFFD5DEDB);

  // Акцентні кольори (Teal / Бірюзовий)
  static const Color primaryTeal = Color(0xFF00676C);
  static const Color lightTealBg = Color(0xFFD0EFEA);

  // Додаткові пастельні кольори (Зелений та Бежевий/Пісочний)
  static const Color lightGreenBg = Color(0xFFDCECD9);
  static const Color accentGreen = Color(0xFF436947);
  static const Color syncDotGreen = Color(0xFF557C55);

  static const Color lightAmberBg = Color(0xFFF5E6CA);
  static const Color accentAmber = Color(0xFF9E6B25);

  // Кольори тексту
  static const Color textPrimary = Color(0xFF1A2C2B);
  static const Color textSecondary = Color(0xFF6B7B7A);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.backgroundBottom,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryTeal,
        primary: AppColors.primaryTeal,
        surface: Colors.white,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: AppColors.lightTealBg,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryTeal,
            );
          }
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primaryTeal, size: 24);
          }
          return const IconThemeData(color: AppColors.textSecondary, size: 24);
        }),
      ),
    );
  }
}
