import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Діалогове вікно підтвердження пароля перед зміною Email.
/// Використовується на екрані Профіль.
class PasswordConfirmationDialog extends StatefulWidget {
  const PasswordConfirmationDialog({super.key});

  @override
  State<PasswordConfirmationDialog> createState() =>
      _PasswordConfirmationDialogState();
}

class _PasswordConfirmationDialogState
    extends State<PasswordConfirmationDialog> {
  late final TextEditingController _passwordCtrl;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _passwordCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final password = _passwordCtrl.text.trim();
    if (password.isNotEmpty) {
      Navigator.pop(context, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Підтвердіть зміну Email'),
      content: TextField(
        controller: _passwordCtrl,
        autofocus: true,
        obscureText: _obscurePassword,
        inputFormatters: [LengthLimitingTextInputFormatter(128)],
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          labelText: 'Пароль від акаунта',
          hintText: 'Введіть поточний пароль',
          suffixIcon: Transform.translate(
            offset: const Offset(0, 7),
            child: IconButton(
              tooltip: _obscurePassword
                  ? 'Показати пароль'
                  : 'Приховати пароль',
              iconSize: 20,
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
            ),
          ),
        ),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Скасувати'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Підтвердити')),
      ],
    );
  }
}
