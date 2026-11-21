import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/models/catch_item.dart';
import '../../../core/utils/app_snackbar.dart';
import 'trip_form_helpers.dart';
import 'fish_photo_dialog.dart';

/// Крок 4: Улов.
class CatchStep extends StatefulWidget {
  final List<CatchItem> catchItems;
  final VoidCallback onAddFish;
  final ValueChanged<int> onRemoveFish;
  /// Редагувати існуючу позицію улову за індексом.
  final ValueChanged<int>? onEditFish;

  const CatchStep({
    super.key,
    required this.catchItems,
    required this.onAddFish,
    required this.onRemoveFish,
    this.onEditFish,
  });

  @override
  State<CatchStep> createState() => _CatchStepState();
}

class _CatchStepState extends State<CatchStep> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Column(
        children: [
          // Заголовок — клік згортає / розгортає секцію
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Номер підрозділа замість кількості улову
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.lightTealBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          '4',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryTeal,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Улов',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: widget.onAddFish,
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.lightTealBg,
                      foregroundColor: AppColors.primaryTeal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text(
                      'Додати рибу',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Зміст секції — анімоване з'явлення / зникнення
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: _expanded
                ? Padding(
                    padding: const EdgeInsets.only(
                      left: 18,
                      right: 18,
                      bottom: 18,
                      top: 18,
                    ),
                    child: _buildContent(context),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.catchItems.isEmpty) ...[
          // Порожній стан улову
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F8F6),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.cardBorder, width: 1.2),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.set_meal_outlined,
                  color: AppColors.primaryTeal,
                  size: 32,
                ),
                SizedBox(height: 10),
                Text(
                  'Ще немає улову',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTeal,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Натисніть «Додати рибу», щоб записати перший улов',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ] else
          Column(
            children: List.generate(
              widget.catchItems.length,
              (index) => _buildCatchItem(context, index, widget.catchItems[index]),
            ),
          ),
      ],
    );
  }

  Widget _buildCatchItem(BuildContext context, int index, CatchItem item) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F8F6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Row(
        children: [
          Expanded(
            child: widget.onEditFish != null
                ? GestureDetector(
                    onTap: () => widget.onEditFish!(index),
                    behavior: HitTestBehavior.opaque,
                    child: _buildCatchItemContent(context, item),
                  )
                : _buildCatchItemContent(context, item),
          ),
          if (widget.onEditFish != null)
            IconButton(
              icon: const Icon(
                Icons.edit_outlined,
                color: AppColors.primaryTeal,
                size: 20,
              ),
              color: Colors.transparent,
              onPressed: () => widget.onEditFish!(index),
              tooltip: 'Редагувати улов',
              visualDensity: VisualDensity.compact,
            ),
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: Color(0xFFB3261E),
              size: 20,
            ),
            color: Colors.transparent,
            onPressed: () => widget.onRemoveFish(index),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  Widget _buildCatchItemContent(BuildContext context, CatchItem item) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox.fromSize(
            size: const Size(56, 56),
            child: item.imageUrl.isNotEmpty
                ? Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _fishPhotoPlaceholder(),
                  )
                : _fishPhotoPlaceholder(),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.fishName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                [
                  if (item.weight.isNotEmpty) CatchItem.formatWeight(item.weight),
                  if (item.length.isNotEmpty) '${item.length} см',
                  if (item.time.isNotEmpty) item.time,
                ].join(' · '),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _fishPhotoPlaceholder() => Container(
        color: AppColors.lightTealBg,
        child: const Icon(
          Icons.set_meal_outlined,
          color: AppColors.primaryTeal,
          size: 24,
        ),
      );
}

/// Діалог створення або редагування однієї позиції улову.
/// Оформлено аналогічно формі додавання снасті: підпис окремо від поля,
/// фото зверху, кнопки «Зберегти» / «Скасувати» підійшли вертикально.
/// Коли передано [item], форма відкривається в режимі редагування з
/// попередньо заповненими даними цієї позиції.
class FishItemFormDialog extends StatefulWidget {
  final String? initialImageUrl;
  /// Існуюча позиція улову для редагування. Якщо null — форма створення нового улову.
  final CatchItem? item;
  /// Час початку виїзду (HH:MM) — межа для валідації часу лову.
  final String startTime;
  /// Час кінця виїзду (HH:MM) — межа для валідації часу лову.
  final String endTime;

  const FishItemFormDialog({
    super.key,
    this.initialImageUrl,
    this.item,
    required this.startTime,
    required this.endTime,
  });

  @override
  State<FishItemFormDialog> createState() => _FishItemFormDialogState();
}

