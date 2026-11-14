import 'package:flutter/foundation.dart';

import '../../../core/models/catch_item.dart';
import '../../../core/models/trip.dart';

/// Управляє списком виїздів: завантаження, створення, редагування, видалення,
/// фільтрація та сортування (лаба №5, завдання 2 і 3.3–3.4).
class TripsProvider extends ChangeNotifier {
  final List<Trip> _trips = [];
  String? _filterWaterBody;
  String? _sortBy; // 'date' | 'location' | 'fish' | null
  bool _ascending = true;

  List<Trip> get trips => _applyFilterAndSort();
  String? get filterWaterBody => _filterWaterBody;
  String? get sortBy => _sortBy;
  bool get ascending => _ascending;

  /// Унікальні назви водойм для випадаючого фільтра.
  List<String> get waterBodies {
    final names = _trips.map((t) => t.waterBodyName).toSet().toList()..sort();
    return names;
  }

  /// Завантажити список виїздів (замість поточного).
  void loadTrips(List<Trip> trips) {
    _trips
      ..clear()
      ..addAll(trips);
    notifyListeners();
  }

  /// Додати новий виїзд.
  void addTrip(Trip trip) {
    _trips.add(trip);
    notifyListeners();
  }

  /// Редагувати існуючий виїзд за id.
  void updateTrip(String id, Trip updated) {
    final index = _trips.indexWhere((t) => t.id == id);
    if (index != -1) {
      _trips[index] = updated;
      notifyListeners();
    }
  }

  /// Видалити виїзд за id.
  void deleteTrip(String id) {
    _trips.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void setFilterWaterBody(String? value) {
    _filterWaterBody = value;
    notifyListeners();
  }

  void setSortBy(String? value, {bool ascending = true}) {
    _sortBy = value;
    _ascending = ascending;
    notifyListeners();
  }

  List<Trip> _applyFilterAndSort() {
    var result = _trips.where((t) {
      if (_filterWaterBody == null || _filterWaterBody!.isEmpty) return true;
      return t.waterBodyName == _filterWaterBody;
    }).toList();

    if (_sortBy != null) {
      result.sort((a, b) {
        int cmp;
        switch (_sortBy) {
          case 'date':
            cmp = a.date.compareTo(b.date);
            break;
          case 'location':
            cmp = a.location.compareTo(b.location);
            break;
          case 'fish':
            cmp = _fishName(a).compareTo(_fishName(b));
            break;
          default:
            cmp = 0;
        }
        return _ascending ? cmp : -cmp;
      });
    }
    return result;
  }

  String _fishName(Trip t) {
    if (t.catchItems.isNotEmpty) return t.catchItems.first.fishName;
    return '';
  }

  /// Набір демо-даних для перевірки UI (замість реального бекенду).
  static List<Trip> demoTrips() {
    return [
      Trip(
        id: 'trip-1',
        waterBodyName: 'Дніпровська затока',
        location: 'Дніпровська затока',
        date: DateTime(2026, 5, 24, 6, 20),
        startTime: '06:20',
        endTime: '12:00',
        duration: '5 год 40 хв',
        temperature: '+18°C',
        weather: 'Сонячно',
        wind: '3 м/с',
        pressure: '752 мм',
        imageUrl:
            'https://images.unsplash.com/photo-1544551763-46a013bb70d5?auto=format&fit=crop&w=900&q=80',
        tackle: ['Спіннинг Favorite X1 2.1м', 'Shimano Nasci C3000'],
        catchItems: [
          CatchItem(
            fishName: 'Щука',
            weight: '4,8 кг',
            length: '72 см',
            time: '08:15',
          ),
        ],
        notes: 'Вранці клювало активно.',
      ),
      Trip(
        id: 'trip-2',
        waterBodyName: 'Озеро Біле',
        location: 'Озеро Біле',
        date: DateTime(2026, 5, 18, 5, 45),
        startTime: '05:45',
        endTime: '11:00',
        duration: '5 год 15 хв',
        temperature: '+14°C',
        weather: 'Хмарно',
        wind: '2 м/с',
        pressure: '755 мм',
        imageUrl:
            'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?auto=format&fit=crop&w=900&q=80',
        tackle: ['Brain Apex Feeder 3.6м'],
        catchItems: [
          CatchItem(fishName: 'Окунь', weight: '2,1 кг', length: '35 см', time: '07:30'),
        ],
        notes: 'Чиста вода, піщане дно.',
      ),
      Trip(
        id: 'trip-3',
        waterBodyName: 'Річка Десна',
        location: 'Річка Десна',
        date: DateTime(2026, 5, 10, 7, 0),
        startTime: '07:00',
        endTime: '13:00',
        duration: '6 год 0 хв',
        temperature: '+21°C',
        weather: 'Сонячно',
        wind: '4 м/с',
        pressure: '750 мм',
        imageUrl:
            'https://images.unsplash.com/photo-1499363536502-87642509e31b?auto=format&fit=crop&w=900&q=80',
        tackle: ['Воблер Rapala X-Rap 10'],
        catchItems: [
          CatchItem(fishName: 'Судак', weight: '3,4 кг', length: '60 см', time: '09:45'),
        ],
        notes: 'Тиха річка.',
      ),
      Trip(
        id: 'trip-4',
        waterBodyName: 'Київське водосховище',
        location: 'Київське водосховище',
        date: DateTime(2026, 5, 2, 5, 15),
        startTime: '05:15',
        endTime: '10:30',
        duration: '5 год 15 хв',
        temperature: '+16°C',
        weather: 'Дощ',
        wind: '3 м/с',
        pressure: '748 мм',
        imageUrl:
            'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=900&q=80',
        tackle: ['Lucky John Tioga 3.5" Pearl'],
        catchItems: [
          CatchItem(fishName: 'Лящ', weight: '5,2 кг', length: '58 см', time: '08:00'),
        ],
        notes: 'Клювало на червяка.',
      ),
    ];
  }
}
