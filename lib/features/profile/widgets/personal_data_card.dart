import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/validators.dart';

class PhoneMaskFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (digits.isEmpty) {
      return const TextEditingValue(
        text: '+380 ',
        selection: TextSelection.collapsed(offset: 5),
      );
    }

    String local = digits;
    if (local.startsWith('380')) {
      local = local.substring(3);
    }

    if (local.length > 9) {
      return oldValue;
    }

    final groups = <String>[];
    int i = 0;
    for (final len in [2, 3, 2, 2]) {
      if (i >= local.length) break;
      final end = local.length < i + len ? local.length : i + len;
      groups.add(local.substring(i, end));
      i = end;
    }
    if (i < local.length) {
      groups.add(local.substring(i));
    }

    final formatted = '+380 ${groups.join(' ')}';

    // Розрахунок позиції курсора
    int selectionIndex = formatted.length;
    if (newValue.selection.end < newValue.text.length) {
      selectionIndex = newValue.selection.end;
      if (selectionIndex > formatted.length) {
        selectionIndex = formatted.length;
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

class PersonalDataCard extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final bool isExpanded;
  final bool isEditing;
  final VoidCallback onExpandToggle;
  final VoidCallback onEditTap;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final TextEditingController firstNameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController phoneCtrl;

  const PersonalDataCard({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.isExpanded,
    required this.isEditing,
    required this.onExpandToggle,
    required this.onEditTap,
    required this.onSave,
    required this.onCancel,
    required this.firstNameCtrl,
    required this.emailCtrl,
    required this.phoneCtrl,
  });

  Widget _buildInfoRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required IconData prefixIcon,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    FormFieldValidator<String>? validator,
    List<TextInputFormatter>? formatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: formatters,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
        prefixIcon: Icon(prefixIcon, color: AppColors.textSecondary, size: 20),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.cardBorder, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.primaryTeal,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        errorStyle: const TextStyle(fontSize: 12, color: Colors.red),
        errorMaxLines: 1,
      ),
    );
  }

  Widget _buildReadOnlyView() {
    return Column(
      children: [
        _buildInfoRow(Icons.person_outline, name),
        const Divider(color: Color(0xFFEEF3F1), height: 24),
        _buildInfoRow(Icons.mail_outline, email),
        const Divider(color: Color(0xFFEEF3F1), height: 24),
        _buildInfoRow(
          Icons.phone_outlined,
          phone.isNotEmpty ? phone : 'Не вказано',
        ),
        const Divider(color: Color(0xFFEEF3F1), height: 24),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: TextButton.icon(
            onPressed: onEditTap,
            style: TextButton.styleFrom(
              backgroundColor: AppColors.lightTealBg,
              foregroundColor: AppColors.primaryTeal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text(
              'Редагувати профіль',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel("Ім'я"),
        _buildInputField(
          controller: firstNameCtrl,
          prefixIcon: Icons.person_outline,
          hintText: 'Ваше ім\'я',
        ),
        const SizedBox(height: 14),
        _buildFieldLabel('Email'),
        _buildInputField(
          controller: emailCtrl,
          prefixIcon: Icons.mail_outline,
          hintText: 'you@example.com',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 14),
        _buildFieldLabel('Телефон'),
        _buildInputField(
          controller: phoneCtrl,
          prefixIcon: Icons.phone_outlined,
          hintText: '+380 __ ___ __ __',
          keyboardType: TextInputType.phone,
          validator: phoneValidator(),
          formatters: [PhoneMaskFormatter()],
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: onSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryTeal,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text(
                    'Зберегти',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 48,
              child: TextButton(
                onPressed: onCancel,
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.lightTealBg,
                  foregroundColor: AppColors.primaryTeal,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Скасувати',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onExpandToggle,
              borderRadius: BorderRadius.circular(22),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.lightTealBg,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        color: AppColors.primaryTeal,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Особисті дані',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isEditing
                                ? 'Редагування активне'
                                : '$name · $email',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isExpanded) ...[
            const Divider(color: AppColors.cardBorder, height: 1),
            Padding(
              padding: const EdgeInsets.all(18),
              child: isEditing ? _buildEditForm() : _buildReadOnlyView(),
            ),
          ],
        ],
      ),
    );
  }
}
