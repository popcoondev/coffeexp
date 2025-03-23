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
    };
  }
}
