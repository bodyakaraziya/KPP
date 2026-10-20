import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/trip_card.dart';
import 'add_trip_screen.dart';
import 'trip_detail_screen.dart';

class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key});

  // Hardcoded-список виїздів для демонстрації UI
  static const List<Map<String, String>> _mockTrips = [
    {
      'imageUrl':
          'assets/images/pid_vodoy.avif',
      'temperature': '+18°C',
      'date': '24 травня · 06:20',
      'location': 'Дніпровська затока',
      'fishName': 'Щука',
      'weight': '4,8 кг',
    },
    {
      'imageUrl':
          'assets/images/gory.avif',
      'temperature': '+14°C',
      'date': '18 травня · 05:45',
      'location': 'Озеро Біле',
      'fishName': 'Окунь',
      'weight': '2,1 кг',
    },
    {
      'imageUrl':
          'assets/images/lis.avif',
      'temperature': '+21°C',
      'date': '10 травня · 07:00',
      'location': 'Річка Десна',
      'fishName': 'Судак',
      'weight': '3,4 кг',
    },
    {
      'imageUrl':
          'assets/images/okean_susha.avif',
      'temperature': '+16°C',
      'date': '2 травня · 05:15',
      'location': 'Київське водосховище',
      'fishName': 'Лящ',
      'weight': '5,2 кг',
    },
  ];

  void _openAddTrip(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddTripScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Перевіряємо, чи екран відкрито через Navigator.push (з бургер-меню)
    final bool canPop = Navigator.canPop(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundBottom,
      body: Container(
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
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Показуємо кнопку "Назад", тільки якщо відкрили з меню профілю
                if (canPop) ...[
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(8),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
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
                            'Назад',
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
                ],

                // 1. Шапка екрана
                _buildHeader(context),
                const SizedBox(height: 20),

                // 2. Панель фільтрів (Водойма, Дата, Вид риби)
                _buildFiltersBar(),
                const SizedBox(height: 20),

                // 3. Лічильник записів
                Text(
                  '${_mockTrips.length} записи',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),

                // 4. Список карток виїздів
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _mockTrips.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final trip = _mockTrips[index];
                    return TripCard(
                      imageUrl: trip['imageUrl']!,
                      temperature: trip['temperature']!,
                      date: trip['date']!,
                      location: trip['location']!,
                      fishName: trip['fishName']!,
                      weight: trip['weight']!,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TripDetailScreen(
                              tripName: trip['location']!,
                              tripDate: trip['date']!,
                              tripLocation: trip['location']!,
                              imageUrl: trip['imageUrl']!,
                              temperature: trip['temperature']!,
                            ),
                          ),
                        );
                      },
                      onEdit: () => _openAddTrip(context),
                      onDelete: () => showDeleteTripDialog(context),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Мої виїзди',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Усі рибальські історії в\nодному місці',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 10),
            Row(
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
          ],
        ),
      ],
    );
  }

  Widget _buildFiltersBar() {
    bool isExpanded =
        false; // Зміни на true, якщо хочеш, щоб за замовчуванням був розкритий

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.cardBorder, width: 1.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Верхня шапка (клікабельна)
              InkWell(
                onTap: () => setState(() => isExpanded = !isExpanded),
                borderRadius: BorderRadius.circular(22),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
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
                          Icons.filter_alt_outlined,
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
                              'Фільтри виїздів',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isExpanded
                                  ? 'Оберіть потрібні параметри'
                                  : 'Показано всі виїзди',
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
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),

              // Розгорнута частина (чистий UI без логіки)
              if (isExpanded) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(color: AppColors.cardBorder, height: 1),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFilterDropdown(
                        label: 'Водойма',
                        value: 'Усі водойми',
                      ),
                      const SizedBox(height: 14),
                      _buildFilterDropdown(
                        label: 'Період',
                        value: 'За весь час',
                      ),
                      const SizedBox(height: 14),
                      _buildFilterDropdown(
                        label: 'Вид риби',
                        value: 'Усі види',
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () => setState(() => isExpanded = false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryTeal,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'Показати 4 виїзди',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterDropdown({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cardBorder, width: 1.2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }
}