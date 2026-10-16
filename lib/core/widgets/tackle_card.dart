import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Допоміжний клас для стилізації різних категорій снастей
class TackleStyle {
  final IconData icon;
  final Color bgColor;
  final Color accentColor;

  const TackleStyle({
    required this.icon,
    required this.bgColor,
    required this.accentColor,
  });

  static TackleStyle fromCategory(String category) {
    switch (category.toLowerCase()) {
      case 'вудка':
        return const TackleStyle(
          icon: Icons.set_meal_outlined,
          bgColor: AppColors.lightTealBg,
          accentColor: AppColors.primaryTeal,
        );
      case 'котушка':
        return const TackleStyle(
          icon: Icons.wb_sunny_outlined,
          bgColor: AppColors.lightGreenBg,
          accentColor: AppColors.accentGreen,
        );
      case 'приманка':
        return const TackleStyle(
          icon: Icons.set_meal_outlined,
          bgColor: AppColors.lightAmberBg,
          accentColor: AppColors.accentAmber,
        );
      case 'наживка':
        return const TackleStyle(
          icon: Icons.water_drop_outlined,
          bgColor: Color(0xFFEDE7F6),
          accentColor: Color(0xFF5E4B8B),
        );
      default:
        return const TackleStyle(
          icon: Icons.wb_sunny_outlined,
          bgColor: Color(0xFFE8ECEB),
          accentColor: AppColors.textSecondary,
        );
    }
  }
}

class TackleCard extends StatelessWidget {
  final String category;
  final String name;
  final String notes;
  final String tripsCount;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TackleCard({
    super.key,
    required this.category,
    required this.name,
    required this.notes,
    required this.tripsCount,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final style = TackleStyle.fromCategory(category);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.cardBorder, width: 1.2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Іконка категорії зліва
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: style.bgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(style.icon, color: style.accentColor, size: 24),
            ),
            const SizedBox(width: 14),

            // Основна інформація посередині
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Верхній рядок: Бейдж категорії + кількість виїздів
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: style.bgColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          category.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: style.accentColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 13,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            tripsCount,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Назва снасті
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Нотатки / опис
                  Text(
                    notes,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),

            // Кнопки дій справа (Редагувати та Видалити)
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 20,
                    color: AppColors.textPrimary,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
                const SizedBox(height: 8),
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

/// Нижнє модальне вікно (Bottom Sheet) для додавання або редагування снасті
Future<void> showTackleFormSheet(
  BuildContext context, {
  bool isEditing = false,
  String? initialCategory,
  String? initialName,
  String? initialNotes,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    builder: (ctx) {
      return _TackleFormSheetContent(
        isEditing: isEditing,
        initialCategory: initialCategory,
        initialName: initialName,
        initialNotes: initialNotes,
      );
    },
  );
}

class _TackleFormSheetContent extends StatefulWidget {
  final bool isEditing;
  final String? initialCategory;
  final String? initialName;
  final String? initialNotes;

  const _TackleFormSheetContent({
    required this.isEditing,
    this.initialCategory,
    this.initialName,
    this.initialNotes,
  });

  @override
  State<_TackleFormSheetContent> createState() =>
      _TackleFormSheetContentState();
}

class _TackleFormSheetContentState extends State<_TackleFormSheetContent> {
  late String _selectedCategory;

  final List<String> _categories = const [
    'Вудка',
    'Котушка',
    'Приманка',
    'Наживка',
    'Інше',
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory =
        (widget.initialCategory != null &&
            _categories.contains(widget.initialCategory))
        ? widget.initialCategory!
        : 'Вудка';
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final currentStyle = TackleStyle.fromCategory(_selectedCategory);

    return Container(
      margin: const EdgeInsets.only(top: 60),
      padding: EdgeInsets.fromLTRB(22, 12, 22, 20 + bottomInset),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Верхній сірий індикатор (drag handle)
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

            // Заголовок + стрілочка закриття
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.isEditing ? 'Редагувати снасть' : 'Нова снасть',
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
                  : 'Оберіть тип та введіть назву',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),

            // Чіпи вибору категорії снасті
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories.map((cat) {
                final bool isSelected = _selectedCategory == cat;
                final catStyle = TackleStyle.fromCategory(cat);

                return InkWell(
                  onTap: () => setState(() => _selectedCategory = cat),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? catStyle.bgColor : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? catStyle.accentColor
                            : AppColors.cardBorder,
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          catStyle.icon,
                          size: 16,
                          color: isSelected
                              ? catStyle.accentColor
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          cat,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected
                                ? catStyle.accentColor
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 22),

            // Поле: Назва або модель
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel('Назва або модель'),
                _buildTextField(
                  initialValue: widget.initialName,
                  hintText: 'Напр., Спінінг Favorite X1 2.1м',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Поле: Нотатки (необов'язково)
            _buildLabel("Нотатки (необов'язково)"),
            _buildTextField(
              initialValue: widget.initialNotes,
              hintText: 'Характеристики, стан, особливості...',
              maxLines: 3,
            ),
            const SizedBox(height: 22),

            // Основна кнопка ("+ Зберегти снасть" або "✓ Зберегти зміни")
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        widget.isEditing
                            ? 'Снасть оновлено!'
                            : 'Нову снасть додано до арсеналу!',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
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
                  widget.isEditing ? 'Зберегти зміни' : 'Зберегти снасть',
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
    required String hintText,
    int maxLines = 1,
  }) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: maxLines,
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

/// Діалогове вікно підтвердження видалення снасті (відповідно до макета Figma)
Future<void> showDeleteTackleDialog(BuildContext context) {
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
                'Видалити снасть?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Снасть буде видалено з вашого довідника. Виїзди, де вона використовувалась, залишаться без змін.',
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Снасть видалено з довідника'),
                          duration: Duration(seconds: 1),
                        ),
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
