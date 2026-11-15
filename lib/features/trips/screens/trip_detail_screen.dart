import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/models/trip.dart';
import '../../../core/widgets/trip_card.dart';
import '../providers/trips_provider.dart';
import '../widgets/trip_detail_catch_item.dart';
import '../widgets/trip_detail_chips.dart';
import '../widgets/trip_detail_hero_card.dart';
import '../widgets/trip_detail_section_card.dart';
import '../widgets/trip_detail_top_bar.dart';
import 'add_trip_screen.dart';

const List<String> _tripDetailMonths = [
  'Січ', 'Лют', 'Бер', 'Кві', 'Трав', 'Черв',
  'Лип', 'Серп', 'Вер', 'Жовт', 'Лист', 'Гру',
];

String _formatTripDate(DateTime date, String startTime) {
  return '${date.day} ${_tripDetailMonths[date.month - 1]} · $startTime';
}

/// Екран деталей виїзду — приймає повний об’єкт [Trip] і відображає
/// реальні збережені дані замість захардкожених значень.
class TripDetailScreen extends StatelessWidget {
  final Trip trip;

  const TripDetailScreen({
    super.key,
    required this.trip,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = _formatTripDate(trip.date, trip.startTime);

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
                TripDetailTopBar(
                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddTripScreen(trip: trip),
                      ),
                    );
                  },
                  onDelete: () => showDeleteTripDialog(
                    context,
                    onDelete: () {
                      context.read<TripsProvider>().deleteTrip(trip.id);
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // 2. Головне фото виїзду (Hero Card)
                TripDetailHeroCard(
                  imageUrl: trip.imageUrl,
                  temperature: trip.temperature,
                  tripDate: dateStr,
                  tripLocation: trip.location,
                ),
                const SizedBox(height: 16),

                // 3. Картка "Погода"
                TripDetailSectionCard(
                  title: 'Погода',
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      TripDetailWeatherChip(
                        icon: Icons.wb_sunny_outlined,
                        label: trip.weather,
                        isHighlighted: true,
                      ),
                      TripDetailWeatherChip(
                        icon: Icons.wb_sunny_outlined,
                        label: trip.temperature,
                        isHighlighted: true,
                      ),
                      TripDetailWeatherChip(
                        icon: Icons.air,
                        label: trip.wind,
                        isHighlighted: true,
                      ),
                      TripDetailWeatherChip(
                        icon: Icons.access_time,
                        label: trip.pressure,
                        isHighlighted: false,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 4. Картка "Снасті"
                TripDetailSectionCard(
                  title: 'Снасті',
                  child: trip.tackle.isEmpty
                      ? const Text(
                          'Снастей ще не додано',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (int i = 0; i < trip.tackle.length; i++) ...[
                              TripDetailGearChip(text: trip.tackle[i]),
                              if (i < trip.tackle.length - 1)
                                const SizedBox(height: 8),
                            ],
                          ],
                        ),
                ),
                const SizedBox(height: 16),

                // 5. Картка "Улов"
                TripDetailSectionCard(
                  title: 'Улов',
                  badgeText: '${trip.catchItems.length} риби',
                  child: trip.catchItems.isEmpty
                      ? const Text(
                          'Улов не додано',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        )
                      : Column(
                          children: [
                            for (int i = 0; i < trip.catchItems.length; i++)
                              ...[
                                TripDetailCatchItem(
                                  imageUrl: trip.catchItems[i].imageUrl,
                                  fishName: trip.catchItems[i].fishName,
                                  weight: trip.catchItems[i].weight,
                                  length: trip.catchItems[i].length,
                                  time: trip.catchItems[i].time,
                                ),
                                if (i < trip.catchItems.length - 1)
                                  const SizedBox(height: 12),
                              ],
                          ],
                        ),
                ),
                const SizedBox(height: 16),

                // 6. Картка "Нотатки"
                TripDetailSectionCard(
                  title: 'Нотатки',
                  child: Text(
                    trip.notes.isNotEmpty
                        ? trip.notes
                        : 'Нотаток ще немає',
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
}
