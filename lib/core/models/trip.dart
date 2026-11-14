import 'package:fishlog/core/models/catch_item.dart';

/// Модель одного рибальського виїзду (додаткове завдання №2 і №3 лаби №5).
class Trip {
  final String id;
  final String waterBodyName;
  final String location;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String duration;
  final String temperature;
  final String weather;
  final String wind;
  final String pressure;
  final String imageUrl;
  final List<String> tackle;
  final List<CatchItem> catchItems;
  final String notes;

  Trip({
    required this.id,
    required this.waterBodyName,
    required this.location,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.temperature,
    required this.weather,
    required this.wind,
    required this.pressure,
    required this.imageUrl,
    this.tackle = const [],
    this.catchItems = const [],
    this.notes = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'waterBodyName': waterBodyName,
        'location': location,
        'date': date.toIso8601String(),
        'startTime': startTime,
        'endTime': endTime,
        'duration': duration,
        'temperature': temperature,
        'weather': weather,
        'wind': wind,
        'pressure': pressure,
        'imageUrl': imageUrl,
        'tackle': tackle,
        'catchItems': catchItems.map((e) => e.toJson()).toList(),
        'notes': notes,
      };

  factory Trip.fromJson(Map<String, dynamic> json) => Trip(
        id: json['id'] as String,
        waterBodyName: json['waterBodyName'] as String,
        location: json['location'] as String,
        date: DateTime.parse(json['date'] as String),
        startTime: json['startTime'] as String,
        endTime: json['endTime'] as String,
        duration: json['duration'] as String,
        temperature: json['temperature'] as String,
        weather: json['weather'] as String,
        wind: json['wind'] as String,
        pressure: json['pressure'] as String,
        imageUrl: json['imageUrl'] as String,
        tackle: List<String>.from(json['tackle'] as List? ?? []),
        catchItems: (json['catchItems'] as List? ?? [])
            .map((e) => CatchItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        notes: json['notes'] as String? ?? '',
      );
}
