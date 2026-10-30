import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';

/// Нижня панель (bottom sheet) для скидання паролю: лише поле Email.
class ForgotPasswordBottomSheet extends StatefulWidget {
  final String initialEmail;
  final ValueChanged<String> onSend;

  const ForgotPasswordBottomSheet({
    super.key,
    required this.initialEmail,
    required this.onSend,
  });

  @override
  State<ForgotPasswordBottomSheet> createState() =>
      _ForgotPasswordBottomSheetState();
}

class _ForgotPasswordBottomSheetState
    extends State<ForgotPasswordBottomSheet> {
  late TextEditingController _emailCtrl;

  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  void _handleSend(BuildContext context) {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty || !_emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Введіть коректну електронну пошту'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    widget.onSend(email);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Сірий індикатор зверху (drag handle)
          const Center(
            child: SizedBox(
              width: 44,
              height: 4,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.cardBorder,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),

          const Text(
            'Скидання паролю',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Введіть свою електронну пошту, і ми надішлемо посилання для скидання паролю',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),

          AppTextField(
            label: 'Email',
            hintText: 'you@example.com',
            prefixIcon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
            controller: _emailCtrl,
          ),
          const SizedBox(height: 22),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: AppButton(
              text: 'Надіслати посилання',
              onPressed: () => _handleSend(context),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Скасувати',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTeal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Показує панель скидання паролю знизу екрана.
Future<void> showForgotPasswordBottomSheet({
  required BuildContext context,
  required String initialEmail,
  required ValueChanged<String> onSend,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    builder: (ctx) => ForgotPasswordBottomSheet(
      initialEmail: initialEmail,
      onSend: onSend,
    ),
  );
}
