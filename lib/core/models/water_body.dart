/// Модель водойми (озеро, річка, затока тощо).
class WaterBody {
  final String id;
  final String name;
  final String type;
  final String location;
  final String notes;
  final String imageUrl;
  final int tripsCount;

  WaterBody({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.notes,
    required this.imageUrl,
    this.tripsCount = 0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'location': location,
        'notes': notes,
        'imageUrl': imageUrl,
        'tripsCount': tripsCount,
      };

  factory WaterBody.fromJson(Map<String, dynamic> json) => WaterBody(
        id: json['id'] as String,
        name: json['name'] as String,
        type: json['type'] as String,
        location: json['location'] as String,
        notes: json['notes'] as String,
        imageUrl: json['imageUrl'] as String,
        tripsCount: json['tripsCount'] as int? ?? 0,
      );
}
