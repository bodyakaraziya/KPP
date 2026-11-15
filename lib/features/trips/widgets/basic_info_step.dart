import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/app_filter_dropdown.dart';
import 'trip_form_helpers.dart';

/// Крок 1: Основна інформація (водойма, дата, час).
class BasicInfoStep extends StatelessWidget {
  final String selectedWaterBody;
  final List<String> waterBodyNames;
  final ValueChanged<String> onWaterBodyChanged;
  final TextEditingController dateCtrl;
  final TextEditingController startTimeCtrl;
  final TextEditingController endTimeCtrl;
  final String durationText;
  final VoidCallback onAddWaterBody;

  const BasicInfoStep({
    super.key,
    required this.selectedWaterBody,
    required this.waterBodyNames,
    required this.onWaterBodyChanged,
    required this.dateCtrl,
    required this.startTimeCtrl,
    required this.endTimeCtrl,
    required this.durationText,
    required this.onAddWaterBody,
  });

  /// Відкриває календар і записує дату у контролер у форматі ДД.ММ.РРРР.
  /// Нельзя обрати дату пізнішу за сьогоднішню.
  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && context.mounted) {
      dateCtrl.text =
          '${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}';
    }
  }

  /// Спробує розпарсити дату у форматі ДД.ММ.РРРР.
  DateTime? _tryParseDate(String text) {
    try {
      final parts = text.trim().split('.');
      if (parts.length == 3) {
        return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
      }
    } catch (_) {}
    return null;
  }

  /// Відкриває стандартний вибір часу і записує результат у контролер.
  /// Час не може бути пізнішим за зараз (для обраної дати).
  Future<void> _pickTime(
    BuildContext context,
    TextEditingController ctrl,
    TextEditingController dateCtrl,
  ) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && context.mounted) {
      final now = DateTime.now();
      final selectedDate = _tryParseDate(dateCtrl.text) ?? DateTime.now();
      final candidate = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        picked.hour,
        picked.minute,
      );
      if (candidate.isAfter(now)) {
        showAppSnackBar(
          context,
          message: 'Час не може бути пізнішим за зараз',
          isError: true,
        );
        return;
      }
      ctrl.text =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return TripSectionCard(
      stepNumber: '1',
      title: 'Основна інформація',
      initiallyExpanded: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TripFieldLabel(label: 'Водойма'),
          AppFilterDropdown<String>(
            label: null,
            hint: 'Оберіть водойму',
            value: selectedWaterBody.isEmpty ? null : selectedWaterBody,
            items: waterBodyNames
                .map((name) => AppFilterItem(value: name, label: name))
                .toList(),
            onChanged: (val) {
              if (val != null) onWaterBodyChanged(val);
            },
          ),
          const SizedBox(height: 12),

          // Кнопка "+ Нова водойма"
          SizedBox(
            width: double.infinity,
            height: 46,
            child: TextButton.icon(
              onPressed: onAddWaterBody,
              style: TextButton.styleFrom(
                backgroundColor: AppColors.lightTealBg,
                foregroundColor: AppColors.primaryTeal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.add, size: 20),
              label: const Text(
                'Нова водойма',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 16),

          TripFieldLabel(label: 'Дата'),
          TripInputField(
            controller: dateCtrl,
            hintText: '24.05.2026',
            maxLength: 10,
            readOnly: true,
            onTap: () => _pickDate(context),
          ),
          const SizedBox(height: 16),

          TripFieldLabel(label: 'Час початку'),
          TripInputField(
            controller: startTimeCtrl,
            hintText: '06:00',
            maxLength: 5,
            readOnly: true,
            onTap: () => _pickTime(context, startTimeCtrl, dateCtrl),
          ),
          const SizedBox(height: 16),

          TripFieldLabel(label: 'Час завершення'),
          TripInputField(
            controller: endTimeCtrl,
            hintText: '12:00',
            maxLength: 5,
            readOnly: true,
            onTap: () => _pickTime(context, endTimeCtrl, dateCtrl),
          ),
          const SizedBox(height: 16),

          // Плашка Тривалість (перераховується автоматично при зміні часу)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF3F1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time, color: AppColors.primaryTeal, size: 20),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Тривалість',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      durationText,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
