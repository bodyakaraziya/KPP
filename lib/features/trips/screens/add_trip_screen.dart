import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/widgets/water_body_card.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/tackle_card.dart';
import '../../../core/utils/app_snackbar.dart';

class AddTripScreen extends StatefulWidget {
  const AddTripScreen({super.key});

  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  String _selectedWaterBody = 'Дніпровська затока';
  String _selectedWeather = 'Сонячно';

  // Інтерактивний вибір снастей (за замовчуванням вибрано Спінінг Favorite X1 2.1м, як у Figma)
  final Set<String> _selectedTackle = {'Спінінг Favorite X1 2.1м'};

  void _toggleTackle(String item) {
    setState(() {
      if (_selectedTackle.contains(item)) {
        _selectedTackle.remove(item);
      } else {
        _selectedTackle.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBottom,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.backgroundTop, AppColors.backgroundBottom],
            stops: [0.0, 0.25],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Основний скрол форми
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Кнопка "< До списку виїздів"
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(8),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.chevron_left,
                              color: AppColors.primaryTeal,
                              size: 20,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'До списку виїздів',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryTeal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Заголовок + Статус синхронізації
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Новий виїзд',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Збережіть деталі та спогади про\nриболовлю',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.syncDotGreen,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'Синхронізовано',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Картка 1: Основна інформація
                    _buildStep1BasicInfo(),
                    const SizedBox(height: 16),

                    // Картка 2: Погода та спорядження
                    _buildStep2WeatherAndTackle(),
                    const SizedBox(height: 16),

                    // Картка 3: Улов (0)
                    _buildStep3Catch(),
                    const SizedBox(height: 16),

                    // Картка 4: Нотатки
                    _buildStep4Notes(),
                  ],
                ),
              ),

