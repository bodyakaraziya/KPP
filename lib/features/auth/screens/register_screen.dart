import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/auth_background.dart';
import '../repositories/auth_repository.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  final AuthRepository? authRepository;

  const RegisterScreen({super.key, this.authRepository});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late final AuthRepository _authRepository;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authRepository = widget.authRepository ?? AuthRepository();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authRepository.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        displayName: _nameController.text.trim(),
      );

      if (!mounted) return;

      // Надсилаємо лист для підтвердження адреси електронної пошти.
      await _authRepository.sendEmailVerification();

      if (!mounted) return;

      showAppSnackBar(
        context,
        message:
            'Лист для підтвердження пошти надіслано на ${_emailController.text.trim()}. Будь ласка, підтвердьте адресу перед входом.',
        isError: false,
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      showAppSnackBar(
        context,
        title: 'Помилка реєстрації',
        message: authErrorMessage(e),
        isError: true,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: Form(
        key: _formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: _isLoading ? null : () => Navigator.pop(context),
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

              const Text(
                'Створіть акаунт',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const Text(
                'Почніть зберігати свої рибальські історії',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),

              AppTextField(
                label: "Ім'я",
                hintText: "Ваше ім'я",
                prefixIcon: Icons.person_outline,
                controller: _nameController,
                inputFormatters: [LengthLimitingTextInputFormatter(20)],
                validator: requiredValidator(fieldName: "ім'я"),
              ),
              const SizedBox(height: 12),

              AppTextField(
                label: 'Email',
                hintText: 'you@example.com',
                prefixIcon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                maxLength: 254,
                validator: emailValidator(),
              ),
              const SizedBox(height: 12),

              AppTextField(
                label: 'Пароль',
                hintText: 'Щонайменше 8 символів',
                prefixIcon: Icons.lock_outline_rounded,
                obscureText: true,
                suffixIcon: Icons.visibility_off,
                controller: _passwordController,
                maxLength: 128,
                validator: passwordValidator(minLength: 8),
              ),
              const SizedBox(height: 12),

              AppTextField(
                label: 'Підтвердження пароля',
                hintText: 'Повторіть пароль',
                prefixIcon: Icons.lock_outline_rounded,
                obscureText: true,
                suffixIcon: Icons.visibility_off,
                controller: _confirmPasswordController,
                maxLength: 128,
                validator: confirmPasswordValidator(() => _passwordController.text),
              ),
              const SizedBox(height: 22),

              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryTeal,
                      ),
                    )
                  : AppButton(
                      text: 'Зареєструватися',
                      onPressed: _handleRegister,
                    ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Вже маєте акаунт? ',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: _isLoading ? null : () => Navigator.pop(context),
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
        ),
    );
  }
}
