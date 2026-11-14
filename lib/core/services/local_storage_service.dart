import 'package:shared_preferences/shared_preferences.dart';

/// Одноразове сховище налаштувань програми на пристрої (SharedPreferences).
/// Використовується для збереження теми, мови та інших user preferences.
class LocalStorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get _instance {
    if (_prefs == null) {
      throw StateError(
        'LocalStorageService не ініціалізовано. Викличте LocalStorageService.init() перед runApp.',
      );
    }
    return _prefs!;
  }

  // Ключі
  static const String _themeKey = 'theme_is_dark';
  static const String _langKey = 'language_code';

  /// Чи увімкнена темна тема.
  bool get isDarkTheme => _instance.getBool(_themeKey) ?? false;
  set isDarkTheme(bool value) => _instance.setBool(_themeKey, value);

  /// Поточна мова інтерфейсу (наприклад 'УК' / 'EN').
  String get language => _instance.getString(_langKey) ?? 'УК';
  set language(String value) => _instance.setString(_langKey, value);

  /// Зберегти довільне рядкове значення.
  Future<bool> setString(String key, String value) =>
      _instance.setString(key, value);

  /// Зчитати довільне рядкове значення.
  String? getString(String key) => _instance.getString(key);

  /// Видалити значення за ключем.
  Future<bool> remove(String key) => _instance.remove(key);
}
