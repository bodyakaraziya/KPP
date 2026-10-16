import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int _selectedPeriodIndex = 3; // За замовчуванням 'Весь час' (індекс 3)
  DateTimeRange? _customDateRange;

  final List<String> _periods = const ['Тиждень', 'Місяць', 'Рік', 'Весь час'];

  Map<String, dynamic> get _currentStats {
    // Якщо вибрано власні дати
    if (_selectedPeriodIndex == -1 && _customDateRange != null) {
      final start = "${_customDateRange!.start.day}.${_customDateRange!.start.month}";
      final end = "${_customDateRange!.end.day}.${_customDateRange!.end.month}";
      return {
        'periodLabel': 'Виїздів за $start - $end',
        'tripsCount': '3', // Тут підставлятимуться реальні дані за період
        'bestCatch': '5,0 кг',
        'bestWaterBody': 'Невідома\nводойма',
        'totalWeight': '12,5 кг',
        'chartSubtitle': 'Активність: $start - $end',
        'bars': [
          {'label': '1 дн', 'value': 0},
          {'label': '2 дн', 'value': 2},
          {'label': '3 дн', 'value': 1},
        ],
        'maxVal': 2,
        'yLabels': [2, 1, 0],
        'records': [
          {'name': 'Карась', 'spot': 'Секретне місце', 'weight': '5,0 кг', 'share': 1.0},
        ],
      };
    }

    // Існуючий switch для стандартних періодів...
    final selectedPeriod = _periods[_selectedPeriodIndex];
    
    switch (selectedPeriod) {
      case 'Тиждень':
        return {
          'periodLabel': 'Виїздів за тиждень',
          'tripsCount': '2',
          'bestCatch': '4,8 кг',
          'bestWaterBody': 'Дніпровська\nзатока',
          'totalWeight': '7,4 кг',
          'chartSubtitle': 'Виїзди за тиждень',
          'bars': [
            {'label': 'Пн', 'value': 0},
            {'label': 'Вт', 'value': 1},
            {'label': 'Ср', 'value': 0},
            {'label': 'Чт', 'value': 0},
            {'label': 'Пт', 'value': 0},
            {'label': 'Сб', 'value': 1},
            {'label': 'Нд', 'value': 0},
          ],
          'maxVal': 3,
          'yLabels': [3, 2, 1, 0],
          'records': [
            {
              'name': 'Щука',
              'spot': 'Дніпровська затока',
              'weight': '4,8 кг',
              'share': 1.0,
            },
            {
              'name': 'Окунь',
              'spot': 'Дніпровська затока',
              'weight': '0,9 кг',
              'share': 0.25,
            },
          ],
        };
      case 'Місяць':
        return {
          'periodLabel': 'Виїздів за місяць',
          'tripsCount': '6',
          'bestCatch': '6,1 кг',
          'bestWaterBody': 'Озеро\nБіле',
          'totalWeight': '24,5 кг',
          'chartSubtitle': 'Виїзди за місяць',
          'bars': [
            {'label': '1 тиж', 'value': 1},
            {'label': '2 тиж', 'value': 2},
            {'label': '3 тиж', 'value': 1},
            {'label': '4 тиж', 'value': 2},
          ],
          'maxVal': 4,
          'yLabels': [4, 3, 2, 1, 0],
          'records': [
            {
              'name': 'Щука',
              'spot': 'Озеро Біле',
              'weight': '6,1 кг',
              'share': 1.0,
            },
            {
              'name': 'Судак',
              'spot': 'Дніпровська затока',
              'weight': '3,4 кг',
              'share': 0.56,
            },
            {
              'name': 'Лящ',
              'spot': 'Озеро Біле',
              'weight': '2,2 кг',
              'share': 0.36,
            },
            {
              'name': 'Окунь',
              'spot': 'Річка Десна',
              'weight': '1,1 кг',
              'share': 0.18,
            },
          ],
        };
      case 'Рік':
        return {
          'periodLabel': 'Виїздів за рік',
          'tripsCount': '18',
          'bestCatch': '8,2 кг',
          'bestWaterBody': 'Дніпровська\nзатока',
          'totalWeight': '86,4 кг',
          'chartSubtitle': 'Виїзди за рік',
          'bars': [
            {'label': 'Трав', 'value': 3},
            {'label': 'Черв', 'value': 4},
            {'label': 'Лип', 'value': 2},
            {'label': 'Серп', 'value': 5},
            {'label': 'Вер', 'value': 3},
            {'label': 'Жовт', 'value': 1},
          ],
          'maxVal': 6,
          'yLabels': [6, 4, 2, 0],
          'records': [
            {
              'name': 'Щука',
              'spot': 'Дніпровська затока',
              'weight': '8,2 кг',
              'share': 1.0,
            },
            {
              'name': 'Судак',
              'spot': 'Київське водосховище',
              'weight': '4,5 кг',
              'share': 0.55,
            },
            {
              'name': 'Лящ',
              'spot': 'Озеро Біле',
              'weight': '2,8 кг',
              'share': 0.34,
            },
            {
              'name': 'Окунь',
              'spot': 'Дніпровська затока',
              'weight': '1,4 кг',
              'share': 0.17,
            },
          ],
        };
      default: // 'Весь час'
        return {
          'periodLabel': 'Виїздів за весь час',
          'tripsCount': '47',
          'bestCatch': '8,2 кг',
          'bestWaterBody': 'Дніпровська\nзатока',
          'totalWeight': '182,3 кг',
          'chartSubtitle': 'Виїзди за весь час',
          'bars': [
            {'label': 'Трав', 'value': 5},
            {'label': 'Черв', 'value': 8},
            {'label': 'Лип', 'value': 7},
            {'label': 'Серп', 'value': 12},
            {'label': 'Вер', 'value': 9},
            {'label': 'Жовт', 'value': 6},
          ],
          'maxVal': 12,
          'yLabels': [12, 9, 6, 3, 0],
          'records': [
            {
              'name': 'Щука',
              'spot': 'Дніпровська затока',
              'weight': '8,2 кг',
              'share': 1.0,
            },
            {
              'name': 'Короп',
              'spot': 'Озеро Біле',
              'weight': '6,7 кг',
              'share': 0.82,
            },
            {
              'name': 'Судак',
              'spot': 'Київське водосховище',
              'weight': '4,5 кг',
              'share': 0.55,
            },
            {
              'name': 'Лящ',
              'spot': 'Річка Десна',
              'weight': '3,1 кг',
              'share': 0.38,
            },
            {
              'name': 'Окунь',
              'spot': 'Дніпровська затока',
              'weight': '1,6 кг',
              'share': 0.20,
            },
          ],
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final stats = _currentStats;

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

                // 2. Плавний перемикач періоду + Кнопка календаря
                Row(
                  children: [
                    Expanded(child: _buildPeriodSelector()),
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
                _buildTripsHeroCard(stats),
                const SizedBox(height: 16),

                // 4. Друга велика картка
                _buildBestWaterBodyCard(stats),
                const SizedBox(height: 16),

                // 5. Виправлена картка зі стовпчастою діаграмою
                _buildActivityChartCard(stats),
                const SizedBox(height: 16),

                // 6. Додаткова картка знизу: Рекорди за видами риби
                _buildSpeciesBreakdownCard(stats),
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
    );
  }

  /// Плавний Segmented Control з єдиним повзунком, що ковзає
  Widget _buildPeriodSelector() {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = constraints.maxWidth / _periods.length;

          return Stack(
            children: [
              // Єдина біла плашка, яка плавно їздить між вкладками
              // Єдина біла плашка, яка плавно їздить між вкладками
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                // Якщо -1, фіксуємо на 0, але ховаємо через Opacity
                left: _selectedPeriodIndex >= 0
                    ? _selectedPeriodIndex * tabWidth
                    : 0,
                top: 0,
                bottom: 0,
                width: tabWidth,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 150),
                  opacity: _selectedPeriodIndex >= 0 ? 1.0 : 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Текстові кнопки поверх плашки
              Row(
                children: List.generate(_periods.length, (index) {
                  final isSelected = _selectedPeriodIndex == index;
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => setState(() => _selectedPeriodIndex = index),
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontFamily: 'Inter', // Або твій основний шрифт
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color: isSelected
                                ? AppColors.primaryTeal
                                : AppColors.textSecondary,
                          ),
                          child: Text(_periods[index]),
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

  Widget _buildTripsHeroCard(Map<String, dynamic> stats) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A4D50), Color(0xFF006D73), Color(0xFF08484B)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00676C).withValues(alpha: 0.2),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stats['periodLabel'] as String,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.78),
                ),
              ),
              const SizedBox(height: 10),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  stats['tripsCount'] as String,
                  key: ValueKey(stats['tripsCount']),
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.05,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Найкращий улов: ${stats['bestCatch']}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.78),
                ),
              ),
            ],
          ),
          Positioned(
            right: 4,
            bottom: 0,
            child: Icon(
              Icons.calendar_today_outlined,
              size: 46,
              color: Colors.white.withValues(alpha: 0.55),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBestWaterBodyCard(Map<String, dynamic> stats) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF5A8059), Color(0xFF6E996B)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF436947).withValues(alpha: 0.18),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Найкраща водойма',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 10),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  stats['bestWaterBody'] as String,
                  key: ValueKey(stats['bestWaterBody']),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.15,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Загальний улов: ${stats['totalWeight']}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          Positioned(
            right: 4,
            bottom: 0,
            child: Icon(
              Icons.water_drop_outlined,
              size: 48,
              color: Colors.white.withValues(alpha: 0.65),
            ),
          ),
        ],
      ),
    );
  }

  /// Виправлений графік з правильною геометрією осі Y, сіткою та стовпчиками
  Widget _buildActivityChartCard(Map<String, dynamic> stats) {
    final List<Map<String, dynamic>> bars = List<Map<String, dynamic>>.from(
      stats['bars'] as List,
    );
    final int maxVal = stats['maxVal'] as int;
    final List<int> yLabels = List<int>.from(stats['yLabels'] as List);

    const double topValueHeight =
        24.0; // місце під цифру зверху + відступ (18 + 6)
    const double maxBarAreaHeight = 110.0; // чиста висота зони стовпчиків
    const double bottomLabelsHeight = 24.0; // відступ + підпис знизу (8 + 16)

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок та легенда
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Активність виїздів',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 11,
                    height: 11,
                    decoration: BoxDecoration(
                      color: AppColors.primaryTeal,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Виїзди',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            stats['chartSubtitle'] as String,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),

          // Область графіка з точно розрахованою висотою (24 + 110 + 24 = 158 px)
          SizedBox(
            height: topValueHeight + maxBarAreaHeight + bottomLabelsHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Вісь Y
                Padding(
                  padding: const EdgeInsets.only(
                    top: topValueHeight,
                    bottom: bottomLabelsHeight,
                    right: 10,
                  ),
                  child: SizedBox(
                    height: maxBarAreaHeight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: yLabels.map((val) {
                        return Text(
                          '$val-',
                          style: const TextStyle(
                            fontSize: 11,
                            height: 1.0,
                            color: AppColors.textSecondary,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                // Сітка + Стовпчики діаграми
                Expanded(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      // Фонова горизонтальна сітка
                      Padding(
                        padding: const EdgeInsets.only(
                          top: topValueHeight,
                          bottom: bottomLabelsHeight,
                        ),
                        child: SizedBox(
                          height: maxBarAreaHeight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: yLabels.map((_) {
                              return Container(
                                height: 1,
                                color: AppColors.cardBorder.withValues(
                                  alpha: 0.5,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),

                      // Стовпчики
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(bars.length, (index) {
                          final bar = bars[index];
                          final int value = bar['value'] as int;
                          final String label = bar['label'] as String;

                          final double rawHeight = maxVal > 0
                              ? (value / maxVal) * maxBarAreaHeight
                              : 0.0;
                          final double barHeight = value == 0
                              ? 4.0
                              : rawHeight.clamp(10.0, maxBarAreaHeight);

                          return Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Фіксована висота блоку з цифрою (18 px)
                                SizedBox(
                                  height: 18,
                                  child: Center(
                                    child: Text(
                                      '$value',
                                      style: TextStyle(
                                        fontSize: 11,
                                        height: 1.0,
                                        fontWeight: FontWeight.w700,
                                        color: value > 0
                                            ? AppColors.textPrimary
                                            : AppColors.textSecondary
                                                  .withValues(alpha: 0.6),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOutCubic,
                                  width: bars.length <= 4 ? 42 : 30,
                                  height: barHeight,
                                  decoration: BoxDecoration(
                                    color: value > 0
                                        ? AppColors.primaryTeal
                                        : const Color(0xFFDCE5E3),
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(8),
                                      bottom: Radius.circular(3),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Фіксована висота підпису осі X (16 px)
                                SizedBox(
                                  height: 16,
                                  child: Text(
                                    label,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      height: 1.1,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeciesBreakdownCard(Map<String, dynamic> stats) {
    final List<Map<String, dynamic>> records = List<Map<String, dynamic>>.from(
      stats['records'] as List,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Рекорди за видами',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Icon(
                Icons.emoji_events_outlined,
                color: AppColors.primaryTeal.withValues(alpha: 0.8),
                size: 22,
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Найвагоміші трофеї (особистий рекорд)',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 18),
          ...records.asMap().entries.map((entry) {
            final int index = entry.key;
            final Map<String, dynamic> item = entry.value;
            final bool isTopRecord = index == 0;

            return Padding(
              padding: EdgeInsets.only(
                bottom: index == records.length - 1 ? 0 : 16,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      // Назва виду + локація рекорду
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              item['name'] as String,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                '• ${item['spot']}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Трофейна вага
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: isTopRecord
                              ? AppColors.primaryTeal.withValues(alpha: 0.12)
                              : const Color(0xFFF3F7F6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item['weight'] as String,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: isTopRecord
                                ? AppColors.primaryTeal
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Плавний прогрес-бар
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(
                        begin: 0.0,
                        end: item['share'] as double,
                      ),
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, _) {
                        return LinearProgressIndicator(
                          value: value,
                          minHeight: 8,
                          backgroundColor: const Color(0xFFE9EFED),
                          color: isTopRecord
                              ? AppColors.primaryTeal
                              : AppColors.primaryTeal.withValues(alpha: 0.65),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}