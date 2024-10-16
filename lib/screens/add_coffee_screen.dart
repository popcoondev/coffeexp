// add_coffee_screen.dart
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/coffee.dart';
import '../utils/countrys.dart';
import '../utils/strings.dart';
import 'tasting_feedback_screen.dart';
import '../widgets/label.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCoffeeScreen extends StatefulWidget {
  String? documentId;

  AddCoffeeScreen({this.documentId});

  @override
  _AddCoffeeScreenState createState() => _AddCoffeeScreenState();
}

class _AddCoffeeScreenState extends State<AddCoffeeScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _coffeeName;
  String? _origin;
  String? _originCode;
  String? _region;
  String? _farm;
  String? _altitude;
  String? _variety;
  String? _process;
  String? _storeName;
  String? _storeLocation;
  String? _storeWebsite;
  String? _roastLevel;
  String? _roastDate;
  final _originController = TextEditingController();
  final _roastDateController = TextEditingController();
  final _processController = TextEditingController();
  final _varietyController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final String testUid = 'test_user_123';
    User? user;

    //　テストユーザーを作成
    void createUser(String userId) async {
      print('Creating user with ID: $userId...');
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      try {
        await firestore.collection('users').doc(userId).set({
          'name': 'Test User',
          'email': 'test_user@example.com',
        });
        print('User created successfully.');
      } catch (e) {
        print('Failed to create user: $e');
      }
   }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // ユーザーがログインしていない場合はログイン画面に遷移
      if (FirebaseAuth.instance.currentUser == null) {
        print('User is not signed in');
        Navigator.pushReplacementNamed(context, '/login_signup');
      } else {
        print('User is signed in as ${FirebaseAuth.instance.currentUser!.email}');
        user = FirebaseAuth.instance.currentUser;
      }
    });

    if (widget.documentId != null) {
      fetchCoffeeData(widget.documentId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    // createUser(testUid);
    // fetchUserData(testUid);

    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.addCofffeScreenAppBarTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // コーヒー豆の情報
              Text(Strings.addCofffeScreenCoffeeBeanLabel, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(mainText: Strings.addCofffeScreenCofeeNameFormLabel, 
                    subText: Strings.addCofffeScreenCofeeNameFormLabelSub, isRequired: true),
                  TextFormField(
                    validator: (value) {
                      print('validator: $value');
                      if (value == null || value.isEmpty) {
                        return Strings.addCofffeScreenCofeeNameFormError;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      print('onSaved: $value');
                      _coffeeName = value;
                    },
                    initialValue: '',
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(mainText: Strings.addCofffeScreenCountryFormLabel, subText: Strings.addCofffeScreenCountryFormLabelSub),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                    children: [
                      Expanded(child:
                        TextFormField(
                          validator: (value) {
                            return null;
                          },
                          onSaved: (value) {
                            print('onSaved: $value');
                            _origin = value;
                          },
                          controller: _originController,
                          onChanged: (value) {
                            _origin = value;
                            _originCode = '';

                          },
                        ),
                      ),
                      CountryPicker(),
                      
                    ],
                  ),
                  Label(mainText: Strings.addCofffeScreenRegionFormLabel, subText: Strings.addCofffeScreenRegionFormLabelSub),
                  TextFormField(
                    validator: (value) {
                      return null;
                    },
                    onSaved: (value) {
                      print('onSaved: $value');
                      _region = value;
                    },
                  ),
                  Label(mainText: Strings.addCofffeScreenFarmFormLabel, subText: Strings.addCofffeScreenFarmFormLabelSub),
                  TextFormField(
                    validator: (value) {
                      return null;
                    },
                    onSaved: (value) {
                      print('onSaved: $value');
                      _farm = value;
                    },
                  ),
                  Label(mainText: Strings.AddCoffeeScreenAltitudeFormLabel, subText: Strings.AddCoffeeScreenAltitudeFormLabelSub),
                  TextFormField(
                    validator: (value) {
                      return null;
                    },
                    onSaved: (value) {
                      print('onSaved: $value');
                      _altitude = value;
                    },
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(mainText: Strings.AddCoffeeScreenVarietyFormLabel, subText: Strings.AddCoffeeScreenVarietyFormLabelSub),
                  Row(children: [
                    Expanded(child:
                      TextFormField(
                        validator: (value) {
                          return null;
                        },
                        onSaved: (value) {
                          print('onSaved: $value');
                          _variety = value;
                        },
                        controller: _varietyController,
                      ),
                    ),
                  //品種選択ダイアログ
                  varietySelectButton(context),
                  ],),
                  SizedBox(height: 10),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(mainText: Strings.AddCoffeeScreenProcessFormLabel, subText: Strings.AddCoffeeScreenProcessFormLabelSub),
                  Row(children: [
                    Expanded(child: 
                      TextFormField(
                        validator: (value) {
                        return null;
                        },
                        onSaved: (value) {
                        print('onSaved: $value');
                        _process = value;
                        },
                        controller: _processController,
                      ),
                    ),
                    //プロセス選択ダイアログ
                    processSelectButton(context),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),

              // 焙煎情報
              Text(Strings.addCofffeScreenRoastInformationLabel, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(mainText: Strings.AddCoffeeScreenRoastLevelFormLabel, subText: Strings.AddCoffeeScreenRoastLevelFormLabelSub),
                  Row(
                  children: [
                    Expanded(
                    child: TextFormField(
                      onSaved: (value) {
                      _roastLevel = value;
                      },
                    ),
                    ),
                    roastLevelSelectButton(context),
                  ],
                  ),
                ],
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(mainText: Strings.AddCoffeeScreenRoastDateFormLabel, subText: Strings.AddCoffeeScreenRoastDateFormLabelSub),
                  TextFormField(
                    // decoration: const InputDecoration(
                    //   hintText: 'YYYY/MM/DD',
                    // ),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      print('Roast Date: $date');
                      setState(() {
                        if(date != null) {
                          //yyyy/MM/dd形式に変換 0埋め
                          String formattedDate = '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
                          _roastDateController.text = formattedDate;
                          
                        }
                      });
                    },
                    validator: (value) {
                      // yyyy/MM/dd形式で入力されているかチェック
                      if (value != null) {
                        if (!RegExp(r'^\d{4}/\d{2}/\d{2}$').hasMatch(value)) {
                          return Strings.AddCoffeeScreenRoastDateFormError;
                        }
                      }
                      return null;
                      
                    },
                    controller: _roastDateController,
                    onSaved: (value) {
                      print('onSaved: $value');
                      _roastDate = value;
                    },
                  ),
                ],
              ),

              // SizedBox(height: 20),

              // // 店舗情報
              Text(Strings.addCofffeScreenStoreInformationLabel, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(mainText: Strings.AddCoffeeScreenStoreNameFormLabel, subText: Strings.AddCoffeeScreenStoreNameFormLabelSub),
                  TextFormField(
                    onSaved: (value) {
                      _storeName = value;
                    },
                  ),
                ],
              ),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Label(mainText: 'Store Location', subText: '店舗所在地'),
              //     TextFormField(
              //       onSaved: (value) {
              //         _storeLocation = value;
              //       },
              //     ),
              //   ],
              // ),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Label(mainText: 'Store Photo', subText: '店舗写真'),
              //     Container(
              //       height: 150,
              //       width: double.infinity,
              //       color: Colors.grey[300],
              //       child: Center(child: Text('No Photo Selected')),
              //     ),
              //     ElevatedButton(
              //       onPressed: () {
              //         // 写真選択の実装予定
              //       },
              //       child: Text('Add Photo'),
              //     ),
              //   ],
              // ),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Label(mainText: 'Store Map', subText: '店舗地図情報'),
              //     Container(
              //       height: 150,
              //       width: double.infinity,
              //       color: Colors.grey[300],
              //       child: Center(child: Text('Map Not Available')),
              //     ),
              //     ElevatedButton(
              //       onPressed: () {
              //         // 地図情報の追加実装予定
              //       },
              //       child: Text('Add Map Information'),
              //     ),
              //   ],
              // ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(mainText: Strings.AddCoffeeScreenStoreWebSiteFormLabel, subText: Strings.AddCoffeeScreenStoreWebSiteFormLabelSub),
                  TextFormField(
                    onSaved: (value) {
                      _storeWebsite = value;
                    },
                  ),
                ],
              ),

              // SizedBox(height: 20),

              // // テイスティング情報のボタンに変更
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => TastingFeedbackScreen()),
              //     );
              //   },
              //   child: Text('Provide Tasting Feedback'),
              // ),

              // SizedBox(height: 20),

              // 保存ボタン
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) { // バリデーション成功
                    print('Form is valid. Saving data...');
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
                    _formKey.currentState!.save(); // フォームの値を保存
                    
                    print('Coffee Name: $_coffeeName');
                    // Coffeeモデルを作成
                    Coffee newCoffee = Coffee(
                      coffeeName: _coffeeName!,
                      origin: _origin,
                      region: _region,
                      farm: _farm,
                      altitude: _altitude,
                      variety: _variety,
                      process: _process,
                      storeName: _storeName,
                      // storeLocation: _storeLocation,
                      storeWebsite: _storeWebsite,
                      roastLevel: _roastLevel,
                      roastDate: _roastDate,
                    );
                    print('New Coffee: $newCoffee');

                    // Firestoreに保存
                    if (widget.documentId != null) {
                      updateCoffeeData(widget.documentId!, newCoffee);
                    } else {
                      addCoffeeData(newCoffee);
                    }                         
                  }
                  else {
                    print('Form is invalid. Cannot save data.');
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Validation Failed')));
                  }
                },
                child: Text(Strings.addCofffeScreenSaveButton),
              ),
            ],

          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            // 写真から情報を取得する処理を実装
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text('Extracting information from photo...')),
            // );
            createUser(testUid);
            fetchUserData(testUid);
          },
          child: Icon(Icons.camera_alt),
          tooltip: Strings.addCofffeScreenFloatingActionButtonToolTip,
        ),
      
    );
  }

  Widget CountryPicker() {
    //CountryCodePickerを使って国名から国コードを取得
    return CountryCodePicker(
      onChanged: (CountryCode countryCode) {
        print('onChanged: $countryCode');
        print('Country name: ${countryCode.name}');
        // _originを更新する
        setState(() {
          _originController.text = countryCode.localize(context).name!;
          _originCode = countryCode.code;
        });
      
      },
      initialSelection: '+0',
      showCountryOnly: true,
      showOnlyCountryWhenClosed: true,
      alignLeft: true,
      
      //有名なコーヒー国のみ
      favorite: const [
      // アフリカ:
        '+251', 'ET', //: エチオピア
        '+254', 'KE', //: ケニア
        '+255', 'TZ', //: タンザニア
        '+250', 'RW', //: ルワンダ        
      // 中南米:
        '+57', 'CO', //: コロンビア
        '+502', 'GT', //: グアテマラ
        '+503', 'SV', //: エルサルバドル
        '+507', 'PA', //: パナマ
      ],
      hideMainText: true,
      builder: (countryCode) {
        print('builder: ${countryCode?.dialCode}');
        // if (countryCode!.dialCode == '+0') {
          return TextButton(onPressed: null, 
            child: Text(Strings.addCofffeScreenCountryPickerLabel,
            //スタイルは文字色0xFF00A896でradius8のボタン
            style: TextStyle(color: Color(0xFF00A896), fontSize: 12,),
            ),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        },
        // return 
        // Container(
        //     padding: EdgeInsets.all(8.0),
        //     child:
        //     Row(
        //       children: <Widget>[
        //         Image.asset(
        //           countryCode.flagUri!,
        //           package: 'country_code_picker',
        //           width: 32.0,
        //           height: 32.0,
        //         ),
        //         SizedBox(width: 8.0),
        //         Text(countryCode.name!),
        //         SizedBox(width: 8.0),
                
        //       ],
        //     ),
        // );
                     
      // }, 
    );
  }


  Widget roastLevelSelectButton(BuildContext context) {
    var roastLevel = [
      Strings.addCofffeScreenRoastLevelPickerLight,
      Strings.addCofffeScreenRoastLevelPickerMedium,
      Strings.addCofffeScreenRoastLevelPickerDark,
      Strings.addCofffeScreenRoastLevelPickerCinnamon,
      Strings.addCofffeScreenRoastLevelPickerHigh,
      Strings.addCofffeScreenRoastLevelPickerCity,
      Strings.addCofffeScreenRoastLevelPickerFullCity,
      Strings.addCofffeScreenRoastLevelPickerItalian,
    ];

    return TextButton(
      onPressed: () {
        final select = showDialog(context: context, builder: (context) {
          return SimpleDialog(
            title: Text(Strings.addCofffeScreenRoastLevelPickerTitle),
            children: [
              //for inでリストを回してSimpleDialogOptionを作成
              for (var roast in roastLevel)
                SimpleDialogOption(
                  onPressed: () {
                    _roastLevel = roast;
                    Navigator.pop(context);
                  },
                  child: Text(roast),
                ),
            ],
          );
        });
      },
      child: Text(Strings.addCofffeScreenRoastLevelPickerLabel, style: TextStyle(fontSize: 12)),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      ),
    );
  }


  Widget varietySelectButton(BuildContext context) {
    var varietyList = [
      Strings.addCofffeScreenVarietyPickerTypica,
      Strings.addCofffeScreenVarietyPickerBourbon,
      Strings.addCofffeScreenVarietyPickerCaturra,
      Strings.addCofffeScreenVarietyPickerCatuai,
      Strings.addCofffeScreenVarietyPickerSL28,
      Strings.addCofffeScreenVarietyPickerSL34,
      Strings.addCofffeScreenVarietyPickerGeisha,
      Strings.addCofffeScreenVarietyPickerMundoNovo,
      Strings.addCofffeScreenVarietyPickerPacamara,
      Strings.addCofffeScreenVarietyPickerMaragogipe,
      Strings.addCofffeScreenVarietyPickerPacas,
      Strings.addCofffeScreenVarietyPickerHeirloom,
      Strings.addCofffeScreenVarietyPickerRobusta,
      
    ];
    return TextButton(
      onPressed: () {
        final select = showDialog(context: context, builder: (context) {
          return SimpleDialog(
            title: Text(Strings.addCofffeScreenVarietyPickerTitle),
            children: [
              //for inでリストを回してSimpleDialogOptionを作成
              for (var variety in varietyList)
                SimpleDialogOption(
                  onPressed: () {
                    _variety = variety;
                    _varietyController.text = _variety!;
                    Navigator.pop(context);
                  },
                  child: Text(variety),
                ),
            ],
          );
        });
      },
      child: Text(Strings.addCofffeScreenVarietyPickerLabel, style: TextStyle(fontSize: 12)),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      ),
    );
  }

  Widget processSelectButton(BuildContext context) {
    var processList = [
      Strings.addCofffeScreenProcessPickerWashed,
      Strings.addCofffeScreenProcessPickerNatural,
      Strings.addCofffeScreenProcessPickerHoney,
      Strings.addCofffeScreenProcessPickerAnaerobic,
      Strings.addCofffeScreenProcessPickerCarbonicMaceration,
      Strings.addCofffeScreenProcessPickerSemiWashed,
      Strings.addCofffeScreenProcessPickerFullyWashed,
      Strings.addCofffeScreenProcessPickerPulpedNatural,      
    ];
    return TextButton(
      onPressed: () {
        final select = showDialog(context: context, builder: (context) {
          return SimpleDialog(
            title: Text(Strings.addCofffeScreenProcessPickerTitle),
            children: [
              //for inでリストを回してSimpleDialogOptionを作成
              for (var process in processList)
                SimpleDialogOption(
                  onPressed: () {
                    _process = process;
                    _processController.text = _process!;
                    Navigator.pop(context);
                  },
                  child: Text(process),
                ),                
            ],
          );
        });
      },
      child: Text(Strings.addCofffeScreenProcessPickerLabel, style: TextStyle(fontSize: 12)),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      ),
    );
  }

  void addCoffeeData(Coffee newCoffee) {
    print('Adding new coffee...');
    _firestore.collection('users').doc(user!.uid).collection('coffees').add(newCoffee.toJson()).then((value) {
      print('Coffee added successfully. Doc id : ${value.id}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Coffee added successfully')),
      );
      Navigator.pop(context);
    }).catchError((error) {
      print('Failed to add coffee: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add coffee: $error')),
      );
    });
  }

  void updateCoffeeData(String documentId, Coffee newCoffee) {
    print('Updating coffee with id: $documentId');
    _firestore.collection('users').doc(user!.uid).collection('coffees').doc(documentId).update(newCoffee.toJson()).then((value) {
      print('Coffee updated successfully. Doc id : $documentId');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Coffee updated successfully')),
      );
      Navigator.pop(context);
    }).catchError((error) {
      print('Failed to update coffee: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update coffee: $error')),
      );
    });
  }

  void fetchCoffeeData(String documentId) {
    print('Fetching coffee data for documentId: $documentId...');
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      firestore.collection('users').doc(user!.uid).collection('coffees').doc(documentId).get().then((doc) {
        if (doc.exists) {
          Map<String, dynamic>? coffeeData = doc.data() as Map<String, dynamic>?;
          _coffeeName = coffeeData?['coffeeName'];
          _origin = coffeeData?['origin'];
          _region = coffeeData?['region'];
          _farm = coffeeData?['farm'];
          _altitude = coffeeData?['altitude'];
          _variety = coffeeData?['variety'];
          _process = coffeeData?['process'];
          // _storeName = coffeeData?['storeName'];
          // _storeLocation = coffeeData?['storeLocation'];
          // _storeWebsite = coffeeData?['storeWebsite'];
          // _roastLevel = coffeeData?['roastLevel'];
          // _roastDate = coffeeData?['roastDate'];

          print('Coffee Name: $_coffeeName');
          setState(() {});
        } else {
          print('Coffee not found for documentId: $documentId');
        }
      });
    } catch (e) {
      print('Failed to fetch coffee data: $e');
    }
  }

  void fetchUserData(String userId) async {
    print('Fetching user data for userId: $userId...');
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      DocumentSnapshot userSnapshot = await firestore.collection('users').doc(userId).get();
      print("Firestore get() completed.");

      if (userSnapshot.exists) {
        Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;
        String userName = userData?['name'] ?? 'Unknown';
        String email = userData?['email'] ?? 'Unknown';

        print("User Name: $userName, Email: $email");
      } else {
        print("User not found for userId: $userId");
      }
    } catch (e) {
      print("Failed to fetch user data: $e");
    }
  }


  void fetchUserCoffees(String userId) async {
    print('Fetching user coffees...');
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot coffeeSnapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('coffees')
          .get();

      if (coffeeSnapshot.docs.isNotEmpty) {
        for (var doc in coffeeSnapshot.docs) {
          Map<String, dynamic>? coffeeData = doc.data() as Map<String, dynamic>?;
          String coffeeName = coffeeData?['coffeeName'] ?? 'Unknown';
          String origin = coffeeData?['origin'] ?? 'Unknown';
          String roastLevel = coffeeData?['roastLevel'] ?? 'Unknown';

          print("Coffee Name: $coffeeName, Origin: $origin, Roast Level: $roastLevel");
        }
      } else {
        print("No coffees found for this user.");
      }
    } catch (e) {
      print("Failed to fetch coffee data: $e");
    }
  }
}