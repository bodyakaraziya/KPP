import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Універсальна функція для показу красивих сповіщень та помилок
void showAppSnackBar(
  BuildContext context, {
  required String message,
  String? title,
  bool isError = true,
}) {
  // Ховаємо попередній SnackBar, якщо він є
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.zero,
      margin: EdgeInsets.fromLTRB(
        16,
        0,
        16,
        16 + MediaQuery.viewPaddingOf(context).bottom,
      ),
      duration: Duration(milliseconds: isError ? 4000 : 2500),
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          // М'який пастельний червоний для помилки або світло-бірюзовий для успіху
          color: isError ? const Color(0xFFFDEDED) : const Color(0xFFEAF5F2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isError
                ? const Color(0xFFF5C2C2)
                : AppColors.primaryTeal.withValues(alpha: 0.3),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Кругла іконка
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isError
                    ? const Color(0xFFFAD2D2)
                    : AppColors.lightTealBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isError ? Icons.priority_high_rounded : Icons.check_rounded,
                color: isError
                    ? const Color(0xFFD32F2F)
                    : AppColors.primaryTeal,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),

            // Текст помилки / повідомлення
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null) ...[
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isError
                            ? const Color(0xFFB71C1C)
                            : AppColors.primaryTeal,
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isError
                          ? const Color(0xFF5F2120)
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
