import 'package:flutter/material.dart';
import 'package:fishlog/core/widgets/app_button.dart';
import 'package:fishlog/core/widgets/app_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, String> userData;
  final ValueChanged<Map<String, String>> onUpdateProfile;

  const EditProfileScreen({
    super.key,
    required this.userData,
    required this.onUpdateProfile,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // 1. Ініціалізуємо контролери ОДИН РАЗ при створенні екрана
    _nameController = TextEditingController(
      text: widget.userData['name'] ?? '',
    );
    _emailController = TextEditingController(
      text: widget.userData['email'] ?? '',
    );
  }

  @override
  void dispose() {
    // 2. Обов'язково звільняємо пам'ять при закритті екрана
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Редагування профілю')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              AppTextField(
                label: "Ім'я",
                hintText: "Введіть ваше ім'я",
                prefixIcon: Icons.person,
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Будь ласка, введіть ім'я";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Електронна пошта',
                hintText: 'Введіть вашу пошту',
                prefixIcon: Icons.email,
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
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
                  if (_formKey.currentState?.validate() ?? false) {
                    widget.onUpdateProfile({
                      'name': _nameController.text.trim(),
                      'email': _emailController.text.trim(),
                    });
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
