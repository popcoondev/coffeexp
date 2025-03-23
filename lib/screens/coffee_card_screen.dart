//CoffeeCardScreen

import 'package:coffeexp/screens/add_coffee_screen.dart';
import 'package:countries_world_map/data/countrycodes.dart';
import 'package:countries_world_map/data/maps/world_map.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:countries_world_map/countries_world_map.dart';

class CoffeeCardScreen extends StatelessWidget {
  final Map<String, dynamic> coffeeData;

  CoffeeCardScreen({required this.coffeeData});

  @override
  Widget build(BuildContext context) {
    // 国名から国コードを取得
    String? countryName = coffeeData['originCountryName'];
    String? countryCode = coffeeData['originCountryCode'];
    // String? countryCode = countryName != null ? 
    // CountryCodesから国名を取得して国コードを取得
    String? instructions = getMapInstructions(countryCode);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(coffeeData['coffeeName'] ?? 'No name'),
        // 編集ボタンを追加
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              // 編集画面に遷移
              print('Edit button pressed');
              print(coffeeData['documentId']);
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddCoffeeScreen(documentId: coffeeData['documentId']),
                ),
              );

              // 編集画面から戻ってきたら、ホーム画面に戻る
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text('Name: ${coffeeData['coffeeName'] ?? '-'}'),
                SizedBox(height: 16.0),
                Text('Country: ${coffeeData['originCountryName'] ?? '-'}'),
                Text('Region: ${coffeeData['originRegion'] ?? '-'}'),
                Text('Area: ${coffeeData['originArea'] ?? '-'}'),
                Text('Altitude: ${coffeeData['originAltitude'] ?? '-'} m'),
                SizedBox(height: 16.0),
                Text('Variety: ${coffeeData['variety'] ?? '-'}'),
                Text('Process: ${coffeeData['process'] ?? '-'}'),
                SizedBox(height: 16.0),
                Text('Flavor notes: ${coffeeData['flavorNotes'] ?? '-'}'),
                SizedBox(height: 16.0),
                Text('Roast level: ${coffeeData['roastLevel'] ?? '-'}'),
                Text('Roast date: ${coffeeData['roastDate'] ?? '-'}'),
                SizedBox(height: 16.0),
                Text('Store name: ${coffeeData['storeName'] ?? '-'}'),
                Text('Store website: ${coffeeData['storeWebsite'] ?? '-'}'),
                SizedBox(height: 16.0),
              ]),
              Container(
                // padding: //左と上に余白を追加
                  // EdgeInsets.only(left: 20.0, top: 20.0, right: 10.0, bottom: 10.0),
                  width: 200,
                  height: 200,
                child:Expanded(
                  child: SimpleMap(
                    instructions: instructions,
                    defaultColor: Colors.green,
                    fit: BoxFit.contain,
                    countryBorder: CountryBorder(
                      color: Colors.black,
                      width: 1,
                    ),
                    callback: (id, name, tapdetails) {      
                        print(id); 
                        print(name);
                        print(tapdetails);
                    },
                    onHover: (id, name, hoverdetails) {
                        print(id); 
                        print(name);
                        print(hoverdetails);
                    },
                    markers: [
                      //　エチオピア　グジ
                      SimpleMapMarker(
                        markerSize: Size(50, 50),
                        latLong: LatLong(latitude: 5.8167, longitude: 40.489673),
                        marker: //アイコンとテキストを表示
                          Container(
                            width: 500,
                            height: 500,
                            child: Row(
                              children: [
                                Icon(Icons.location_on, color: Colors.red),
                                Text('Gujji', style: TextStyle(fontSize: 20),),
                              ],
                            ),
                          ),
                      ),
                      SimpleMapMarker(
                        markerSize: Size(50, 50),
                        //　エチオピア　イルガチェフェ
                        latLong: LatLong(latitude: 6.6, longitude: 38.4161),
                        marker: //アイコンとテキストを表示
                          Container(
                            width: 500,
                            height: 500,
                            child: Row(
                              children: [
                                Icon(Icons.location_on, color: Colors.red),
                                Text('Yirgacheffe', style: TextStyle(fontSize: 20),),
                              ],
                            ),
                          ),
                      ),
                      //　エチオピア　ハラー
                      SimpleMapMarker(
                        markerSize: Size(50, 50),
                        latLong: LatLong(latitude: 9.3157, longitude: 40.489673),
                        marker: //アイコンとテキストを表示
                          Container(
                            width: 500,
                            height: 500,
                            child: Row(
                              children: [
                                Icon(Icons.location_on, color: Colors.red),
                                Text('Harrar', style: TextStyle(fontSize: 20),),
                              ],
                            ),
                          ),
                      ),
                    ],
                  ),  
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }



///lib/data/maps/countries以下のファイルからinstructionsを取得
// andorra.dart
// angola.dart
// argentina.dart
// armenia.dart
// australia.dart
// austria.dart
// azerbaijan.dart
// bahamas.dart
// bahrain.dart
// bangladesh.dart
// belarus.dart
// belgium.dart
// bhutan.dart
// bolivia.dart
// bosnia.dart
// botswana.dart
// brazil.dart
// brunei.dart
// bulgaria.dart
// burkina_faso.dart
// burundi.dart
// cameroon.dart
// canada.dart
// cape_verde.dart
// central_african_republic.dart
// chad.dart
// chile.dart
// china.dart
// colombia.dart
// congo_brazzaville.dart
// congo_dr.dart
// costa_rica.dart
// croatia.dart
// cuba.dart
// cyprus.dart
// czech_republic.dart
// denmark.dart
// djibouti.dart
// dominican_republic.dart
// ecuador.dart
// egypt.dart
// el_salvador.dart
// estonia.dart
// ethiopia.dart
// faroe_islands.dart
// finland.dart
// france.dart
// georgia.dart
// germany.dart
// greece.dart
// guatemala.dart
// guinea.dart
// haiti.dart
// honduras.dart
// hong_kong.dart
// hungary.dart
// india.dart
// indonesia.dart
// iran.dart
// iraq.dart
// ireland.dart
// israel.dart
// italy.dart
// ivory_coast.dart
// jamaica.dart
// japan.dart
// kazakhstan.dart
// kenya.dart
// kosovo.dart
// kyrgyzstan.dart
// laos.dart
// latvia.dart
// liechtenstein.dart
// lithuania.dart
// luxembourg.dart
// macedonia.dart
// malaysia.dart
// mali.dart
// malta.dart
// mexico.dart
// moldova.dart
// montenegro.dart
// morocco.dart
// mozambique.dart
// myanmar.dart
// namibia.dart
// nepal.dart
// netherlands.dart
// new_zealand.dart
// nicaragua.dart
// nigeria.dart
// norway.dart
// oman.dart
// pakistan.dart
// palestine.dart
// panama.dart
// paraguay.dart
// peru.dart
// philippinnes.dart
// poland.dart
// portugal.dart
// puerto_rico.dart
// qatar.dart
// romania.dart
// russia.dart
// rwanda.dart
// san_marino.dart
// saudi_arabia.dart
// serbia.dart
// sierra_leone.dart
// singapore.dart
// slovakia.dart
// slovenia.dart
// south_africa.dart
// south_korea.dart
// spain.dart
// sri_lanka.dart
// sudan.dart
// sweden.dart
// switzerland.dart
// syria.dart
// taiwan.dart
// tajikistan.dart
// thailand.dart
// turkey.dart
// uganda.dart
// ukraine.dart
// united_arab_emirates.dart
// united_kingdom.dart
// united_states.dart
// uruguay.dart
// uzbekistan.dart
// venezuela.dart
// vietnam.dart
// yemen.dart
// zambia.dart
// zimbabwe.dart
  String getMapInstructions(String? countryCode) {
    if (countryCode == null) {
      return '';
    }
    switch (countryCode) {
      case 'AD':
        return SMapAndorra.instructions;
      case 'AO':
        return SMapAngola.instructions;
      case 'AR':
        return SMapArgentina.instructions;
      case 'AM':
        return SMapArmenia.instructions;
      case 'AU':
        return SMapAustralia.instructions;
      case 'AT':
        return SMapAustria.instructions;
      case 'AZ':
        return SMapAzerbaijan.instructions;
      case 'BS':
        return SMapBahamas.instructions;
      case 'BH':
        return SMapBahrain.instructions;
      case 'BD':
        return SMapBangladesh.instructions;
      case 'BY':
        return SMapBelarus.instructions;
      case 'BE':
        return SMapBelgium.instructions;
      case 'BT':
        return SMapBhutan.instructions;
      case 'BO':
        return SMapBolivia.instructions;
      // case 'BA':
      //   return SMapBosnia.instructions;
      case 'BW':
        return SMapBotswana.instructions;
      case 'BR':
        return SMapBrazil.instructions;
      case 'BN':
        return SMapBrunei.instructions;
      case 'BG':
        return SMapBulgaria.instructions;
      case 'BF':
        return SMapBurkinaFaso.instructions;
      case 'BI':
        return SMapBurundi.instructions;
      case 'CM':
        return SMapCameroon.instructions;
      case 'CA':
        return SMapCanada.instructions;
      case 'CV':
        return SMapCapeVerde.instructions;
      case 'CF':
        return SMapCentralAfricanRepublic.instructions;
      case 'TD':
        return SMapChad.instructions;
      case 'CL':
        return SMapChile.instructions;
      case 'CN':
        return SMapChina.instructions;
      case 'CO':
        return SMapColombia.instructions;
      case 'CG':
        return SMapCongoBrazzaville.instructions;
      case 'CD':
        return SMapCongoDR.instructions;
      case 'CR':
        return SMapCostaRica.instructions;
      case 'HR':
        return SMapCroatia.instructions;
      case 'CU':
        return SMapCuba.instructions;
      case 'CY':
        return SMapCyprus.instructions;
      case 'CZ':
        return SMapCzechRepublic.instructions;
      case 'DK':
        return SMapDenmark.instructions;
      case 'DJ':
        return SMapDjibouti.instructions;
      case 'DO':
        return SMapDominicanRepublic.instructions;
      case 'EC':
        return SMapEcuador.instructions;
      case 'EG':
        return SMapEgypt.instructions;
      case 'SV':
        return SMapElSalvador.instructions;
      case 'EE':
        return SMapEstonia.instructions;
      case 'ET':
        return SMapEthiopia.instructions;
      case 'FO':
        return SMapFaroeIslands.instructions;
      case 'FI':
        return SMapFinland.instructions;
      case 'FR':
        return SMapFrance.instructions;
      case 'GE':
        return SMapGeorgia.instructions;
      case 'DE':
        return SMapGermany.instructions;
      case 'GR':
        return SMapGreece.instructions;
      case 'GT':
        return SMapGuatemala.instructions;
      case 'GN':
        return SMapGuinea.instructions;
      case 'HT':
        return SMapHaiti.instructions;
      case 'HN':
        return SMapHonduras.instructions;
      case 'HK':
        return SMapHongKong.instructions;
      case 'HU':
        return SMapHungary.instructions;
      case 'IN':
        return SMapIndia.instructions;
      case 'ID':
        return SMapIndonesia.instructions;
      case 'IR':
        return SMapIran.instructions;
      case 'IQ':
        return SMapIraq.instructions;
      case 'IE':
        return SMapIreland.instructions;
      case 'IL':
        return SMapIsrael.instructions;
      case 'IT':
        return SMapItaly.instructions;
      case 'CI':
        return SMapIvoryCoast.instructions;
      case 'JM':
        return SMapJamaica.instructions;
      case 'JP':
        return SMapJapan.instructions;
      case 'KZ':
        return SMapKazakhstan.instructions;
      case 'KE':
        return SMapKenya.instructions;
      case 'XK':
        return SMapKosovo.instructions;
      case 'KG':
        return SMapKyrgyzstan.instructions;
      case 'LA':
        return SMapLaos.instructions;
      case 'LV':
        return SMapLatvia.instructions;
      case 'LI':
        return SMapLiechtenstein.instructions;
      case 'LT':
        return SMapLithuania.instructions;
      case 'LU':
        return SMapLuxembourg.instructions;
      case 'MK':
        return SMapMacedonia.instructions;
      case 'MY':
        return SMapMalaysia.instructions;
      case 'ML':
        return SMapMali.instructions;
      case 'MT':
        return SMapMalta.instructions;
      case 'MX':
        return SMapMexico.instructions;
      case 'MD':
        return SMapMoldova.instructions;
      case 'ME':
        return SMapMontenegro.instructions;
      case 'MA':
        return SMapMorocco.instructions;
      case 'MZ':
        return SMapMozambique.instructions;
      case 'MM':
        return SMapMyanmar.instructions;
      case 'NA':
        return SMapNamibia.instructions;
      case 'NP':
        return SMapNepal.instructions;
      case 'NL':
        return SMapNetherlands.instructions;
      case 'NZ':
        return SMapNewZealand.instructions;
      case 'NI':
        return SMapNicaragua.instructions;
      case 'NG':
        return SMapNigeria.instructions;
      case 'NO':
        return SMapNorway.instructions;
      case 'OM':
        return SMapOman.instructions;
      case 'PK':
        return SMapPakistan.instructions;
      case 'PS':
        return SMapPalestine.instructions;
      case 'PA':
        return SMapPanama.instructions;
      case 'PY':
        return SMapParaguay.instructions;
      case 'PE':
        return SMapPeru.instructions;
      case 'PH':
        return SMapPhilippines.instructions;
      case 'PL':
        return SMapPoland.instructions;
      case 'PT':
        return SMapPortugal.instructions;
      case 'PR':
        return SMapPuertoRico.instructions;
      case 'QA':
        return SMapQatar.instructions;
      case 'RO':
        return SMapRomania.instructions;
      case 'RU':
        return SMapRussia.instructions;
      case 'RW':
        return SMapRwanda.instructions;
      case 'SM':
        return SMapSanMarino.instructions;
      case 'SA':
        return SMapSaudiArabia.instructions;
      case 'RS':
        return SMapSerbia.instructions;
      case 'SL':
        return SMapSierraLeone.instructions;
      case 'SG':
        return SMapSingapore.instructions;
      case 'SK':
        return SMapSlovakia.instructions;
      case 'SI':
        return SMapSlovenia.instructions;
      case 'ZA':
        return SMapSouthAfrica.instructions;
      case 'KR':
        return SMapSouthKorea.instructions;
      case 'ES':
        return SMapSpain.instructions;
      case 'LK':
        return SMapSriLanka.instructions;
      case 'SD':
        return SMapSudan.instructions;
      case 'SE':
        return SMapSweden.instructions;
      case 'CH':
        return SMapSwitzerland.instructions;
      case 'SY':
        return SMapSyria.instructions;
      case 'TW':
        return SMapTaiwan.instructions;
      case 'TJ':
        return SMapTajikistan.instructions;
      case 'TH':
        return SMapThailand.instructions;
      case 'TR':
        return SMapTurkey.instructions;
      case 'UG':
        return SMapUganda.instructions;
      case 'UA':
        return SMapUkraine.instructions;
      case 'AE':
        return SMapUnitedArabEmirates.instructions;
      case 'GB':
        return SMapUnitedKingdom.instructions;
      case 'US':
        return SMapUnitedStates.instructions;
      case 'UY':
        return SMapUruguay.instructions;
      case 'UZ':
        return SMapUzbekistan.instructions;
      case 'VE':
        return SMapVenezuela.instructions;
      case 'VN':
        return SMapVietnam.instructions;
      case 'YE':
        return SMapYemen.instructions;
      case 'ZM':
        return SMapZambia.instructions;
      case 'ZW':
        return SMapZimbabwe.instructions;
      default:
        return '';
    }
  }
}


