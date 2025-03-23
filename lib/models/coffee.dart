import 'tasting.dart';

class Coffee {
  String coffeeName; // コーヒー名
  String? originCountryName; // 生産国名
  String? originCountryCode; // 生産国コード ex. +81
  String? region; // 生産地域
  String? farm; // 生産農園農園 or プロデューサー
  String? altitude; // 標高(m)
  String? variety; // 品種
  String? process; // 加工法
  String? flavorNotes; // フレーバーノート ex. チョコレート、フルーティー
  String? storeName; // 購入店名
  String? storeLocation;  // 購入店住所
  String? storeWebsite; // 購入店ウェブサイト
  String? roastLevel;  // 焙煎度合い
  String? roastDate;  // 焙煎日
  String? createdAt;  // 作成日
  String? updatedAt;  // 更新日
  bool isFavorite; // お気に入り
  String? imageUrl; // 画像URL
  List<Tasting>? tastings; // テイスティング履歴

  Coffee({
    required this.coffeeName,
    this.originCountryName,
    this.originCountryCode,
    this.region,
    this.farm,
    this.altitude,
    this.variety,
    this.process,
    this.flavorNotes,
    this.storeName,
    this.storeLocation,
    this.storeWebsite,
    this.roastLevel,
    this.roastDate,
    this.createdAt,
    this.updatedAt,
    this.isFavorite = false,
    this.imageUrl,
    this.tastings,
  });

  Map<String, dynamic> toJson() {
    return {
      'coffeeName': coffeeName,
      'originCountryName': originCountryName,
      'originCountryCode': originCountryCode,
      'region': region,
      'farm': farm,
      'altitude': altitude,
      'variety': variety,
      'process': process,
      'flavorNotes': flavorNotes,
      'storeName': storeName,
      'storeLocation': storeLocation,
      'storeWebsite': storeWebsite,
      'roastLevel': roastLevel,
      'roastDate': roastDate,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isFavorite': isFavorite,
      'imageUrl': imageUrl,
      'tastings': tastings?.map((tasting) => tasting.toJson()).toList(),
    };
  }

  factory Coffee.fromJson(Map<String, dynamic> json, {String? id}) {
    List<Tasting>? tastingsList;
    if (json['tastings'] != null) {
      tastingsList = (json['tastings'] as List)
          .map((item) => Tasting.fromJson(item))
          .toList();
    }

    return Coffee(
      coffeeName: json['coffeeName'] ?? '',
      originCountryName: json['originCountryName'],
      originCountryCode: json['originCountryCode'],
      region: json['region'],
      farm: json['farm'],
      altitude: json['altitude'],
      variety: json['variety'],
      process: json['process'],
      flavorNotes: json['flavorNotes'],
      storeName: json['storeName'],
      storeLocation: json['storeLocation'],
      storeWebsite: json['storeWebsite'],
      roastLevel: json['roastLevel'],
      roastDate: json['roastDate'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      isFavorite: json['isFavorite'] ?? false,
      imageUrl: json['imageUrl'],
      tastings: tastingsList,
    );
  }

  // Add a new tasting to this coffee
  Coffee addTasting(Tasting tasting) {
    List<Tasting> updatedTastings = List<Tasting>.from(tastings ?? []);
    updatedTastings.add(tasting);
    
    return Coffee(
      coffeeName: coffeeName,
      originCountryName: originCountryName,
      originCountryCode: originCountryCode,
      region: region,
      farm: farm,
      altitude: altitude,
      variety: variety,
      process: process,
      flavorNotes: flavorNotes,
      storeName: storeName,
      storeLocation: storeLocation,
      storeWebsite: storeWebsite,
      roastLevel: roastLevel,
      roastDate: roastDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isFavorite: isFavorite,
      imageUrl: imageUrl,
      tastings: updatedTastings,
    );
  }

  // Create a copy of this Coffee with given fields replaced with new values
  Coffee copyWith({
    String? coffeeName,
    String? originCountryName,
    String? originCountryCode,
    String? region,
    String? farm,
    String? altitude,
    String? variety,
    String? process,
    String? flavorNotes,
    String? storeName,
    String? storeLocation,
    String? storeWebsite,
    String? roastLevel,
    String? roastDate,
    String? createdAt,
    String? updatedAt,
    bool? isFavorite,
    String? imageUrl,
    List<Tasting>? tastings,
  }) {
    return Coffee(
      coffeeName: coffeeName ?? this.coffeeName,
      originCountryName: originCountryName ?? this.originCountryName,
      originCountryCode: originCountryCode ?? this.originCountryCode,
      region: region ?? this.region,
      farm: farm ?? this.farm,
      altitude: altitude ?? this.altitude,
      variety: variety ?? this.variety,
      process: process ?? this.process,
      flavorNotes: flavorNotes ?? this.flavorNotes,
      storeName: storeName ?? this.storeName,
      storeLocation: storeLocation ?? this.storeLocation,
      storeWebsite: storeWebsite ?? this.storeWebsite,
      roastLevel: roastLevel ?? this.roastLevel,
      roastDate: roastDate ?? this.roastDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      imageUrl: imageUrl ?? this.imageUrl,
      tastings: tastings ?? this.tastings,
    );
  }
}