class _FishItemFormDialogState extends State<FishItemFormDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _weightCtrl;
  late final TextEditingController _lengthCtrl;
  late final TextEditingController _timeCtrl;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _nameCtrl = TextEditingController(text: item?.fishName ?? '');
    _weightCtrl = TextEditingController(text: item?.weight ?? '');
    _lengthCtrl = TextEditingController(text: item?.length ?? '');
    _timeCtrl = TextEditingController(text: item?.time ?? '');
    _imageUrl = item?.imageUrl ?? widget.initialImageUrl;
  }

  /// Перетворює рядок часу HH:MM на хвилини від півночі (або null, якщо невірний формат).
  int? _timeToMinutes(String t) {
    try {
      final parts = t.trim().split(':');
      if (parts.length == 2) {
        return int.parse(parts[0]) * 60 + int.parse(parts[1]);
      }
    } catch (_) {}
    return null;
  }

  /// Перевіряє, чи час лову лежить в межах часу виїзду [startTime, endTime].
  bool _catchTimeInTripRange(String time) {
    final start = _timeToMinutes(widget.startTime);
    final end = _timeToMinutes(widget.endTime);
    final minutes = _timeToMinutes(time);
    if (start == null || end == null || minutes == null) return true;
    return minutes >= start && minutes <= end;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _weightCtrl.dispose();
    _lengthCtrl.dispose();
    _timeCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final url = await showDialog<String?>(
      context: context,
      builder: (_) => const FishPhotoDialog(),
    );
    if (mounted && url != null) {
      setState(() => _imageUrl = url);
    }
  }

  /// Обирає час лову через системний годинник, замість ручного введення.
  /// Годинник завжди повертає коректний час, додаткова валідація не потрібна.
  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (mounted && picked != null) {
      setState(() {
        _timeCtrl.text =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  void _save() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      showAppSnackBar(
        context,
        message: 'Введіть назву риби',
        isError: true,
      );
      return;
    }
    final weight = _weightCtrl.text.trim();
    final length = _lengthCtrl.text.trim();
    if (weight.isNotEmpty && !_isNumeric(weight)) {
      showAppSnackBar(
        context,
        message: 'Вага має бути числом (наприклад, 5 або 5,5)',
        isError: true,
      );
      return;
    }
    if (length.isNotEmpty && !_isNumeric(length)) {
      showAppSnackBar(
        context,
        message: 'Довжина має бути числом (наприклад, 30 або 30,5)',
        isError: true,
      );
      return;
    }
    final time = _timeCtrl.text.trim();
    if (time.isNotEmpty && !_catchTimeInTripRange(time)) {
      showAppSnackBar(
        context,
        message:
            'Час лову має бути в межах часу виїзду (${widget.startTime}–${widget.endTime})',
        isError: true,
      );
      return;
    }
    Navigator.pop(
      context,
      CatchItem(
        fishName: name,
        weight: weight,
        length: length,
        time: _timeCtrl.text.trim(),
        imageUrl: _imageUrl ?? '',
      ),
    );
  }

  /// Перевіряє, чи рядок є коректним десятковим числом (дозволяється кому або крапку як роздільник).
  bool _isNumeric(String s) {
    final cleaned = s.trim().replaceAll(',', '.');
    return double.tryParse(cleaned) != null;
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final bottomInset = media.viewInsets.bottom > media.viewPadding.bottom
        ? media.viewInsets.bottom
        : media.viewPadding.bottom;
    final bool isEditing = widget.item != null;
    return Container(
      margin: const EdgeInsets.only(top: 32),
      padding: EdgeInsets.fromLTRB(22, 12, 22, bottomInset),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Сігий індикатор зверху (drag handle)
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.cardBorder,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Заголовок + іконка закриття
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEditing ? 'Редагувати улов' : 'Додати рибу до улову',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(8),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.chevron_right,
                      color: AppColors.textPrimary,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              'Заповніть дані про улов',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),

            // Фото риби — зверху, як у інших формах
            _buildLabel('Фото риби'),
            GestureDetector(
              onTap: _pickPhoto,
              child: Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F8F6),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.cardBorder, width: 1.2),
                ),
                child: (_imageUrl ?? '').isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Stack(
                          children: [
                            Image.network(
                              _imageUrl!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 150,
                              errorBuilder: (_, _, _) => _photoPlaceholder(),
                            ),
                            Positioned.fill(
                              child: Container(
                                color: Colors.black.withValues(alpha: 0.35),
                                alignment: Alignment.center,
                                child: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      'Змінити фото',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : _photoPlaceholder(),
              ),
            ),
            const SizedBox(height: 12),

            // Поле: Назва риби
            _buildLabel('Назва риби'),
            TripInputField(
              controller: _nameCtrl,
              hintText: 'Наприклад, Щука',
              maxLength: 50,
            ),
            const SizedBox(height: 16),

            // Поле: Вага (кг)
            _buildLabel('Вага'),
            TripInputField(
              controller: _weightCtrl,
              hintText: 'кг',
              maxLength: 10,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              additionalInputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9,\.]')),
              ],
            ),
            const SizedBox(height: 16),

            // Поле: Довжина (см)
            _buildLabel('Довжина'),
            TripInputField(
              controller: _lengthCtrl,
              hintText: 'см',
              maxLength: 10,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              additionalInputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9,\.]')),
              ],
            ),
            const SizedBox(height: 16),

            // Поле: Час лову
            _buildLabel('Час лову'),
            TripInputField(
              controller: _timeCtrl,
              hintText: '08:15',
              maxLength: 8,
              readOnly: true,
              onTap: _pickTime,
            ),
            const SizedBox(height: 22),

            // Кнопки дій verтикально: «Додати улов» і «Скасувати» під ним
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: Icon(isEditing ? Icons.save : Icons.add, size: 18),
                label: Text(
                  isEditing ? 'Зберегти зміни' : 'Додати улов',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
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
      ),
    );
  }

  Widget _buildLabel(String text) {
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

  Widget _photoPlaceholder() => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.add_a_photo,
              color: AppColors.primaryTeal,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              'Додати фото риби',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
}
