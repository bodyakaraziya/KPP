/// Статистика, обчислена з реальних виїздів (замість жорстко закодованих даних).
/// Джерело даних — `TripsProvider` (список виїздів із уловом).
library;

import '../../../core/models/trip.dart';

/// Період, за який рахують статистику.
enum StatPeriod { week, month, year, allTime, custom }

const List<String> _monthsUk = [
  'Січ', 'Лют', 'Бер', 'Кві', 'Трав', 'Черв',
  'Лип', 'Серп', 'Вер', 'Жовт', 'Лист', 'Гру',
];

const List<String> _weekdaysUk = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Нд'];

/// Чисельне значення ваги з рядка типу '4,8 кг' або '5 кг'.
double _parseWeight(String w) {
  final cleaned = w.replaceAll(RegExp(r'[^0-9,\.]'), '').replaceAll(',', '.');
  return double.tryParse(cleaned) ?? 0.0;
}

String _formatKg(double kg) {
  return '${kg.toStringAsFixed(1).replaceAll('.', ',')} кг';
}

String _fmtDm(DateTime d) {
  return '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}';
}

bool _isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

/// Кількість виїздів, чья дата потрапляє у включень інтервал [start, end].
int _countInRange(List<Trip> trips, DateTime start, DateTime end) {
  return trips.where((t) {
    return !t.date.isBefore(start) && !t.date.isAfter(end);
  }).length;
}

/// Стовпчики за останні 7 днів (по дню тижня).
List<Map<String, dynamic>> _weekBars(List<Trip> trips, DateTime now) {
  final today = DateTime(now.year, now.month, now.day);
  final bars = <Map<String, dynamic>>[];
  for (var i = 6; i >= 0; i--) {
    final day = today.subtract(Duration(days: i));
    final value = trips.where((t) => _isSameDay(t.date, day)).length;
    bars.add({'label': _weekdaysUk[day.weekday - 1], 'value': value});
  }
  return bars;
}

/// Стовпчики за останні 4 тижня.
List<Map<String, dynamic>> _fourWeekBars(List<Trip> trips, DateTime now) {
  final today = DateTime(now.year, now.month, now.day);
  final bars = <Map<String, dynamic>>[];
  for (var i = 3; i >= 0; i--) {
    final weekEnd = today.subtract(Duration(days: i * 7));
    final weekStart = weekEnd.subtract(const Duration(days: 6));
    final value = _countInRange(trips, weekStart, weekEnd);
    bars.add({'label': '${4 - i} тиж', 'value': value});
  }
  return bars;
}

/// Стовпчики: виїзди у датному інтервалі згруповані за календарними місяцями.
/// Повертає лише місяці, в яких є виїзди (хронологічно, до 12 останніх).
List<Map<String, dynamic>> _monthBarsInRange(
  List<Trip> trips,
  DateTime? start,
  DateTime? end,
) {
  final relevant = trips.where((t) {
    if (start != null && t.date.isBefore(start)) return false;
    if (end != null && t.date.isAfter(end)) return false;
    return true;
  }).toList();

  if (relevant.isEmpty) return [];

  final byMonth = <String, int>{};
  for (final t in relevant) {
    final key = '${t.date.year}-${t.date.month.toString().padLeft(2, '0')}';
    byMonth[key] = (byMonth[key] ?? 0) + 1;
  }

  final sortedKeys = byMonth.keys.toList()..sort();
  final takeKeys =
      sortedKeys.length > 12 ? sortedKeys.sublist(sortedKeys.length - 12) : sortedKeys;

  return takeKeys.map((key) {
    final parts = key.split('-');
    final month = int.parse(parts[1]);
    return {'label': _monthsUk[month - 1], 'value': byMonth[key]!};
  }).toList();
}

/// Стовпчики для кастомного діапазону дат.
List<Map<String, dynamic>> _customRangeBars(
    List<Trip> trips, DateTime start, DateTime end) {
  final startDay = DateTime(start.year, start.month, start.day);
  final endDay = DateTime(end.year, end.month, end.day);
  final days = endDay.difference(startDay).inDays + 1;
  final bars = <Map<String, dynamic>>[];

  if (days <= 31) {
    for (var i = 0; i < days; i++) {
      final day = startDay.add(Duration(days: i));
      final value = trips.where((t) => _isSameDay(t.date, day)).length;
      bars.add({'label': _fmtDm(day), 'value': value});
    }
  } else {
    // Довший проміжок — розбиваємо на тиждені (до 8 стовпчиків).
    final count = (days / 7).ceil().clamp(1, 8);
    final step = days / count;
    for (var j = 0; j < count; j++) {
      final chunkStart = startDay.add(Duration(days: (j * step).round()));
      final chunkEnd = j == count - 1
          ? endDay
          : startDay.add(Duration(days: ((j + 1) * step).round() - 1));
      final value = _countInRange(trips, chunkStart, chunkEnd);
      bars.add({'label': '${j + 1} тиж', 'value': value});
    }
  }
  return bars;
}

int _maxBarValue(List<Map<String, dynamic>> bars) {
  return bars.fold<int>(0, (max, b) {
    final v = b['value'] as int;
    return v > max ? v : max;
  });
}

