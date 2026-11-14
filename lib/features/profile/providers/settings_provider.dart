import 'package:flutter/foundation.dart';

import '../../../core/services/local_storage_service.dart';

/// Управляє налаштуваннями інтерфейсу (тема, мова), які зберігаються
/// на пристрої через LocalStorageService (лаба №5, завдання 4).
class SettingsProvider extends ChangeNotifier {
  final LocalStorageService _storage;

  SettingsProvider(this._storage);

  bool get isDarkTheme => _storage.isDarkTheme;
  String get language => _storage.language;

  Future<void> setTheme(bool dark) async {
    _storage.isDarkTheme = dark;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _storage.isDarkTheme = !_storage.isDarkTheme;
    notifyListeners();
  }

  Future<void> setLanguage(String lang) async {
    _storage.language = lang;
    notifyListeners();
  }
}
