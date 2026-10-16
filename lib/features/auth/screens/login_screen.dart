import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../main/screens/main_screen.dart';
import '../../../core/widgets/auth_background.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'З поверненням',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Увійдіть, щоб продовжити вести щоденник',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 26),

          // Поле Email
          const AppTextField(
            label: 'Email',
            hintText: 'you@example.com',
            prefixIcon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 18),

          // Поле Пароль
          const AppTextField(
            label: 'Пароль',
            hintText: 'Щонайменше 8 символів',
            prefixIcon: Icons.lock_outline_rounded,
            obscureText: true,
          ),
          const SizedBox(height: 12),

          // Посилання "Забули пароль?" справа
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ForgotPasswordScreen(),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  'Забули пароль?',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTeal,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Кнопка "Увійти >" (відкриває головний екран без бізнес-логіки згідно п. 4.1)
          AppButton(
            text: 'Увійти',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MainScreen()),
              );
            },
          ),
          const SizedBox(height: 22),

          // Нижній підпис "Ще не маєте акаунта? Зареєструватися"
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Ще не маєте акаунта? ',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  );
                },
                child: const Text(
                  'Зареєструватися',
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
