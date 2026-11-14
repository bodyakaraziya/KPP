import 'package:flutter/foundation.dart';

import '../../../core/models/tackle.dart';

/// Управляє списком снастей: завантаження, створення, редагування, видалення
/// та filtracija за категорією (лаба №5, завдання 3.3–3.4).
class TackleProvider extends ChangeNotifier {
  final List<Tackle> _tackles = [];
  String? _filterCategory;

  List<Tackle> get tackles => _applyFilter();
  String? get filterCategory => _filterCategory;

  /// Унікальні категорії снастей для фільтра.
  List<String> get categories {
    final names = _tackles.map((t) => t.category).toSet().toList()..sort();
    return names;
  }

  void loadTackle(List<Tackle> items) {
    _tackles
      ..clear()
      ..addAll(items);
    notifyListeners();
  }

  void addTackle(Tackle item) {
    _tackles.add(item);
    notifyListeners();
  }

  void updateTackle(String id, Tackle updated) {
    final index = _tackles.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tackles[index] = updated;
      notifyListeners();
    }
  }

  void deleteTackle(String id) {
    _tackles.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void setFilterCategory(String? value) {
    _filterCategory = value;
    notifyListeners();
  }

  List<Tackle> _applyFilter() {
    var result = _tackles;
    if (_filterCategory != null && _filterCategory!.isNotEmpty) {
      result = result.where((t) => t.category == _filterCategory).toList();
    }
    return result;
  }

  static List<Tackle> demoTackle() {
    return [
      Tackle(
        id: 'tackle-1',
        category: 'Вудка',
        name: 'Спіннинг Favorite X1 2.1м',
        notes: 'Тест 7–28г. Основний спіннинг для щуки.',
        tripsCount: 12,
      ),
      Tackle(
        id: 'tackle-2',
        category: 'Котушка',
        name: 'Shimano Nasci C3000',
        notes: 'Передавальне число 6.2:1. Бездоганна намотка.',
        tripsCount: 12,
      ),
      Tackle(
        id: 'tackle-3',
        category: 'Вудка',
        name: 'Brain Apex Feeder 3.6м',
        notes: 'Фідерне вудилище, тест до 90г.',
        tripsCount: 7,
      ),
      Tackle(
        id: 'tackle-4',
        category: 'Приманка',
        name: 'Lucky John Tioga 3.5" Pearl',
        notes: 'Їстівний силікон для джигу на судака та щуку.',
        tripsCount: 9,
      ),
      Tackle(
        id: 'tackle-5',
        category: 'Приманка',
        name: 'Воблер Rapala X-Rap 10',
        notes: 'Суспендер для твічингу на глибині 1.2–1.8м.',
        tripsCount: 5,
      ),
      Tackle(
        id: 'tackle-6',
        category: 'Наживка',
        name: 'Helicopter Rig з кукурудзою',
        notes: 'Монтаж для лову коропа та великого ляща.',
        tripsCount: 4,
      ),
      Tackle(
        id: 'tackle-7',
        category: 'Наживка',
        name: "Черв'як дощовий",
        notes: 'Універсальна наживка для поплавця та фідера.',
        tripsCount: 6,
      ),
    ];
  }
}
