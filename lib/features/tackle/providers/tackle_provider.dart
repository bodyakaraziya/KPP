import 'package:flutter/foundation.dart';

import '../../../core/models/tackle.dart';

/// Управляє списком снастей: завантаження, створення, редагування, видалення
/// та filtracija за категорією (лаба №5, завдання 3.3–3.4).
class TackleProvider extends ChangeNotifier {
  final List<Tackle> _tackles = [];
  String? _filterCategory;
  String _searchQuery = '';

  /// Відфільтрований список для відображення (ураховує поточний фільтр та пошук).
  List<Tackle> get tackles => _applyFilter();
  /// Повний, невідфільтрований список — використовується для лічильників,
  /// щоб фільтр лише ховав записи, а не змінював цифри.
  List<Tackle> get allTackles => List.unmodifiable(_tackles);
  String? get filterCategory => _filterCategory;
  String get searchQuery => _searchQuery;

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
    // Якщо після видалення у поточній фільтровній категорії не залишилося записів — повертаємось на «Усі»
    if (_filterCategory != null && _filterCategory!.isNotEmpty) {
      if (!_tackles.any((t) => t.category == _filterCategory)) {
        _filterCategory = null;
      }
    }
    notifyListeners();
  }

  /// Збільшує лічильник виїздів для снасті з таким ім'ям.
  void incrementTripsCount(String tackleName) {
    final index = _tackles.indexWhere((t) => t.name == tackleName);
    if (index != -1) {
      _tackles[index] = _tackles[index].copyWith(tripsCount: _tackles[index].tripsCount + 1);
      notifyListeners();
    }
  }

  /// Зменшує лічильник виїздів для снасті з таким ім'ям (не нижче за 0).
  void decrementTripsCount(String tackleName) {
    final index = _tackles.indexWhere((t) => t.name == tackleName);
    if (index != -1) {
      _tackles[index] = _tackles[index].copyWith(
        tripsCount: (_tackles[index].tripsCount - 1).clamp(0, 100000),
      );
      notifyListeners();
    }
  }

  void setFilterCategory(String? value) {
    _filterCategory = value;
    notifyListeners();
  }

  void setSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  List<Tackle> _applyFilter() {
    var result = _tackles;
    if (_filterCategory != null && _filterCategory!.isNotEmpty) {
      result = result.where((t) => t.category == _filterCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((t) => t.name.toLowerCase().contains(q)).toList();
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
        tripsCount: 1,
      ),
      Tackle(
        id: 'tackle-2',
        category: 'Котушка',
        name: 'Shimano Nasci C3000',
        notes: 'Передавальне число 6.2:1. Бездоганна намотка.',
        tripsCount: 1,
      ),
      Tackle(
        id: 'tackle-3',
        category: 'Вудка',
        name: 'Brain Apex Feeder 3.6м',
        notes: 'Фідерне вудилище, тест до 90г.',
        tripsCount: 1,
      ),
      Tackle(
        id: 'tackle-4',
        category: 'Приманка',
        name: 'Lucky John Tioga 3.5" Pearl',
        notes: 'Їстівний силікон для джигу на судака та щуку.',
        tripsCount: 1,
      ),
      Tackle(
        id: 'tackle-5',
        category: 'Приманка',
        name: 'Воблер Rapala X-Rap 10',
        notes: 'Суспендер для твічингу на глибині 1.2–1.8м.',
        tripsCount: 1,
      ),
      Tackle(
        id: 'tackle-6',
        category: 'Наживка',
        name: 'Helicopter Rig з кукурудзою',
        notes: 'Монтаж для лову коропа та великого ляща.',
        tripsCount: 0,
      ),
      Tackle(
        id: 'tackle-7',
        category: 'Наживка',
        name: "Черв'як дощовий",
        notes: 'Універсальна наживка для поплавця та фідера.',
        tripsCount: 0,
      ),
    ];
  }
}
