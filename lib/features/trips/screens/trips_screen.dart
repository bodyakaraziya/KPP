import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/models/catch_item.dart';
import '../../../core/widgets/app_fab.dart';
import '../../../core/widgets/app_filter_dropdown.dart';
import '../../../core/widgets/trip_card.dart';
import '../../tackle/providers/tackle_provider.dart';
import '../../water_bodies/providers/water_bodies_provider.dart';
import '../providers/trips_provider.dart';
import '../widgets/trips_filters_bar.dart';
import 'add_trip_screen.dart';
import 'trip_detail_screen.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  String? _filterWaterBody;
  String? _filterPeriod;
  String? _fishType;
  DateTimeRange? _customDateRange;

  static const List<String> _months = [
    'Січ', 'Лют', 'Бер', 'Кві', 'Трав', 'Черв',
    'Лип', 'Серп', 'Вер', 'Жовт', 'Лист', 'Гру',
  ];

  String _formatDate(DateTime date) {
    final h = date.hour.toString().padLeft(2, '0');
    final m = date.minute.toString().padLeft(2, '0');
    return '${date.day} ${_months[date.month - 1]} · $h:$m';
  }

  void _openAddTrip(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddTripScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Список виїздів беремо із провайдера стану (лаба №5, завдання 3.3).
    // Фільтрація керується локально на цьому екрані, щоб не просочуватися на інші екрани.
    final tripsProvider = context.watch<TripsProvider>();
    final trips = tripsProvider.filterTrips(
      waterBody: _filterWaterBody,
      period: _filterPeriod,
      fishType: _fishType,
      dateRange: _customDateRange,
    );

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

                // 1. Шапка екрана
                _buildHeader(context),
                const SizedBox(height: 20),

                // 2. Панель фільтрів (Водойма, Дата, Вид риби)
                TripsFiltersBar(
                  waterBody: _filterWaterBody,
                  period: _filterPeriod,
                  customDateRange: _customDateRange,
                  fishType: _fishType,
                  waterBodyItems: tripsProvider.waterBodies
                      .map((name) => AppFilterItem(value: name, label: name))
                      .toList(),
                  fishTypeItems: tripsProvider.fishTypes
                      .map((name) => AppFilterItem(value: name, label: name))
                      .toList(),
                  onWaterBodyChanged: (val) =>
                      setState(() => _filterWaterBody = val),
                  onPeriodChanged: (val) =>
                      setState(() => _filterPeriod = val),
                  onDateRangeChanged: (val) =>
                      setState(() => _customDateRange = val),
                  onFishTypeChanged: (val) =>
                      setState(() => _fishType = val),
                ),
                const SizedBox(height: 20),

                // 3. Лічильник записів (реактивно з провайдера)
                Text(
                  '${trips.length} записи',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),

                // 4. Список карток виїздів (даних з TripsProvider)
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: trips.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final trip = trips[index];
                    final bestCatch = CatchItem.maxByWeight(trip.catchItems);
                    return TripCard(
                      imageUrl: trip.imageUrl,
                      temperature: trip.temperature,
                      date: _formatDate(trip.date),
                      location: trip.location,
                      fishName: bestCatch?.fishName ?? '',
                      weight: CatchItem.formatWeight(bestCatch?.weight ?? ''),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TripDetailScreen(
                              trip: trip,
                            ),
                          ),
                        );
                      },
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
                          context
                              .read<WaterBodiesProvider>()
                              .decrementTripsCount(trip.waterBodyName);
                          // Зменшуємо лічильники виїздів для всіх снастей цього виїзду.
                          for (final tackleName in trip.tackle) {
                            context.read<TackleProvider>().decrementTripsCount(tackleName);
                          }
                          context.read<TripsProvider>().deleteTrip(trip.id);
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: AppFab(
        heroTag: 'trips_screen_fab',
        onPressed: () => _openAddTrip(context),
        icon: Icons.add,
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
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
          'Усі рибальські історії в одному місці',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}
