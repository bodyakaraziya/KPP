import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  final Function(String currentPwd, String newPwd, String confirmPwd)?
  onChangePassword;
  final VoidCallback? onNavigateToLogin;

  const ChangePasswordScreen({
    super.key,
    this.onChangePassword,
    this.onNavigateToLogin,
  });

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late final TextEditingController _currentPasswordController;
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmNewPasswordController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmNewPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      if (widget.onChangePassword != null) {
        widget.onChangePassword!(
          _currentPasswordController.text,
          _newPasswordController.text,
          _confirmNewPasswordController.text,
        );
      } else {
        // Стандартна дія, якщо callback не передано
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Пароль успішно змінено!'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBottom,
      appBar: AppBar(
        title: const Text('Зміна пароля'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 8),
                AppTextField(
                  label: 'Поточний пароль',
                  hintText: 'Введіть ваш поточний пароль',
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: true,
                  controller: _currentPasswordController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Будь ласка, введіть поточний пароль';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Новий пароль',
                  hintText: 'Щонайменше 8 символів',
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: true,
                  controller: _newPasswordController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Будь ласка, введіть новий пароль';
                    }
                    if (value.length < 8) {
                      return 'Пароль повинен містити принаймні 8 символів';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Підтвердження нового пароля',
                  hintText: 'Повторіть новий пароль',
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: true,
                  controller: _confirmNewPasswordController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Будь ласка, підтвердьте новий пароль';
                    }
                    if (value != _newPasswordController.text) {
                      return 'Паролі не співпадають';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),
                AppButton(text: 'Змінити пароль', onPressed: _submitForm),
                const SizedBox(height: 16),
                TextButton(
                  onPressed:
                      widget.onNavigateToLogin ?? () => Navigator.pop(context),
                  child: const Text(
                    'Скасувати',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
