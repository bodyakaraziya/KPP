import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/water_body.dart';
import '../theme/app_theme.dart';
import 'app_filter_dropdown.dart';
import '../utils/app_snackbar.dart';
import '../../features/trips/widgets/fish_photo_dialog.dart';

class WaterBodyCard extends StatelessWidget {
  final String imageUrl;
  final String type;
  final String name;
  final String subtitle;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const WaterBodyCard({
    super.key,
    required this.imageUrl,
    required this.type,
    required this.name,
    required this.subtitle,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.cardBorder, width: 1.2),
        ),
        child: Row(
          children: [
            // Квадратне фото водойми зліва
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imageUrl,
                width: 84,
                height: 84,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 84,
                  height: 84,
                  color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: Icon(Icons.image, size: 28, color: Colors.grey[600]),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Інформація посередині
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryTeal,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
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

            // Кнопки Редагувати (олівець) та Видалити (кошик) справа
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 20,
                    color: Color(0xFFB3261E),
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Нижнє модальне вікно (Bottom Sheet) для додавання або редагування водойми
Future<void> showWaterBodyFormSheet(
  BuildContext context, {
  bool isEditing = false,
  String? id,
  int initialTripsCount = 0,
  ValueChanged<WaterBody>? onSave,
  String? initialName,
  String? initialType,
  String? initialLocation,
  String? initialNotes,
  String? initialImageUrl,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    builder: (ctx) {
      return _WaterBodyFormSheetContent(
        isEditing: isEditing,
        id: id,
        initialTripsCount: initialTripsCount,
        onSave: onSave,
        initialName: initialName,
        initialType: initialType,
        initialLocation: initialLocation,
        initialNotes: initialNotes,
        initialImageUrl: initialImageUrl,
      );
    },
  );
}

class _WaterBodyFormSheetContent extends StatefulWidget {
  final bool isEditing;
  final String? id;
  final int initialTripsCount;
  final ValueChanged<WaterBody>? onSave;
  final String? initialName;
  final String? initialType;
  final String? initialLocation;
  final String? initialNotes;
  final String? initialImageUrl;

  const _WaterBodyFormSheetContent({
    required this.isEditing,
    this.id,
    this.initialTripsCount = 0,
    this.onSave,
    this.initialName,
    this.initialType,
    this.initialLocation,
    this.initialNotes,
    this.initialImageUrl,
  });

  @override
  State<_WaterBodyFormSheetContent> createState() =>
      _WaterBodyFormSheetContentState();
}

class _WaterBodyFormSheetContentState
    extends State<_WaterBodyFormSheetContent> {
  late String _selectedType;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _locationCtrl;
  late final TextEditingController _notesCtrl;
  String? _customImageUrl; // власне обране фото, перекриває initialImageUrl


  final List<String> _waterTypes = const [
    'Море',
    'Озеро',
    'Річка',
    'Річкова затока',
    'Водосховище',
    'Ставок',
  ];

  @override
  void initState() {
    super.initState();
    _selectedType =
        (widget.initialType != null && _waterTypes.contains(widget.initialType))
        ? widget.initialType!
        : 'Озеро';
    _nameCtrl = TextEditingController(text: widget.initialName ?? '');
    _locationCtrl = TextEditingController(text: widget.initialLocation ?? '');
    _notesCtrl = TextEditingController(text: widget.initialNotes ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _locationCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final url = await showDialog<String?>(
      context: context,
      builder: (_) => const FishPhotoDialog(),
    );
    if (mounted && url != null) {
      setState(() => _customImageUrl = url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final bottomInset = media.viewInsets.bottom > media.viewPadding.bottom
        ? media.viewInsets.bottom
        : media.viewPadding.bottom;
    final String photoUrl =
        _customImageUrl ??
        widget.initialImageUrl ??
        (widget.isEditing
            ? 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=900&q=80'
            : 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=900&q=80');

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
            // Сірий індикатор зверху (drag handle)
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

            // Заголовок + іконка стрілочки справа
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.isEditing ? 'Редагувати водойму' : 'Нова водойма',
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
            const SizedBox(height: 4),
            Text(
              widget.isEditing
                  ? 'Змініть дані та збережіть'
                  : 'Додайте улюблене місце до довідника',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 18),

            // Банер фотографії з кнопкою зміни фото
            SizedBox(
              height: 110,
              width: double.infinity,
              child: GestureDetector(
                onTap: _pickPhoto,
                child: Stack(
                  children: [
                    // Фото водойми
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.network(
                        photoUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 110,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: double.infinity,
                          height: 110,
                          color: Colors.grey[300],
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.image,
                            size: 32,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                    // Накладка з кнопкою зміни фото
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.black.withValues(alpha: 0.45),
                      ),
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
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Поле: Назва
            _buildLabel('Назва'),
            _buildTextField(
              controller: _nameCtrl,
              hintText: 'Наприклад, Озеро Синє',
            ),
            const SizedBox(height: 14),

            // Поле: Тип (випадаючий список в стилі решти форми)
            _buildLabel('Тип'),
            AppFilterDropdown<String>(
              hint: 'Оберіть тип водойми',
              items: _waterTypes
                  .map((t) => AppFilterItem(value: t, label: t))
                  .toList(),
              value: _selectedType,
              onChanged: (val) {
                if (val != null) setState(() => _selectedType = val);
              },
            ),
            const SizedBox(height: 14),

            // Поле: Локація
            _buildLabel('Локація'),
            _buildTextField(
              controller: _locationCtrl,
              hintText: 'Область або координати',
              prefixIcon: Icons.map_outlined,
            ),
            const SizedBox(height: 14),

            // Поле: Нотатки
            _buildLabel('Нотатки'),
            _buildTextField(
              controller: _notesCtrl,
              hintText: 'Особливості місця...',
              maxLines: 2,
              maxLength: 500,
            ),
            const SizedBox(height: 22),

            // Основна кнопка ("+ Додати водойму" або "✓ Зберегти зміни")
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  final name = _nameCtrl.text.trim();
                  if (name.isEmpty) {
                    showAppSnackBar(
                      context,
                      message: 'Введіть назву водойми',
                      isError: true,
                    );
                    return;
                  }
                  final body = WaterBody(
                    id: widget.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                    name: name,
                    type: _selectedType,
                    location: _locationCtrl.text.trim(),
                    notes: _notesCtrl.text.trim(),
                    imageUrl: photoUrl,
                    tripsCount: widget.initialTripsCount,
                  );
                  widget.onSave?.call(body);
                  showAppSnackBar(
                    context,
                    message: widget.isEditing
                        ? 'Зміни збережено!'
                        : 'Нову водойму додано!',
                    isError: false,
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: Icon(
                  widget.isEditing ? Icons.check : Icons.add,
                  size: 20,
                ),
                label: Text(
                  widget.isEditing ? 'Зберегти зміни' : 'Додати водойму',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Кнопка "Скасувати"
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

  Widget _buildTextField({
    String? initialValue,
    TextEditingController? controller,
    required String hintText,
    IconData? prefixIcon,
    int maxLines = 1,
    int maxLength = 100,
  }) {
    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      maxLines: maxLines,
      inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
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
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.textSecondary, size: 20)
            : null,
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
      ),
    );
  }
}

/// Діалогове вікно підтвердження видалення водойми (відповідно до макета Figma)
Future<void> showDeleteWaterBodyDialog(
  BuildContext context, {
  VoidCallback? onDelete,
}) {
  return showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.65),
    builder: (ctx) {
      return Dialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.delete_outline,
                color: Color(0xFFB3261E),
                size: 30,
              ),
              const SizedBox(height: 18),
              const Text(
                'Видалити водойму?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Водойму буде видалено з довідника. Виїзди залишаться незмінними.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 26),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text(
                      'Скасувати',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryTeal,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      onDelete?.call();
                      showAppSnackBar(
                        context,
                        message: 'Водойму видалено з довідника',
                        isError: false,
                      );
                    },
                    child: const Text(
                      'Видалити',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFB3261E),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
