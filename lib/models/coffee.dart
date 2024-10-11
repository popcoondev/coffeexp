class Coffee {
  String coffeeName;
  String? origin;
  String? region;
  String? farm;
  String? altitude;
  String? variety;
  String? process;
  String? storeName;
  String? storeLocation;
  String? storeWebsite;
  String? roastLevel;
  String? roastDate;

  Coffee({
    required this.coffeeName,
    this.origin,
    this.region,
    this.farm,
    this.altitude,
    this.variety,
    this.process,
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
      'farm': farm,
      'altitude': altitude,
      'variety': variety,
      'process': process,
      'storeName': storeName,
      'storeLocation': storeLocation,
      'storeWebsite': storeWebsite,
      'roastLevel': roastLevel,
      'roastDate': roastDate,
    };
  }
}
