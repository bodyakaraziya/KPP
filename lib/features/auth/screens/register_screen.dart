import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../main/screens/main_screen.dart';
import '../../../core/widgets/auth_background.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Кнопка "< Назад до входу"
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.chevron_left,
                    color: AppColors.primaryTeal,
                    size: 20,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Назад до входу',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryTeal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          const Text(
            'Створіть акаунт',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Почніть зберігати свої рибальські історії',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 22),

          // Поле Ім'я
          const AppTextField(
            label: "Ім'я",
            hintText: "Ваше ім'я",
            prefixIcon: Icons.person_outline,
          ),
          const SizedBox(height: 16),

          // Поле Email
          const AppTextField(
            label: 'Email',
            hintText: 'you@example.com',
            prefixIcon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),

          // Поле Пароль
          const AppTextField(
            label: 'Пароль',
            hintText: 'Щонайменше 8 символів',
            prefixIcon: Icons.lock_outline_rounded,
            obscureText: true,
          ),
          const SizedBox(height: 16),

          // Поле Підтвердження пароля
          const AppTextField(
            label: 'Підтвердження пароля',
            hintText: 'Повторіть пароль',
            prefixIcon: Icons.lock_outline_rounded,
            obscureText: true,
          ),
          const SizedBox(height: 22),

          // Кнопка "Зареєструватися >"
          AppButton(
            text: 'Зареєструватися',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const MainScreen()),
                (route) => false,
              );
            },
          ),
          const SizedBox(height: 20),

          // Нижній рядок "Вже маєте акаунт? Увійти"
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Вже маєте акаунт? ',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text(
                  'Увійти',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTeal,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
