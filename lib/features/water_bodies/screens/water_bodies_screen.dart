import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/water_body_card.dart';
import 'water_body_detail_screen.dart';

class WaterBodiesScreen extends StatelessWidget {
  const WaterBodiesScreen({super.key});

  static const List<Map<String, String>> _mockWaterBodies = [
    {
      'name': 'Дніпровська затока',
      'type': 'Річкова затока',
      'location': 'Київська обл., Вишгородський р-н',
      'notes': 'Глибина до 6 м, багато щуки в очереті.',
      'tripsCount': '2 виїзди',
      'imageUrl': 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=900&q=80',
    },
    {
      'name': 'Озеро Біле',
      'type': 'Озеро',
      'location': 'Рівненська обл., Вараський р-н',
      'notes':
          'Чиста вода, піщане дно. Гарний кльов окуня та щуки на світанку.',
      'tripsCount': '1 виїзд',
      'imageUrl': 'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?auto=format&fit=crop&w=900&q=80',
    },
    {
      'name': 'Річка Стугна',
      'type': 'Річка',
      'location': 'Київська обл., Обухівський р-н',
      'notes': 'Тиха річка. Плотва та краснопірка.',
      'tripsCount': '1 виїзд',
      'imageUrl': 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=900&q=80',
    },
  ];

 @override
  Widget build(BuildContext context) {
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

                // Шапка
                _buildHeader(context),
                const SizedBox(height: 22),

                // Список карток водойм
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _mockWaterBodies.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final item = _mockWaterBodies[index];
                    return WaterBodyCard(
                      imageUrl: item['imageUrl']!,
                      type: item['type']!,
                      name: item['name']!,
                      subtitle: '${item['location']} · ${item['tripsCount']}',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WaterBodyDetailScreen(
                              name: item['name']!,
                              type: item['type']!,
                              location: item['location']!,
                              notes: item['notes']!,
                              imageUrl: item['imageUrl']!,
                            ),
                          ),
                        );
                      },
                      onEdit: () => showWaterBodyFormSheet(
                        context,
                        isEditing: true,
                        initialName: item['name'],
                        initialType: item['type'],
                        initialLocation: item['location'],
                        initialNotes: item['notes'],
                        initialImageUrl: item['imageUrl'],
                      ),
                      onDelete: () => showDeleteWaterBodyDialog(context),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag:
            null, // Вимикає конфлікт Hero-тегів між вкладкою та окремим вікном
        onPressed: () => showWaterBodyFormSheet(context),
        backgroundColor: AppColors.primaryTeal,
        foregroundColor: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: const Icon(Icons.add, size: 30),
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
                'Водойми',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Місця, куди хочеться\nповертатися',
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
}
