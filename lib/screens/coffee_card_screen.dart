//CoffeeCardScreen

import 'package:coffeexp/screens/add_coffee_screen.dart';
import 'package:coffeexp/screens/tasting_feedback_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:countries_world_map/data/countrycodes.dart';
import 'package:countries_world_map/data/maps/world_map.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:countries_world_map/countries_world_map.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/coffee.dart';
import '../models/tasting.dart';

class CoffeeCardScreen extends StatelessWidget {
  final Map<String, dynamic> coffeeData;

  CoffeeCardScreen({required this.coffeeData});

  @override
  Widget build(BuildContext context) {
    // 国名から国コードを取得
    String? countryName = coffeeData['originCountryName'];
    String? countryCode = coffeeData['originCountryCode'];
    String? instructions = getMapInstructions(countryCode);
    bool isFavorite = coffeeData['isFavorite'] ?? false;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(coffeeData['coffeeName'] ?? 'No name'),
        actions: [
          // お気に入りボタン
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: () {
              _toggleFavorite(context);
            },
          ),
          // 編集ボタン
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              // 編集画面に遷移
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddCoffeeScreen(documentId: coffeeData['documentId']),
                ),
              );
              // 編集後はホーム画面に戻る
              Navigator.pop(context);
            },
          ),
          // メニューボタン（シェア、削除など）
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'share':
                  _shareCoffeeInfo(context);
                  break;
                case 'delete':
                  _confirmDelete(context);
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share, color: Theme.of(context).primaryColor, size: 20),
                    SizedBox(width: 8),
                    Text('シェア'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Text('削除', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ヘッダー部分（焙煎度に基づく色の帯とメイン情報）
            _buildHeaderSection(),
            
            // 詳細情報セクション
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 基本情報
                  _buildInfoSection("基本情報", [
                    _buildInfoRow(Icons.emoji_nature, "品種", coffeeData['variety']),
                    _buildInfoRow(Icons.opacity, "精製方法", coffeeData['process']),
                    _buildInfoRow(Icons.landscape, "標高", 
                      coffeeData['altitude'] != null ? "${coffeeData['altitude']} m" : null),
                  ]),
                  
                  SizedBox(height: 16),
                  
                  // フレーバーノート
                  if (coffeeData['flavorNotes'] != null && coffeeData['flavorNotes'].toString().isNotEmpty)
                    _buildFlavorNotesSection(context),
                  
                  SizedBox(height: 16),
                  
                  // 焙煎情報
                  _buildInfoSection("焙煎情報", [
                    _buildInfoRow(Icons.local_fire_department, "焙煎度合い", coffeeData['roastLevel']),
                    _buildInfoRow(Icons.calendar_today, "焙煎日", coffeeData['roastDate']),
                  ]),
                  
                  SizedBox(height: 16),
                  
                  // 店舗情報
                  _buildInfoSection("購入情報", [
                    _buildInfoRow(Icons.store, "店舗名", coffeeData['storeName']),
                    _buildInfoRow(Icons.language, "Webサイト", coffeeData['storeWebsite'], isLink: true),
                  ]),
                  
                  SizedBox(height: 24),
                  
                  // 地図セクション
                  _buildMapSection(instructions),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Convert the Map to Coffee object
          final coffee = Coffee(
            coffeeName: coffeeData['coffeeName'] ?? '',
            originCountryName: coffeeData['originCountryName'],
            originCountryCode: coffeeData['originCountryCode'],
            region: coffeeData['region'],
            farm: coffeeData['farm'],
            altitude: coffeeData['altitude'],
            variety: coffeeData['variety'],
            process: coffeeData['process'],
            flavorNotes: coffeeData['flavorNotes'],
            storeName: coffeeData['storeName'],
            storeLocation: coffeeData['storeLocation'],
            storeWebsite: coffeeData['storeWebsite'],
            roastLevel: coffeeData['roastLevel'],
            roastDate: coffeeData['roastDate'],
            createdAt: coffeeData['createdAt'],
            updatedAt: coffeeData['updatedAt'],
            isFavorite: coffeeData['isFavorite'] ?? false,
            imageUrl: coffeeData['imageUrl'],
            tastings: coffeeData['tastings']?.map<Tasting>((t) => 
              Tasting.fromJson(t)).toList(),
          );
          
          // Launch tasting screen and wait for result
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TastingFeedbackScreen(
                coffee: coffee,
                coffeeId: coffeeData['documentId'],
                previousTastings: coffee.tastings,
              ),
            ),
          );
          
          // If we got a result back (refresh needed), refresh the screen
          if (result == true) {
            // Refresh the coffee data
            FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('coffees')
              .doc(coffeeData['documentId'])
              .get()
              .then((doc) {
                if (doc.exists) {
                  // Update the coffeeData with new data
                  final newData = doc.data()!;
                  newData['documentId'] = coffeeData['documentId'];
                  coffeeData.addAll(newData);
                  
                  // Force UI update
                  (context as Element).markNeedsBuild();
                }
              });
          }
        },
        icon: const Icon(Icons.rate_review),
        label: const Text('テイスティングノート'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
  
  // ヘッダーセクション（焙煎度に基づく色の帯）
  Widget _buildHeaderSection() {
    Color roastColor = _getRoastLevelColor(coffeeData['roastLevel']);
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: roastColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // コーヒー名
          Text(
            coffeeData['coffeeName'] ?? 'No name',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          
          // 原産国と地域
          Row(
            children: [
              Icon(Icons.place, color: Colors.white.withOpacity(0.9), size: 18),
              SizedBox(width: 6),
              Text(
                '${coffeeData['originCountryName'] ?? ''}${coffeeData['region'] != null ? ', ${coffeeData['region']}' : ''}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 4),
          
          // 農園名
          if (coffeeData['farm'] != null && coffeeData['farm'].toString().isNotEmpty)
            Row(
              children: [
                Icon(Icons.home_work, color: Colors.white.withOpacity(0.9), size: 18),
                SizedBox(width: 6),
                Text(
                  coffeeData['farm'] ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
  
  // フレーバーノートセクション
  Widget _buildFlavorNotesSection(BuildContext context) {
    List<String> flavors = (coffeeData['flavorNotes'] ?? '').toString().split(',');
    flavors = flavors.map((f) => f.trim()).where((f) => f.isNotEmpty).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "フレーバーノート",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: flavors.map((flavor) => _buildFlavorChip(flavor, context)).toList(),
        ),
      ],
    );
  }
  
  // フレーバーチップ
  Widget _buildFlavorChip(String flavor, BuildContext context) {
    return Chip(
      backgroundColor: Color(0xFFECECEC),
      label: Text(
        flavor,
        style: TextStyle(fontSize: 14),
      ),
      avatar: Icon(
        _getFlavorIcon(flavor, context),
        size: 16,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
  
  // フレーバーに応じたアイコンを返す
  IconData _getFlavorIcon(String flavor, BuildContext context) {
    flavor = flavor.toLowerCase();
    
    if (flavor.contains('chocolate') || flavor.contains('チョコレート') || flavor.contains('ココア')) {
      return Icons.cookie;
    } else if (flavor.contains('berry') || flavor.contains('ベリー') || flavor.contains('strawberry') || flavor.contains('イチゴ')) {
      return Icons.restaurant;
    } else if (flavor.contains('fruit') || flavor.contains('フルーツ') || flavor.contains('リンゴ') || flavor.contains('apple')) {
      return Icons.apple;
    } else if (flavor.contains('floral') || flavor.contains('花')) {
      return Icons.local_florist;
    } else if (flavor.contains('citrus') || flavor.contains('柑橘')) {
      return Icons.brightness_5;
    } else if (flavor.contains('nut') || flavor.contains('ナッツ')) {
      return Icons.spa;
    } else if (flavor.contains('spice') || flavor.contains('スパイス')) {
      return Icons.whatshot;
    }
    
    return Icons.star;
  }
  
  // 情報セクション
  Widget _buildInfoSection(String title, List<Widget> rows) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        ...rows,
      ],
    );
  }
  
  // 情報の行
  Widget _buildInfoRow(IconData icon, String label, String? value, {bool isLink = false}) {
    if (value == null || value.isEmpty) {
      value = '-';
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[800],
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: isLink && value != '-' 
              ? Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () async {
                      // URLを開く処理
                      final Uri url = Uri.parse(value!);  // Force unwrap since we know it's not '-' or null
                      try {
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('URLを開けませんでした: $value')),
                            );
                          }
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('エラー: $e')),
                          );
                        }
                      }
                    },
                    child: Text(
                      value!,  // Force unwrap since we know it's not null
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  );
                },
              )
              : Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
          ),
        ],
      ),
    );
  }
  
  // 地図セクション
  Widget _buildMapSection(String? instructions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "原産国",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: instructions != null && instructions.isNotEmpty
            ? SimpleMap(
                instructions: instructions,
                defaultColor: _getMapColor(coffeeData['originCountryName']),
                fit: BoxFit.contain,
                countryBorder: CountryBorder(
                  color: Colors.black,
                  width: 1,
                ),
              )
            : Center(
                child: Text(
                  '地図データがありません',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
        ),
      ],
    );
  }
  
  // 原産国に応じた色を返す
  Color _getMapColor(String? countryName) {
    if (countryName == null) return Color(0xFF00A896);
    
    countryName = countryName.toLowerCase();
    
    if (countryName.contains('エチオピア') || countryName.contains('ethiopia')) {
      return Color(0xFF9B4F0F); // エチオピア：深いブラウン
    } else if (countryName.contains('コロンビア') || countryName.contains('colombia')) {
      return Color(0xFFD4AF37); // コロンビア：ゴールド
    } else if (countryName.contains('ブラジル') || countryName.contains('brazil')) {
      return Color(0xFF00A896); // ブラジル：ターコイズ
    } else if (countryName.contains('グアテマラ') || countryName.contains('guatemala')) {
      return Color(0xFF6A8D73); // グアテマラ：グリーン
    } else if (countryName.contains('ケニア') || countryName.contains('kenya')) {
      return Color(0xFFDB5461); // ケニア：レッド
    } else if (countryName.contains('コスタリカ') || countryName.contains('costa rica')) {
      return Color(0xFF3D5467); // コスタリカ：ブルー
    } else if (countryName.contains('パナマ') || countryName.contains('panama')) {
      return Color(0xFFE3B505); // パナマ：イエロー
    }
    
    return Color(0xFF00A896); // デフォルト色
  }
  
  // 焙煎度合いに基づく色を返す
  Color _getRoastLevelColor(String? roastLevel) {
    if (roastLevel == null) return Colors.brown;
    
    switch (roastLevel.toLowerCase()) {
      case 'light':
      case 'ライト':
      case 'ライトロースト':
        return Color(0xFFC8A780);
      case 'medium light':
      case 'ミディアムライト':
        return Color(0xFFB38867);
      case 'medium':
      case 'ミディアム':
      case 'ミディアムロースト':
        return Color(0xFF9F744D);
      case 'medium dark':
      case 'ミディアムダーク':
        return Color(0xFF8B5C34);
      case 'dark':
      case 'ダーク':
      case 'ダークロースト':
        return Color(0xFF77441B);
      default:
        return Colors.brown;
    }
  }
  
  // お気に入り状態を切り替える
  void _toggleFavorite(BuildContext context) {
    bool currentStatus = coffeeData['isFavorite'] ?? false;
    String documentId = coffeeData['documentId'];
    
    FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('coffees')
      .doc(documentId)
      .update({
        'isFavorite': !currentStatus,
        'updatedAt': DateTime.now().toString(),
      }).then((_) {
        // ローカルのcoffeeDataを更新
        coffeeData['isFavorite'] = !currentStatus;
        
        // UI更新のためにsetStateを呼ぶ
        (context as Element).markNeedsBuild();
        
        // フィードバックを表示
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              currentStatus ? 'お気に入りから削除しました' : 'お気に入りに追加しました'
            ),
            duration: Duration(seconds: 1),
          ),
        );
      });
  }
  
  // コーヒー情報をシェアする
  void _shareCoffeeInfo(BuildContext context) {
    String shareText = '''
【コーヒー情報】
${ coffeeData['coffeeName'] ?? 'No name' }
原産国: ${ coffeeData['originCountryName'] ?? '-' }${ coffeeData['region'] != null ? ', ${coffeeData['region']}' : '' }
品種: ${ coffeeData['variety'] ?? '-' }
精製方法: ${ coffeeData['process'] ?? '-' }
焙煎度合い: ${ coffeeData['roastLevel'] ?? '-' }
フレーバーノート: ${ coffeeData['flavorNotes'] ?? '-' }

#coffeexp
''';
    
    // Use Share.share to share the text
    Share.share(shareText);
  }
  
  // 削除確認ダイアログを表示
  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('このコーヒーを削除しますか？'),
          content: Text('「${coffeeData['coffeeName']}」を削除します。この操作は元に戻せません。'),
          actions: [
            TextButton(
              child: Text('キャンセル'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('削除', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                try {
                  String documentId = coffeeData['documentId'];
                  Map<String, dynamic> backupData = Map<String, dynamic>.from(coffeeData)..remove('documentId');
                  
                  await FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('coffees')
                    .doc(documentId)
                    .delete();
                  
                  Navigator.pop(context); // ダイアログを閉じる
                  Navigator.pop(context); // 詳細画面を閉じてリストに戻る
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('「${coffeeData['coffeeName']}」を削除しました'),
                      action: SnackBarAction(
                        label: '元に戻す',
                        onPressed: () {
                          // 削除したデータを復元
                          FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('coffees')
                            .add(backupData);
                        },
                      ),
                    ),
                  );
                } catch (e) {
                  print('Delete error: $e');
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('削除中にエラーが発生しました')),
                  );
                }
              },
            ),
          ],
        );
      },
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


