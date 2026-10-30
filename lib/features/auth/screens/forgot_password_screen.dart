import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/auth_background.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/validators.dart';
import '../repositories/auth_repository.dart';
import 'reset_password_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final AuthRepository? authRepository;

  const ForgotPasswordScreen({super.key, this.authRepository});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  late final AuthRepository _authRepository;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authRepository = widget.authRepository ?? AuthRepository();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      if (!mounted) return;

      showAppSnackBar(
        context,
        title: 'Помилка',
        message: 'Будь ласка, виправте помилки у формі',
        isError: true,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authRepository.sendPasswordResetEmail(
        _emailController.text.trim(),
      );

      if (!mounted) return;

      showAppSnackBar(
        context,
        message:
            'Посилання для скидання пароля надіслано на вашу пошту. Відкрийте лист і перейдіть за посиланням — воно відкриє додаток.',
        isError: false,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(authRepository: _authRepository),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      showAppSnackBar(
        context,
        title: 'Помилка відновлення пароля',
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
            const SizedBox(height: 12),

            const Text(
              'Відновлення пароля',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Введіть вашу електронну пошту, і ми надішлемо посилання, яке відкриє додаток для скидання пароля',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 24),

            AppTextField(
              label: 'Email',
              hintText: 'you@example.com',
              prefixIcon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              validator: emailValidator(),
            ),
            const SizedBox(height: 24),

            _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryTeal,
                    ),
                  )
                : AppButton(
                    text: 'Надіслати посилання',
                    onPressed: _handleResetPassword,
                  ),
          ],
        ),
      ),
    );
  }
}
