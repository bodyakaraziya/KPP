import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_text_field.dart';

/// Картка "Пароль": розгортається у форму зміни пароля з оком-перемикачем.
class PasswordCard extends StatelessWidget {
  final bool isOpen;
  final bool hasPassword;
  final VoidCallback onToggle;
  final VoidCallback onForgotPassword;
  final VoidCallback onChangePassword;
  final TextEditingController currentPasswordCtrl;
  final TextEditingController newPasswordCtrl;
  final TextEditingController confirmPasswordCtrl;

  const PasswordCard({
    super.key,
    required this.isOpen,
    required this.hasPassword,
    required this.onToggle,
    required this.onForgotPassword,
    required this.onChangePassword,
    required this.currentPasswordCtrl,
    required this.newPasswordCtrl,
    required this.confirmPasswordCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Column(
        children: [
          // Заголовок акордеона
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onToggle,
              borderRadius: BorderRadius.circular(22),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.lightTealBg,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.lock_outline_rounded,
                        color: AppColors.primaryTeal,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Пароль',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Оновлено 3 місяці тому',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      isOpen
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (isOpen) ...[
            const Divider(color: AppColors.cardBorder, height: 1),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!hasPassword) ...[
                    const Text(
                      'Для облікового запису без пароля використовуйте '
                      'відновлення паролю через пошту.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],
                  AppTextField(
                    label: 'Поточний пароль',
                    hintText: 'Ваш пароль',
                    prefixIcon: Icons.lock_outline_rounded,
                    obscureText: true,
                    suffixIcon: Icons.visibility_off,
                  ),
                  const SizedBox(height: 14),

                  AppTextField(
                    label: 'Новий пароль',
                    hintText: 'Щонайменше 8 символів',
                    prefixIcon: Icons.lock_outline_rounded,
                    obscureText: true,
                    suffixIcon: Icons.visibility_off,
                  ),
                  const SizedBox(height: 14),

                  AppTextField(
                    label: 'Повторіть пароль',
                    hintText: 'Паролі мають збігатися',
                    prefixIcon: Icons.lock_outline_rounded,
                    obscureText: true,
                    suffixIcon: Icons.visibility_off,
                  ),
                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: onChangePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryTeal,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text(
                        'Оновити пароль',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: onForgotPassword,
                      child: const Text(
                        'Забули пароль?',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryTeal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
