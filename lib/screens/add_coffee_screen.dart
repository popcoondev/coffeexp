// add_coffee_screen.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'tasting_feedback_screen.dart';
import '../widgets/label.dart';

class AddCoffeeScreen extends StatefulWidget {
  @override
  _AddCoffeeScreenState createState() => _AddCoffeeScreenState();
}

class _AddCoffeeScreenState extends State<AddCoffeeScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _coffeeName;
  String? _origin;
  String? _area;
  String? _variety;
  String? _process;
  String? _farm;
  String? _storeName;
  String? _storeLocation;
  String? _storeWebsite;
  String? _roastLevel;
  DateTime? _roastDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Coffee'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // コーヒー豆の情報
              Text('Coffee Bean Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(mainText: 'Coffee Name', subText: 'コーヒー名'),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the coffee name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _coffeeName = value;
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Label(mainText: 'Origin', subText: '原産国'),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the origin';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _origin = value;
                          },
                        ),
                        Label(mainText: 'Area', subText: 'エリア'),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the area';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _area = value;
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(0, 0), // 初期位置は仮のものです。実際の位置情報で更新する必要があります。
                          zoom: 2,
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          // 地図初期化時の処理
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(mainText: 'Variety', subText: '品種'),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the variety';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _variety = value;
                    },
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(mainText: 'Process', subText: 'プロセス'),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the process';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _process = value;
                    },
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(mainText: 'Farm', subText: '農園'),
                  TextFormField(
                    onSaved: (value) {
                      _farm = value;
                    },
                  ),
                ],
              ),

              SizedBox(height: 20),

              // 焙煎情報
              Text('Roast Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(mainText: 'Roast Level', subText: '焙煎レベル'),
                  TextFormField(
                    onSaved: (value) {
                      _roastLevel = value;
                    },
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(mainText: 'Roast Date', subText: '焙煎日'),
                  TextFormField(
                    onTap: () async {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      setState(() {
                        _roastDate = date;
                      });
                    },
                  ),
                ],
              ),

              SizedBox(height: 20),

              // 店舗情報
              Text('Store Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(mainText: 'Store Name', subText: '店舗名'),
                  TextFormField(
                    onSaved: (value) {
                      _storeName = value;
                    },
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(mainText: 'Store Location', subText: '店舗所在地'),
                  TextFormField(
                    onSaved: (value) {
                      _storeLocation = value;
                    },
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(mainText: 'Store Photo', subText: '店舗写真'),
                  Container(
                    height: 150,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: Center(child: Text('No Photo Selected')),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // 写真選択の実装予定
                    },
                    child: Text('Add Photo'),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(mainText: 'Store Map', subText: '店舗地図情報'),
                  Container(
                    height: 150,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: Center(child: Text('Map Not Available')),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // 地図情報の追加実装予定
                    },
                    child: Text('Add Map Information'),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(mainText: 'Store Website', subText: '店舗ウェブサイト'),
                  TextFormField(
                    onSaved: (value) {
                      _storeWebsite = value;
                    },
                  ),
                ],
              ),

              SizedBox(height: 20),

              // テイスティング情報のボタンに変更
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TastingFeedbackScreen()),
                  );
                },
                child: Text('Provide Tasting Feedback'),
              ),

              SizedBox(height: 20),

              // 保存ボタン
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Coffee added successfully')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 写真から情報を取得する処理を実装
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Extracting information from photo...')),
          );
        },
        child: Icon(Icons.camera_alt),
        tooltip: '写真から情報取得',
      ),
    );
  }
}