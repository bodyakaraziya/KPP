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
}
