import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/auth_background.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/validators.dart';
import '../repositories/auth_repository.dart';

class ResetPasswordScreen extends StatefulWidget {
  final AuthRepository? authRepository;
  final String? oobCode;

  const ResetPasswordScreen({super.key, this.authRepository, this.oobCode});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oobCodeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late final AuthRepository _authRepository;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authRepository = widget.authRepository ?? AuthRepository();
    if (widget.oobCode != null && widget.oobCode!.isNotEmpty) {
      _oobCodeController.text = widget.oobCode!;
    }
  }

  @override
  void dispose() {
    _oobCodeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      await _authRepository.confirmPasswordReset(
        oobCode: _oobCodeController.text.trim(),
        newPassword: _passwordController.text,
      );

      if (!mounted) return;

      showAppSnackBar(
        context,
        title: 'Успіх',
        message: 'Пароль успішно змінено. Тепер можна увійти.',
        isError: false,
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      showAppSnackBar(
        context,
        title: 'Помилка скидання пароля',
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
                      'Назад',
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
              'Скидання паролю',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Введіть код із листа та задайте новий пароль',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 22),
            AppTextField(
              label: 'Код із листа',
              hintText: 'Введіть код з листа про скидання паролю',
              prefixIcon: Icons.vpn_key,
              controller: _oobCodeController,
              validator: requiredValidator(fieldName: 'код із листа'),
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Новий пароль',
              hintText: 'Щонайменше 8 символів',
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: true,
              suffixIcon: Icons.visibility_off,
              controller: _passwordController,
              validator: passwordValidator(minLength: 8),
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Підтвердження пароля',
              hintText: 'Повторіть новий пароль',
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: true,
              suffixIcon: Icons.visibility_off,
              controller: _confirmPasswordController,
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
                    text: 'Змінити пароль',
                    onPressed: _handleResetPassword,
                  ),
          ],
        ),
      ),
    );
  }
}