List<int> _yLabels(int maxVal) {
  if (maxVal == 0) return [0];
  final step = (maxVal / 4).ceil();
  final labels = <int>[];
  var v = maxVal;
  while (v >= 0) {
    labels.add(v);
    v -= step;
  }
  if (labels.last != 0) labels.add(0);
  return labels;
}

/// Обчислює реальну статистику по виїздам за обраний період.
///
/// Параметри:
/// - [trips] — усі виїзди з `TripsProvider`;
/// - [period] — тип періоду (тиждень/місяць/рік/весь час/кастомний);
/// - [customStart], [customEnd] — межі кастомного діапазону дат;
/// - [fishType] — вид риби для фільтра (null або 'Усі види' — без фільтра).
Map<String, dynamic> computeStats({
  required List<Trip> trips,
  required StatPeriod period,
  DateTime? customStart,
  DateTime? customEnd,
  String? fishType,
}) {
  final now = DateTime.now();
  late final String periodLabel;
  late final String chartSubtitle;
  late final List<Map<String, dynamic>> bars;
  DateTime? rangeStart;
  DateTime? rangeEnd;

  // Виїзди після фільтра за видом риби.
  final filtered = List<Trip>.from(trips);
  if (fishType != null && fishType.isNotEmpty && fishType != 'Усі види') {
    filtered.retainWhere((t) =>
        t.catchItems.any((c) => c.fishName == fishType));
  }

  switch (period) {
    case StatPeriod.week:
      rangeStart = DateTime(now.year, now.month, now.day)
          .subtract(const Duration(days: 6));
      rangeEnd = now;
      bars = _weekBars(filtered, now);
      periodLabel = 'Виїздів за тиждень';
      chartSubtitle = 'Виїзди за тиждень';
      break;
    case StatPeriod.month:
      rangeStart = DateTime(now.year, now.month, now.day)
          .subtract(const Duration(days: 27));
      rangeEnd = now;
      bars = _fourWeekBars(filtered, now);
      periodLabel = 'Виїздів за місяць';
      chartSubtitle = 'Виїзди за місяць';
      break;
    case StatPeriod.year:
      rangeStart = now.subtract(const Duration(days: 365));
      rangeEnd = now;
      bars = _monthBarsInRange(filtered, rangeStart, rangeEnd);
      periodLabel = 'Виїздів за рік';
      chartSubtitle = 'Виїзди за рік';
      break;
    case StatPeriod.allTime:
      bars = _monthBarsInRange(filtered, null, null);
      periodLabel = 'Виїздів за весь час';
      chartSubtitle = 'Виїзди за весь час';
      break;
    case StatPeriod.custom:
      final start = customStart ?? DateTime.now();
      final end = customEnd ?? DateTime.now();
      rangeStart = start;
      rangeEnd = end;
      bars = _customRangeBars(filtered, start, end);
      periodLabel = 'Виїздів за ${_fmtDm(start)} - ${_fmtDm(end)}';
      chartSubtitle = 'Активність: ${_fmtDm(start)} - ${_fmtDm(end)}';
      break;
  }

  // Виїзди, що входять у обрану дату (для 'весь час' дати не обмежують).
  final counted = period == StatPeriod.allTime
      ? filtered
      : filtered.where((t) {
          if (rangeStart != null && t.date.isBefore(rangeStart)) return false;
          if (rangeEnd != null && t.date.isAfter(rangeEnd)) return false;
          return true;
        }).toList();

  final tripsCount = counted.length;

  double totalKg = 0;
  double bestKg = 0;
  String bestWaterBody = 'Немає виїздів';

  // Особистий рекорд за кожним видом (найвагоміша окрема риба).
  final bestBySpecies = <String, double>{};
  final speciesSpot = <String, String>{};

  for (final t in counted) {
    for (final c in t.catchItems) {
      final w = _parseWeight(c.weight);
      totalKg += w;

      final cur = bestBySpecies[c.fishName] ?? 0;
      if (w > cur) {
        bestBySpecies[c.fishName] = w;
        speciesSpot[c.fishName] = t.waterBodyName;
      }

      if (w > bestKg) {
        bestKg = w;
        bestWaterBody = t.waterBodyName;
      }
    }
  }

  final topRecords = bestBySpecies.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  final topFive = topRecords.take(5).toList();
  final maxRecord = topFive.isEmpty ? 0.0 : topFive.first.value;

  final records = topFive.map((e) => {
    'name': e.key,
    'spot': speciesSpot[e.key] ?? '',
    'weight': _formatKg(e.value),
    'share': maxRecord > 0 ? e.value / maxRecord : 0.0,
  }).toList();

  final totalWeight = _formatKg(totalKg);
  final bestCatch = bestKg > 0 ? _formatKg(bestKg) : '0 кг';
  if (counted.isNotEmpty && bestKg == 0) {
    bestWaterBody = 'Без улову';
  }

  final maxVal = _maxBarValue(bars);

  return {
    'periodLabel': periodLabel,
    'tripsCount': tripsCount.toString(),
    'bestCatch': bestCatch,
    'bestWaterBody': bestWaterBody,
    'totalWeight': totalWeight,
    'chartSubtitle': chartSubtitle,
    'bars': bars,
    'maxVal': maxVal,
    'yLabels': _yLabels(maxVal),
    'records': records,
  };
}
