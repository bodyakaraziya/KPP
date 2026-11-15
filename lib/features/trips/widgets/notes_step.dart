import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_theme.dart';
import 'trip_form_helpers.dart';

/// Крок 4: Нотатки (текстове поле з лімітом 500 символів).
class NotesStep extends StatelessWidget {
  final TextEditingController notesCtrl;

  const NotesStep({super.key, required this.notesCtrl});

  @override
  Widget build(BuildContext context) {
    return TripSectionCard(
      stepNumber: '5',
      title: 'Нотатки',
      child: TextFormField(
        controller: notesCtrl,
        maxLines: 4,
        inputFormatters: [LengthLimitingTextInputFormatter(500)],
        decoration: InputDecoration(
          hintText: "Де клювало, на що, що варто пам'ятати наступного разу...",
          hintStyle: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: AppColors.cardBorder,
              width: 1.2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: AppColors.primaryTeal,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
