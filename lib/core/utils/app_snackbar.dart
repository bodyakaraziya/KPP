import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Активний запис сповіщення у Overlay (щоб сповіщення не множилося).
OverlayEntry? _activeToastEntry;

/// Прибирає попереднє сповіщення, якщо воно ще показується.
void _dismissCurrentToast() {
  _activeToastEntry?.remove();
  _activeToastEntry = null;
}

/// Універсальна функція для показу сповіщень (попередження, помилки, успіх).
///
/// Повідомлення показується поверх всього вмісту екрана (через Overlay),
/// трохи вище кнопок навігації, і не перекривається ними.
void showAppSnackBar(
  BuildContext context, {
  required String message,
  String? title,
  bool isError = true,
}) {
  _dismissCurrentToast();

  final bottomPadding = MediaQuery.viewPaddingOf(context).bottom;
  // Відступ знизу: панель навігації (~70 px) + зазор, щоб не перекривати її
  final bottomMargin = 80.0 + bottomPadding;

  _activeToastEntry = OverlayEntry(
    builder: (_) => Positioned(
      left: 16,
      right: 16,
      bottom: bottomMargin,
      child: Material(
        color: Colors.transparent,
        child: _ToastCard(
          message: message,
          title: title,
          isError: isError,
          onDismiss: _dismissCurrentToast,
        ),
      ),
    ),
  );

  Overlay.of(context).insert(_activeToastEntry!);

  final displayDuration = isError
      ? const Duration(milliseconds: 4000)
      : const Duration(milliseconds: 2500);

  Future.delayed(displayDuration, () {
    // Видаляємо лише те сповіщення, яке ще поточне (ще не заміщене новим).
    if (_activeToastEntry != null) {
      _activeToastEntry!.remove();
      _activeToastEntry = null;
    }
  });
}

class _ToastCard extends StatelessWidget {
  const _ToastCard({
    required this.message,
    this.title,
    required this.isError,
    required this.onDismiss,
  });

  final String message;
  final String? title;
  final bool isError;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onDismiss,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
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
                        title!,
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
}
