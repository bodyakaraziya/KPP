import 'package:flutter/foundation.dart';

import '../../../core/models/water_body.dart';

/// Управляє списком водойм: завантаження, створення, редагування, видалення
/// та filtracija за типом (лаба №5, завдання 3.3–3.4).
///
/// Стан фільтрації НЕ зберігається в провайдері. Кожен екрані керує своїми
/// фільтрами локально та викликає [filterWaterBodies] для отримання
/// відфільтрованого списку.
class WaterBodiesProvider extends ChangeNotifier {
  final List<WaterBody> _waterBodies = [];

  /// Повний, невідфільтрований список водойм.
  List<WaterBody> get waterBodies => List.unmodifiable(_waterBodies);
  List<WaterBody> get allWaterBodies => List.unmodifiable(_waterBodies);
  int get totalCount => _waterBodies.length;

  /// Унікальні типи водойм для фільтра.
  List<String> get types {
    final names = _waterBodies.map((w) => w.type).toSet().toList()..sort();
    return names;
  }

  void loadWaterBodies(List<WaterBody> bodies) {
    _waterBodies
      ..clear()
      ..addAll(bodies);
    notifyListeners();
  }

  void addWaterBody(WaterBody body) {
    _waterBodies.add(body);
    notifyListeners();
  }

  void updateWaterBody(String id, WaterBody updated) {
    final index = _waterBodies.indexWhere((w) => w.id == id);
    if (index != -1) {
      _waterBodies[index] = updated;
      notifyListeners();
    }
  }

  void deleteWaterBody(String id) {
    _waterBodies.removeWhere((w) => w.id == id);
    notifyListeners();
  }

  /// Збільшує лічильник виїздів для водойми з таким ім'ям.
  void incrementTripsCount(String waterBodyName) {
    final index = _waterBodies.indexWhere((w) => w.name == waterBodyName);
    if (index != -1) {
      _waterBodies[index] = _waterBodies[index].copyWith(
        tripsCount: _waterBodies[index].tripsCount + 1,
      );
      notifyListeners();
    }
  }

  /// Зменшує лічильник виїздів для водойми з таким ім'ям (не нижче за 0).
  void decrementTripsCount(String waterBodyName) {
    final index = _waterBodies.indexWhere((w) => w.name == waterBodyName);
    if (index != -1) {
      _waterBodies[index] = _waterBodies[index].copyWith(
        tripsCount: (_waterBodies[index].tripsCount - 1).clamp(0, 100000),
      );
      notifyListeners();
    }
  }

  /// Фільтрує водойми за типом. Не зберігає стан фільтра.
  List<WaterBody> filterWaterBodies({String? type}) {
    var result = _waterBodies;
    if (type != null && type.isNotEmpty) {
      result = result.where((w) => w.type == type).toList();
    }
    return result;
  }

  static List<WaterBody> demoWaterBodies() {
    return [
      WaterBody(
        id: 'wb-1',
        name: 'Дніпровська затока',
        type: 'Річкова затока',
        location: 'Київська обл., Вишгородський р-н',
        notes: 'Глибина до 6 м, багато щуки в очереті.',
        imageUrl:
            'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=900&q=80',
        tripsCount: 2,
      ),
      WaterBody(
        id: 'wb-2',
        name: 'Озеро Біле',
        type: 'Озеро',
        location: 'Рівненська обл., Вараський р-н',
        notes:
            'Чиста вода, піщане дно. Гарний кльов окуня та щуки на світанку.',
        imageUrl:
            'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?auto=format&fit=crop&w=900&q=80',
        tripsCount: 1,
      ),
      WaterBody(
        id: 'wb-3',
        name: 'Річка Стугна',
        type: 'Річка',
        location: 'Київська обл., Обухівський р-н',
        notes: 'Тиха річка. Плотва та краснопірка.',
        imageUrl:
            'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=900&q=80',
        tripsCount: 1,
      ),
    ];
  }
}
