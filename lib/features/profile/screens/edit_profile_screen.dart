import 'package:flutter/material.dart';
import 'package:fishlog/core/widgets/app_button.dart';
import 'package:fishlog/core/widgets/app_text_field.dart';

class EditProfileScreen extends StatelessWidget {
  final Map<String, String> userData;
  final ValueChanged<Map<String, String>> onUpdateProfile;

  const EditProfileScreen({
    super.key,
    required this.userData,
    required this.onUpdateProfile,
  }) : super();

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: userData['name'] ?? '');
    final TextEditingController emailController =
        TextEditingController(text: userData['email'] ?? '');
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Редагування профілю'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              AppTextField(
                label: 'Ім\'я',
                hintText: 'Введіть ваше ім\'я',
                prefixIcon: Icons.person,
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Будь ласка, введіть ім\'я';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Електронна пошта',
                hintText: 'Введіть вашу пошту',
                prefixIcon: Icons.email,
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Будь ласка, введіть пошту';
                  }
                  if (!value.contains('@')) {
                    return 'Будь ласка, введіть коректну пошту';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              AppButton(
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    onUpdateProfile({
                      'name': nameController.text,
                      'email': emailController.text,
                    });
                    // After updating, we can go back to the profile screen.
                    Navigator.of(context).pop();
                  }
                },
                text: 'Зберегти',
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Скасувати'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}