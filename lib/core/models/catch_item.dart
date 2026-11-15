/// Окрема позиція улову у межах одного виїзду.
class CatchItem {
  final String fishName;
  final String weight;
  final String length;
  final String time;
  final String imageUrl;

  CatchItem({
    required this.fishName,
    required this.weight,
    required this.length,
    required this.time,
    this.imageUrl = '',
  });

  Map<String, dynamic> toJson() => {
        'fishName': fishName,
        'weight': weight,
        'length': length,
        'time': time,
        'imageUrl': imageUrl,
      };

  factory CatchItem.fromJson(Map<String, dynamic> json) => CatchItem(
        fishName: json['fishName'] as String,
        weight: json['weight'] as String,
        length: json['length'] as String,
        time: json['time'] as String,
        imageUrl: json['imageUrl'] as String? ?? '',
      );

  /// Чисельне значення ваги для порівняння (до формату "5", "4,8", "5 кг").
  static double _weightValue(String w) {
    final cleaned = w.replaceAll(RegExp(r'[^0-9,\.]'), '').replaceAll(',', '.');
    return double.tryParse(cleaned) ?? 0;
  }

  /// Вага з одиницею виміру, без подвійного «кг».
  /// Храниться в CatchItem.weight вже разом із «кг» (наприклад, '4,8 кг'),
  /// тому додаємо « кг» тільки якщо рядка ще немає.
  static String formatWeight(String w) {
    final trimmed = w.trim();
    if (trimmed.isEmpty) return '';
    return trimmed.contains(RegExp(r'кг', caseSensitive: false))
        ? trimmed
        : '$trimmed кг';
  }

  /// Позиція улову з найбільшою вагою (або null, якщо список порожній).
  static CatchItem? maxByWeight(List<CatchItem> items) {
    if (items.isEmpty) return null;
    return items.reduce((a, b) => _weightValue(a.weight) >= _weightValue(b.weight)
        ? a
        : b);
  }
}
