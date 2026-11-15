/// Модель приладки / снасті.
class Tackle {
  final String id;
  final String category;
  final String name;
  final String notes;
  final int tripsCount;

  Tackle({
    required this.id,
    required this.category,
    required this.name,
    required this.notes,
    this.tripsCount = 0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'name': name,
        'notes': notes,
        'tripsCount': tripsCount,
      };

  factory Tackle.fromJson(Map<String, dynamic> json) => Tackle(
        id: json['id'] as String,
        category: json['category'] as String,
        name: json['name'] as String,
        notes: json['notes'] as String,
        tripsCount: json['tripsCount'] as int? ?? 0,
      );

  Tackle copyWith({
    String? id,
    String? category,
    String? name,
    String? notes,
    int? tripsCount,
  }) {
    return Tackle(
      id: id ?? this.id,
      category: category ?? this.category,
      name: name ?? this.name,
      notes: notes ?? this.notes,
      tripsCount: tripsCount ?? this.tripsCount,
    );
  }
}
