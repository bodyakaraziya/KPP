import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../trips/providers/trips_provider.dart';
import '../models/statistics_data.dart';
import '../widgets/activity_chart_card.dart';
import '../widgets/best_water_body_card.dart';
import '../widgets/species_breakdown_card.dart';
import '../widgets/trips_hero_card.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int _selectedPeriodIndex = 3; // За замовчуванням 'Весь час' (індекс 3)
  DateTimeRange? _customDateRange;

  final List<String> _periods = const ['Тиждень', 'Місяць', 'Рік', 'Весь час'];

  /// Перетворює вибраний індекс періоду на StatPeriod для обчислень.
  StatPeriod get _statPeriod {
    switch (_selectedPeriodIndex) {
      case 0:
        return StatPeriod.week;
      case 1:
        return StatPeriod.month;
      case 2:
        return StatPeriod.year;
      case 3:
        return StatPeriod.allTime;
      default:
        return StatPeriod.custom;
    }
  }

  /// Горизонтальний сегментований вибір періоду з плавним пересуванням виділення.
  Widget _buildPeriodSegmentedControl() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = constraints.maxWidth / _periods.length;
          return Stack(
            children: [
              // Плавносуvable підсвічування вибраного періоду (під кнопками)
              // Плавносуvable підсвічування вибраного періоду (під кнопками)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeInOutCubic,
                left: itemWidth * _selectedPeriodIndex,
                top: 3,
                bottom: 3,
                child: Container(
                  width: itemWidth - 6,
                  decoration: BoxDecoration(
                    color: AppColors.primaryTeal.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              // Самі кнопки періоду (наверху, над підсвічуванням)
              Row(
                children: List.generate(_periods.length, (index) {
                  final isSelected = _selectedPeriodIndex == index;
                  return SizedBox(
                    width: itemWidth,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() {
                          _customDateRange = null;
                          _selectedPeriodIndex = index;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: isSelected
                            ? BoxDecoration(
                                color: AppColors.primaryTeal,
                                borderRadius: BorderRadius.circular(10),
                              )
                            : null,
                        child: Text(
                          _periods[index],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textSecondary.withValues(alpha: 0.85),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tripsProvider = context.watch<TripsProvider>();
    final stats = computeStats(
      trips: tripsProvider.trips,
      period: _statPeriod,
      customStart: _customDateRange?.start,
      customEnd: _customDateRange?.end,
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundBottom,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.backgroundTop, AppColors.backgroundBottom],
            stops: [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Кнопка "< Назад"
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

                // 1. Шапка
                _buildHeader(),
                const SizedBox(height: 20),

                // 2. Горизонтальний вибір періоду + кнопка календаря
                Row(
                  children: [
                    Expanded(
                      child: _buildPeriodSegmentedControl(),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: _pickCustomDateRange,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: _selectedPeriodIndex == -1
                              ? AppColors.primaryTeal
                              : Colors.white.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(16),
                          border: _selectedPeriodIndex == -1
                              ? null
                              : Border.all(
                                  color: AppColors.cardBorder,
                                  width: 1.2,
                                ),
                        ),
                        child: Icon(
                          Icons.date_range_rounded,
                          size: 20,
                          color: _selectedPeriodIndex == -1
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 3. Перша велика картка
                TripsHeroCard(stats: stats),
                const SizedBox(height: 16),

                // 4. Друга велика картка
                BestWaterBodyCard(stats: stats),
                const SizedBox(height: 16),

                // 5. Виправлена картка зі стовпчастою діаграмою
                ActivityChartCard(stats: stats),
                const SizedBox(height: 16),

                // 6. Додаткова картка знизу: Рекорди за видами риби
                SpeciesBreakdownCard(stats: stats),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Статистика',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Ваш сезон у цифрах',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _pickCustomDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange:
          _customDateRange ??
          DateTimeRange(
            start: DateTime.now().subtract(const Duration(days: 7)),
            end: DateTime.now(),
          ),
      firstDate: DateTime(2020), // Найстаріша доступна дата
      lastDate: DateTime.now(), // Не можна вибрати дати в майбутньому
      cancelText: 'СКАСУВАТИ',
      confirmText: 'ОБРАТИ',
      helpText: 'ОБЕРІТЬ ПРОМІЖОК ДАТ',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryTeal,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _customDateRange = picked;
        _selectedPeriodIndex = -1; // -1 означає, що активний кастомний фільтр
      });
    }
  }
}
