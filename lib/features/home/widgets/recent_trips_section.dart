import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/models/trip.dart';
import '../../../core/models/catch_item.dart';
import '../../trips/providers/trips_provider.dart';
import '../../trips/screens/trip_detail_screen.dart';
import 'recent_trip_card.dart';

/// Секція "Останні виїзди" на екрані Головна.
/// Показує реально два останні виїзди з TripsProvider; якщо виїздів немає — повідомляє користувача.
class RecentTripsSection extends StatelessWidget {
  const RecentTripsSection({super.key});

  static final List<String> _months = [
    'Січ', 'Лют', 'Бер', 'Кві', 'Трав', 'Черв',
    'Лип', 'Серп', 'Вер', 'Жовт', 'Лист', 'Гру',
  ];

  String _formatTripDate(Trip trip) {
    final h = trip.date.hour.toString().padLeft(2, '0');
    final m = trip.date.minute.toString().padLeft(2, '0');
    return '${trip.date.day} ${_months[trip.date.month - 1]} · $h:$m';
  }

  String _catchSummary(Trip trip) {
    final best = CatchItem.maxByWeight(trip.catchItems);
    if (best != null) {
      return best.weight.isNotEmpty
          ? '${best.fishName} ${best.weight} кг'
          : best.fishName;
    }
    return 'Без улову';
  }

  @override
  Widget build(BuildContext context) {
    final tripsProvider = context.watch<TripsProvider>();
    final allTrips = tripsProvider.trips;

    // Два останні виїзди (найсвіжіші за датою)
    final sorted = List<Trip>.of(allTrips)..sort((a, b) => b.date.compareTo(a.date));
    final recent = sorted.take(2).toList();

    Widget sectionHeader() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Останні виїзди',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Ваші найсвіжіші пригоди на воді',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ],
      );
    }

    if (recent.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionHeader(),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.cardBorder, width: 1.2),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.event_busy_outlined,
                  size: 40,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Виїздів ще немає',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Додайте свій перший виїзд, щоб він тут з\'явився.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      );
    }

    // Картки останніх виїздів з відступом між ними
    final cardWidgets = <Widget>[];
    for (int i = 0; i < recent.length; i++) {
      final trip = recent[i];
      cardWidgets.add(RecentTripCard(
        title: trip.waterBodyName,
        date: _formatTripDate(trip),
        catchSummary: _catchSummary(trip),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TripDetailScreen(trip: trip),
            ),
          );
        },
      ));
      if (i < recent.length - 1) {
        cardWidgets.add(const SizedBox(height: 16));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionHeader(),
        const SizedBox(height: 16),
        ...cardWidgets,
      ],
    );
  }
}
