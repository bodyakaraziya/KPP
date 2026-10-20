import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/trip_card.dart';
import 'add_trip_screen.dart';

class TripDetailScreen extends StatelessWidget {
  final String tripName;
  final String tripDate;
  final String tripLocation;
  final String imageUrl;
  final String temperature;

  const TripDetailScreen({
    super.key,
    required this.tripName,
    required this.tripDate,
    required this.tripLocation,
    this.imageUrl = 'assets/images/pid_vodoy.avif',
    this.temperature = '+18°C',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.backgroundTop, AppColors.backgroundBottom],
            stops: [0.0, 0.35],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Верхня панель навігації та дій
                _buildTopBar(context),
                const SizedBox(height: 16),

                // 2. Головне фото виїзду (Hero Card)
                _buildHeroCard(),
                const SizedBox(height: 16),

                // 3. Картка "Погода"
                _buildSectionCard(
                  title: 'Погода',
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildWeatherChip(
                        icon: Icons.wb_sunny_outlined,
                        label: 'Сонячно',
                        isHighlighted: true,
                      ),
                      _buildWeatherChip(
                        icon: Icons.wb_sunny_outlined,
                        label: temperature,
                        isHighlighted: true,
                      ),
                      _buildWeatherChip(
                        icon: Icons.air,
                        label: '3 м/с Пн-Зх',
                        isHighlighted: true,
                      ),
                      _buildWeatherChip(
                        icon: Icons.access_time,
                        label: '752 мм',
                        isHighlighted: false,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 4. Картка "Снасті"
                _buildSectionCard(
                  title: 'Снасті',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildGearChip('Спінінг Favorite X1 2.1м'),
                      const SizedBox(height: 8),
                      _buildGearChip('Shimano Nasci C3000'),
                      const SizedBox(height: 8),
                      _buildGearChip('Lucky John Tioga 3.5" Pearl'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 5. Картка "Улов"
                _buildSectionCard(
                  title: 'Улов',
                  badgeText: '2 риби',
                  child: Column(
                    children: [
                      _buildCatchItem(
                        imageUrl: 'assets/images/pid_vodoy.avif',
                        fishName: 'Щука',
                        weight: '3,2 кг',
                        length: '68 см',
                        time: '08:15',
                      ),
                      const SizedBox(height: 12),
                      _buildCatchItem(
                        imageUrl: 'assets/images/gory.avif',
                        fishName: 'Щука',
                        weight: '1,6 кг',
                        length: '52 см',
                        time: '10:30',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 6. Картка "Нотатки"
                _buildSectionCard(
                  title: 'Нотатки',
                  child: const Text(
                    'Вранці клювало активно. Найбільша взяла на джиг біля берегової лінії очерету. Відпустив двох щупаків до 1 кг.',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.45,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- ДОПОМІЖНІ МЕТОДИ ВЕРСТКИ ---

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(10),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.chevron_left,
                  color: AppColors.primaryTeal,
                  size: 22,
                ),
                SizedBox(width: 4),
                Text(
                  'До списку виїздів',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTeal,
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            _buildActionIconButton(
              icon: Icons.edit_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddTripScreen()),
                );
              },
            ),
            const SizedBox(width: 8),
            _buildActionIconButton(
              icon: Icons.delete_outline,
              onTap: () => showDeleteTripDialog(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder, width: 1.2),
        ),
        child: Icon(icon, size: 20, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      height: 230,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.15),
                    Colors.black.withValues(alpha: 0.7),
                  ],
                  stops: const [0.3, 1.0],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Плашка температури
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.wb_sunny_outlined,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          temperature,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Дата та локація знизу
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$tripDate  ·  6 год 25 хв',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tripLocation,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    String? badgeText,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              if (badgeText != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lightTealBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badgeText,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryTeal,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _buildWeatherChip({
    required IconData icon,
    required String label,
    required bool isHighlighted,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: isHighlighted ? AppColors.lightTealBg : const Color(0xFFF3F7F6),
        borderRadius: BorderRadius.circular(12),
        border: isHighlighted
            ? null
            : Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isHighlighted
                ? AppColors.primaryTeal
                : AppColors.textPrimary,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isHighlighted
                  ? AppColors.primaryTeal
                  : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGearChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F7F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.wb_sunny_outlined,
            size: 16,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCatchItem({
    required String imageUrl,
    required String fishName,
    required String weight,
    required String length,
    required String time,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F7F6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              imageUrl,
              width: 88,
              height: 88,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 88,
                height: 88,
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
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fishName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _buildCatchSubChip(
                      icon: Icons.set_meal_outlined,
                      label: weight,
                    ),
                    _buildCatchSubChip(label: length),
                    _buildCatchSubChip(icon: Icons.access_time, label: time),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCatchSubChip({IconData? icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF2F0),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.cardBorder, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: AppColors.textPrimary),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
