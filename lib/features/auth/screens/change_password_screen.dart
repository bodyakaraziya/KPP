import 'package:flutter/material.dart';
import 'package:fishlog/core/widgets/app_button.dart';

class ChangePasswordScreen extends StatelessWidget {
  final Function(String, String, String) onChangePassword;
  final VoidCallback onNavigateToLogin;

  const ChangePasswordScreen({
    super.key,
    required this.onChangePassword,
    required this.onNavigateToLogin,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController currentPasswordController =
        TextEditingController();
    final TextEditingController newPasswordController =
        TextEditingController();
    final TextEditingController confirmNewPasswordController =
        TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Зміна пароля'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Поточний пароль',
                  hintText: 'Введіть ваш поточний пароль',
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Будь ласка, введіть поточний пароль';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Новий пароль',
                  hintText: 'Введіть новий пароль',
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Будь ласка, введіть новий пароль';
                  }
                  if (value.length < 6) {
                    return 'Пароль повинен містити принаймні 6 символів';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: confirmNewPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Підтвердження нового пароля',
                  hintText: 'Повторіть новий пароль',
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Будь ласка, підтвердьте новий пароль';
                  }
                  if (value != newPasswordController.text) {
                    return 'Паролі не співпадають';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      onChangePassword(
                        currentPasswordController.text,
                        newPasswordController.text,
                        confirmNewPasswordController.text,
                      );
                    }
                  },
                  text: 'Змінити пароль',
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: onNavigateToLogin,
                child: const Text('Повернутися до входу'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}