import 'package:flutter/foundation.dart';

import '../../../core/models/water_body.dart';

/// Управляє списком водойм: завантаження, створення, редагування, видалення
/// та filtracija за типом (лаба №5, завдання 3.3–3.4).
class WaterBodiesProvider extends ChangeNotifier {
  final List<WaterBody> _waterBodies = [];
  String? _filterType;

  List<WaterBody> get waterBodies => _applyFilter();
  String? get filterType => _filterType;

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

  void setFilterType(String? value) {
    _filterType = value;
    notifyListeners();
  }

  List<WaterBody> _applyFilter() {
    var result = _waterBodies;
    if (_filterType != null && _filterType!.isNotEmpty) {
      result = result.where((w) => w.type == _filterType).toList();
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
