import 'package:cloud_firestore/cloud_firestore.dart';

class Tasting {
  final double aroma;
  final double flavor;
  final double acidity;
  final double body;
  final double sweetness;
  final double overall;
  final String? notes;
  final DateTime date;
  final String? id;

  Tasting({
    required this.aroma,
    required this.flavor, 
    required this.acidity,
    required this.body,
    required this.sweetness,
    required this.overall,
    this.notes,
    required this.date,
    this.id,
  });

  // Convert Tasting to JSON
  Map<String, dynamic> toJson() {
    return {
      'aroma': aroma,
      'flavor': flavor,
      'acidity': acidity,
      'body': body,
      'sweetness': sweetness,
      'overall': overall,
      'notes': notes,
      'date': date.toIso8601String(),
    };
  }

  // Convert JSON to Tasting
  factory Tasting.fromJson(Map<String, dynamic> json, [String? id]) {
    return Tasting(
      aroma: json['aroma'].toDouble(),
      flavor: json['flavor'].toDouble(),
      acidity: json['acidity'].toDouble(),
      body: json['body'].toDouble(),
      sweetness: json['sweetness'].toDouble(),
      overall: json['overall'].toDouble(),
      notes: json['notes'],
      date: json['date'] is Timestamp 
          ? (json['date'] as Timestamp).toDate()
          : DateTime.parse(json['date']),
      id: id,
    );
  }

  // Create a copy of this Tasting with given fields replaced with new values
  Tasting copyWith({
    double? aroma,
    double? flavor,
    double? acidity,
    double? body,
    double? sweetness,
    double? overall,
    String? notes,
    DateTime? date,
    String? id,
  }) {
    return Tasting(
      aroma: aroma ?? this.aroma,
      flavor: flavor ?? this.flavor,
      acidity: acidity ?? this.acidity,
      body: body ?? this.body,
      sweetness: sweetness ?? this.sweetness,
      overall: overall ?? this.overall,
      notes: notes ?? this.notes,
      date: date ?? this.date,
      id: id ?? this.id,
    );
  }
}