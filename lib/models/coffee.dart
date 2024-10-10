class Coffee {
  String coffeeName;
  String? origin;
  String? region;
  String? variety;
  String? process;
  String? farm;
  String? storeName;
  String? storeLocation;
  String? storeWebsite;
  String? roastLevel;
  DateTime? roastDate;

  Coffee({
    required this.coffeeName,
    this.origin,
    this.region,
    this.variety,
    this.process,
    this.farm,
    this.storeName,
    this.storeLocation,
    this.storeWebsite,
    this.roastLevel,
    this.roastDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'coffeeName': coffeeName,
      'origin': origin,
      'region': region,
      'variety': variety,
      'process': process,
      'farm': farm,
      'storeName': storeName,
      'storeLocation': storeLocation,
      'storeWebsite': storeWebsite,
      'roastLevel': roastLevel,
      'roastDate': roastDate?.toIso8601String(),
    };
  }
}
