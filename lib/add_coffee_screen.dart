// add_coffee_screen.dart
import 'package:flutter/material.dart';
import 'tasting_feedback_screen.dart';
import 'utils/label.dart';

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
              Column(
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
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
    );
  }
}