              // Фіксована кнопка "Зберегти виїзд" знизу
              Positioned(
                left: 20,
                right: 20,
                bottom: 16,
                child: SizedBox(
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      showAppSnackBar(
                        context,
                        message: 'Виїзд успішно збережено!',
                        isError: false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryTeal,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(Icons.set_meal_outlined, size: 20),
                    label: const Text(
                      'Зберегти виїзд',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- КРОК 1: ОСНОВНА ІНФОРМАЦІЯ ---
  Widget _buildStep1BasicInfo() {
    return _buildSectionCard(
      stepNumber: '1',
      title: 'Основна інформація',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldLabel('Водойма'),
          _buildDropdownBox(
            value: _selectedWaterBody,
            items: const [
              'Дніпровська затока',
              'Озеро Біле',
              'Річка Десна',
              'Київське водосховище',
            ],
            onChanged: (val) {
              if (val != null) setState(() => _selectedWaterBody = val);
            },
          ),
          const SizedBox(height: 12),

          // Кнопка "+ Нова водойма"
          SizedBox(
            width: double.infinity,
            height: 46,
            child: TextButton.icon(
              onPressed: () => showWaterBodyFormSheet(context),
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

          _buildFieldLabel('Дата'),
          _buildInputField(hintText: '24.05.2026', maxLength: 10),
          const SizedBox(height: 16),

          _buildFieldLabel('Час початку'),
          _buildInputField(hintText: '06:00', maxLength: 5),
          const SizedBox(height: 16),

          _buildFieldLabel('Час завершення'),
          _buildInputField(hintText: '12:00', maxLength: 5),
          const SizedBox(height: 16),

          // Плашка Тривалість
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF3F1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              children: [
                Icon(Icons.access_time, color: AppColors.primaryTeal, size: 20),
                SizedBox(width: 12),
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
                    SizedBox(height: 2),
                    Text(
                      '6 год 0 хв',
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

  // --- КРОК 2: ПОГОДА ТА СПОРЯДЖЕННЯ ---
  Widget _buildStep2WeatherAndTackle() {
    return _buildSectionCard(
      stepNumber: '2',
      title: 'Погода та спорядження',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldLabel('Температура'),
          _buildInputField(
            initialValue: '+18°C',
            prefixIcon: Icons.wb_sunny_outlined,
          ),
          const SizedBox(height: 16),

          _buildFieldLabel('Умови'),
          _buildDropdownBox(
            value: _selectedWeather,
            items: const ['Сонячно', 'Хмарно', 'Дощ', 'Вітряно', 'Туман'],
            onChanged: (val) {
              if (val != null) setState(() => _selectedWeather = val);
            },
          ),
          const SizedBox(height: 16),

          _buildFieldLabel('Вітер'),
          _buildInputField(initialValue: '3 м/с Пн-Зх', prefixIcon: Icons.air),
          const SizedBox(height: 16),

          _buildFieldLabel('Тиск'),
          _buildInputField(initialValue: '752 мм'),
          const SizedBox(height: 22),

          // Заголовок Снасті + лічильник вибраних + кнопка "+ Нова снасть"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Снасті',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.lightTealBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check,
                          size: 14,
                          color: AppColors.primaryTeal,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${_selectedTackle.length} вибрано',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryTeal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () => showTackleFormSheet(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryTeal,
                      side: const BorderSide(
                        color: AppColors.primaryTeal,
                        width: 1,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.add, size: 15),
                    label: const Text(
                      'Нова снасть',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Категорії снастей
          _buildTackleCategoryHeader(
            icon: Icons.set_meal_outlined,
            color: AppColors.primaryTeal,
            title: 'ВУДКА',
          ),
          _buildTackleChip('Спінінг Favorite X1 2.1м'),
          _buildTackleChip('Brain Apex Feeder 3.6м'),
          const SizedBox(height: 12),

          _buildTackleCategoryHeader(
            icon: Icons.wb_sunny_outlined,
            color: AppColors.accentGreen,
            title: 'КОТУШКА',
          ),
          _buildTackleChip('Shimano Nasci C3000'),
          const SizedBox(height: 12),

          _buildTackleCategoryHeader(
            icon: Icons.set_meal_outlined,
            color: AppColors.accentAmber,
            title: 'ПРИМАНКА',
          ),
          _buildTackleChip('Lucky John Tioga 3.5" Pearl'),
          _buildTackleChip('Воблер Rapala X-Rap 10'),
          const SizedBox(height: 12),

          _buildTackleCategoryHeader(
            icon: Icons.water_drop_outlined,
            color: const Color(0xFF5E4B8B),
            title: 'НАЖИВКА',
          ),
          _buildTackleChip('Helicopter Rig з кукурудзою'),
          _buildTackleChip("Черв'як дощовий"),
        ],
      ),
    );
  }

  // --- КРОК 3: УЛОВ (0) ---
  Widget _buildStep3Catch() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildStepBadge('3'),
                  const SizedBox(width: 12),
                  const Text(
                    'Улов (0)',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () => _showPickFishPhotoDialog(context),
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
          const SizedBox(height: 18),

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
        ],
      ),
    );
  }

  // --- КРОК 4: НОТАТКИ ---
  Widget _buildStep4Notes() {
    return _buildSectionCard(
      stepNumber: '4',
      title: 'Нотатки',
      child: TextFormField(
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

  // --- ДОПОМІЖНІ ЕЛЕМЕНТИ ФОРМИ ---
  Widget _buildSectionCard({
    required String stepNumber,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildStepBadge(stepNumber),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }

  Widget _buildStepBadge(String number) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.lightTealBg,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Text(
        number,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTeal,
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildInputField({
    String? initialValue,
    String? hintText,
    IconData? prefixIcon,
    int maxLength = 100,
  }) {
    return TextFormField(
      initialValue: initialValue,
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

  Widget _buildDropdownBox({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.textSecondary,
          ),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildTackleCategoryHeader({
    required IconData icon,
    required Color color,
    required String title,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTackleChip(String label) {
    final bool isSelected = _selectedTackle.contains(label);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _toggleTackle(label),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.lightTealBg : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primaryTeal : AppColors.cardBorder,
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSelected) ...[
                const Icon(Icons.check, size: 16, color: AppColors.primaryTeal),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? AppColors.primaryTeal
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- МОДАЛЬНЕ ВІКНО "ВИБРАТИ ФОТО РИБИ" (ЗГІДНО З МАКЕТОМ FIGMA) ---
  void _showPickFishPhotoDialog(BuildContext context) {
    // Demo photos for fish (using the same Unsplash photos as placeholder)
    const List<String> _demoFishPhotos = [
      'https://images.unsplash.com/photo-1544551763-46a013bb70d5?auto=format&fit=crop&w=600&q=80',
      'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=600&q=80',
      'https://images.unsplash.com/photo-1505118380757-91f5f5632de0?auto=format&fit=crop&w=600&q=80',
      'https://images.unsplash.com/photo-1508193638397-1c4234db14d8?auto=format&fit=crop&w=600&q=80',
      'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=600&q=80',
    ];

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.65),
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 26, 22, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Вибрати фото риби',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Виберіть з демо-галереї або підключіть камеру',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 18),

                Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () {
                          // In a real app, we would handle camera capture here.
                          // For now, we just close the dialog.
                          Navigator.pop(ctx);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.lightTealBg,
                          foregroundColor: AppColors.primaryTeal,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.camera_alt_outlined, size: 18),
                        label: const Text(
                          'Камера',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () {
                          // For demo, we select the first fish photo.
                          // In a real app, we would return the selected image.
                          Navigator.pop(ctx);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.lightTealBg,
                          foregroundColor: AppColors.primaryTeal,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.image_outlined, size: 18),
                        label: const Text(
                          'Галерея',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _demoFishPhotos.map((url) {
                    return GestureDetector(
                      onTap: () {
                        // In a real app, we would return the selected image.
                        Navigator.pop(ctx);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          url,
                          width: 82,
                          height: 82,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 82,
                            height: 82,
                            color: Colors.grey[300],
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.image,
                              size: 28,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}