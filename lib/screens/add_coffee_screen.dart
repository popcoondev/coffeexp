// add_coffee_screen.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:html' as html;

import '../services/photo_analysis_service.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/coffee.dart';
import '../utils/countrys.dart';
import '../utils/strings.dart';
import 'tasting_feedback_screen.dart';
import '../widgets/label.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker_web/image_picker_web.dart';


class AddCoffeeScreen extends StatefulWidget {
  String? documentId;

  AddCoffeeScreen({this.documentId});

  @override
  _AddCoffeeScreenState createState() => _AddCoffeeScreenState();
}

class _AddCoffeeScreenState extends State<AddCoffeeScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _coffeeName;
  String? _originCountryName;
  String? _originCountryCode;
  String? _region;
  String? _farm;
  String? _altitude;
  String? _variety;
  String? _process;
  String? _flavorNotes;
  String? _storeName;
  String? _storeLocation;
  String? _storeWebsite;
  String? _roastLevel;
  String? _roastDate;
  String? _createdAt;
  String? _updatedAt;

  final _coffeeNameController = TextEditingController();
  final _originCountryController = TextEditingController();
  final _roastDateController = TextEditingController();
  final _roastLevelController = TextEditingController();
  final _processController = TextEditingController();
  final _varietyController = TextEditingController();
  final _regionController = TextEditingController();
  final _farmController = TextEditingController();
  final _altitudeController = TextEditingController();
  final _flavorNotesController = TextEditingController();
  final _storeNameController = TextEditingController();
  final _storeWebsiteController = TextEditingController();

  bool _isAnalyzing = false;
  final PhotoAnalysisService _photoAnalysisService = PhotoAnalysisService();

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
    print('AddCoffeeScreen: initState');
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

    print('Document ID: ${widget.documentId}');
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    onChanged: (value) {
                      print('onChanged: $value');
                      _coffeeName = value;
                    },
                    controller: _coffeeNameController,
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            return null;
                          },
                          onSaved: (value) {
                            print('onSaved: $value');
                            _originCountryName = value;
                          },
                          controller: _originCountryController,
                          onChanged: (value) {
                            _originCountryName = value;
                            _originCountryCode = '';

                          },
                        ),
                      ),
                      CountryPicker(),
                      
                    ],
                  ),
                  Label(mainText: Strings.addCofffeScreenRegionFormLabel, subText: Strings.addCofffeScreenRegionFormLabelSub),
                  TextFormField(
                    controller: _regionController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return null;
                    },
                    onSaved: (value) {
                      print('onSaved: $value');
                      _region = value;
                    },
                    onChanged: (value) {
                      _region = value;
                    },
                  ),
                  Label(mainText: Strings.addCofffeScreenFarmFormLabel, subText: Strings.addCofffeScreenFarmFormLabelSub),
                  TextFormField(
                    controller: _farmController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return null;
                    },
                    onSaved: (value) {
                      print('onSaved: $value');
                      _farm = value;
                    },
                    onChanged: (value) {
                      _farm = value;
                    },
                  ),
                  Label(mainText: Strings.AddCoffeeScreenAltitudeFormLabel, subText: Strings.AddCoffeeScreenAltitudeFormLabelSub),
                  TextFormField(
                    controller: _altitudeController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      return null;
                    },
                    onSaved: (value) {
                      print('onSaved: $value');
                      _altitude = value;
                    },
                    onChanged: (value) {
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(mainText: Strings.AddCoffeeScreenFlavorNotesFormLabel, subText: Strings.AddCoffeeScreenFlavorNotesFormLabelSub),
                  TextFormField(
                    controller: _flavorNotesController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    maxLines: 3,
                    validator: (value) {
                      // 200文字以内かチェック
                      if (value != null && value.length > 200) {
                        return Strings.AddCoffeeScreenFlavorNotesFormError;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _flavorNotes = value;
                    },
                    onChanged: (value) {
                      _flavorNotes = value;
                    },
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onSaved: (value) {
                          _roastLevel = value;
                        },
                        controller: _roastLevelController,
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      if (value != null && value.isNotEmpty) {
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

              SizedBox(height: 20),

              // // 店舗情報
              Text(Strings.addCofffeScreenStoreInformationLabel, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(mainText: Strings.AddCoffeeScreenStoreNameFormLabel, subText: Strings.AddCoffeeScreenStoreNameFormLabelSub),
                  TextFormField(
                    controller: _storeNameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onSaved: (value) {
                      _storeName = value;
                    },
                    onChanged: (value) {
                      _storeName = value;
                    },
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(mainText: Strings.AddCoffeeScreenStoreWebSiteFormLabel, subText: Strings.AddCoffeeScreenStoreWebSiteFormLabelSub),
                  TextFormField(
                    controller: _storeWebsiteController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.url,
                    onSaved: (value) {
                      _storeWebsite = value;
                    },
                    onChanged: (value) {
                      _storeWebsite = value;
                    },
                  ),
                ],
              ),

              SizedBox(height: 20),

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
              addCoffeeSaveButton(),
            ],

          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: _isAnalyzing ? null : () async {
            // 写真から情報を取得する処理を実装
            _pickImage();
          },
          backgroundColor: _isAnalyzing ? Colors.grey : null,
          child: _isAnalyzing 
            ? CircularProgressIndicator(color: Colors.white)
            : Icon(Icons.camera_alt),
          tooltip: _isAnalyzing 
            ? '画像解析中...' 
            : Strings.addCofffeScreenFloatingActionButtonToolTip,
        ),
      
    );
  }

  Future<void> _pickImage() async {
    setState(() {
      _isAnalyzing = true;
    });
    
    try {
      dynamic imageFile;
      
      // Webかモバイルかで処理を分岐
      if (kIsWeb) {
        print('Using Web image picker');
        // Web用の処理
        imageFile = await ImagePickerWeb.getImageAsBytes();
      } else {
        print('Using Mobile image picker');
        // モバイル用の処理
        final ImagePicker picker = ImagePicker();
        imageFile = await picker.pickImage(source: ImageSource.camera);
      }
      
      if (imageFile != null) {
        // 画像をFirebase Storageにアップロード
        String gsUrl = await _photoAnalysisService.uploadImage(imageFile);
        print('Image uploaded successfully. GS URL: $gsUrl');
        
        // 画像分析サービスに送信
        await _analyzePhoto(gsUrl);
      } else {
        print('No image selected');
        setState(() {
          _isAnalyzing = false;
        });
      }
    } catch (e) {
      print('Error picking or uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('画像の選択またはアップロードに失敗しました: $e'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isAnalyzing = false;
      });
    }
  }

// Firebase Storageに画像をアップロードする関数
Future<String> uploadImageToUserFolder(File image) async {
  // Firebase Authenticationから現在のユーザーを取得
  User? currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    throw Exception("ユーザーがログインしていません。");
  }

  // ユーザーのUIDまたは名前でフォルダを作成する
  String userId = currentUser.uid; // ここでUIDを使用
  String fileName = DateTime.now().millisecondsSinceEpoch.toString();

  // Firebase Storageへのリファレンスを作成
  Reference firebaseStorageRef = await FirebaseStorage.instance.ref().child('uploads/$userId/$fileName');
  print('Uploading image to: ${firebaseStorageRef.fullPath}');

  // 画像をFirebase Storageにアップロード
  UploadTask uploadTask = firebaseStorageRef.putFile(image);

  // アップロードが完了したら、ダウンロードURLを取得
  TaskSnapshot taskSnapshot = await uploadTask;
  String downloadUrl = await taskSnapshot.ref.getDownloadURL();
  print('Image uploaded to: $downloadUrl');

  return downloadUrl;
}


  Future<String> encodeImageWeb(html.File imageFile) async {
    final completer = Completer<String>();
    final reader = html.FileReader();
    reader.readAsDataUrl(imageFile);
    reader.onLoadEnd.listen((event) {
      String imageUrl = reader.result.toString().split(',')[1];
      completer.complete(imageUrl);
    });
    return completer.future;
  }

  Future<void> _analyzePhoto(String imageUrl) async {
    setState(() {
      _isAnalyzing = true;
    });
    
    try {      
      print('Using image URL for Gemini analysis: $imageUrl');
      
      // Gemini APIで画像分析
      Map<String, dynamic> coffeeData = await _photoAnalysisService.analyzeCoffeePhoto(imageUrl);
      print('Parsed coffee data: $coffeeData');
      
      // データが空かどうかをチェック
      bool hasData = false;
      coffeeData.forEach((key, value) {
        if (value != null && value.toString().isNotEmpty) {
          hasData = true;
        }
      });
      
      if (!hasData) {
        throw Exception("画像から有効なデータを抽出できませんでした。別の画像を試してください。");
      }
      
      // フォームに値を自動入力
      setState(() {
        if (coffeeData['name'] != null && coffeeData['name'].toString().isNotEmpty) {
          _coffeeNameController.text = coffeeData['name'];
          _coffeeName = coffeeData['name'];
        }
        
        if (coffeeData['country'] != null && coffeeData['country'].toString().isNotEmpty) {
          _originCountryController.text = coffeeData['country'];
          _originCountryName = coffeeData['country'];
        }
        
        if (coffeeData['region'] != null && coffeeData['region'].toString().isNotEmpty) {
          _region = coffeeData['region'];
          _regionController.text = coffeeData['region'];
        }
        
        if (coffeeData['farm'] != null && coffeeData['farm'].toString().isNotEmpty) {
          _farm = coffeeData['farm'];
          _farmController.text = coffeeData['farm'];
        }
        
        if (coffeeData['elevation'] != null && coffeeData['elevation'].toString().isNotEmpty) {
          _altitude = coffeeData['elevation'];
          _altitudeController.text = coffeeData['elevation'];
        }
        
        if (coffeeData['variety'] != null && coffeeData['variety'].toString().isNotEmpty) {
          _variety = coffeeData['variety'];
          _varietyController.text = coffeeData['variety'];
        }
        
        if (coffeeData['process'] != null && coffeeData['process'].toString().isNotEmpty) {
          _process = coffeeData['process'];
          _processController.text = coffeeData['process'];
        }
        
        if (coffeeData['flavorNotes'] != null && coffeeData['flavorNotes'].toString().isNotEmpty) {
          _flavorNotes = coffeeData['flavorNotes'];
          _flavorNotesController.text = coffeeData['flavorNotes'];
        }
        
        if (coffeeData['roaster'] != null && coffeeData['roaster'].toString().isNotEmpty) {
          _storeName = coffeeData['roaster'];
          _storeNameController.text = coffeeData['roaster'];
        }
        
        if (coffeeData['roastLevel'] != null && coffeeData['roastLevel'].toString().isNotEmpty) {
          _roastLevel = coffeeData['roastLevel'];
          _roastLevelController.text = coffeeData['roastLevel'];
        }
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('画像解析が完了しました！情報を確認・編集してください。'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error during image analysis: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('画像分析中にエラーが発生しました: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isAnalyzing = false;
      });
    }
  }

  // Future<void> uploadImage(File imageFile) async {
  // var request = http.MultipartRequest(
  //   'POST', Uri.parse('https://your-backend-api/analyze')
  // );
  // request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
  // var response = await request.send();

  // if (response.statusCode == 200) {
  //   print('Image uploaded and analyzed');
  //   var responseData = await response.stream.bytesToString();
  //   print(responseData);  // 分析結果を受け取る
  // } else {
  //   print('Image upload failed');
  // }

  Widget addCoffeeSaveButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) { // バリデーション成功
          print('Form is valid. Saving data...');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
          _formKey.currentState!.save(); // フォームの値を保存
          
          // Cooffee生成に必要なローカル変数を出力
          print('====================== addCoffeeSaveButton ======================');
          print(_coffeeNameController.text);
          print('FormKey: $_formKey');
          print('Coffee Name: $_coffeeName');
          print('Origin Country: $_originCountryName');
          print('Origin Country Code: $_originCountryCode');
          print('Region: $_region');
          print('Farm: $_farm');
          print('Altitude: $_altitude');
          print('Variety: $_variety');
          print('Process: $_process');
          print('Flavor Notes: $_flavorNotes');
          print('Store Name: $_storeName');
          // print('Store Location: $_storeLocation');
          print('Store Website: $_storeWebsite');
          print('Roast Level: $_roastLevel');
          print('Roast Date: $_roastDate');
          print('Created At: $_createdAt');
          print('Updated At: $_updatedAt');
          print('===============================================================');

          // Coffeeモデルを作成
          Coffee newCoffee = Coffee(
            coffeeName: _coffeeName!,
            originCountryName: _originCountryName,
            originCountryCode: _originCountryCode,
            region: _region,
            farm: _farm,
            altitude: _altitude,
            variety: _variety,
            process: _process,
            flavorNotes: _flavorNotes,
            storeName: _storeName,
            // storeLocation: _storeLocation,
            storeWebsite: _storeWebsite,
            roastLevel: _roastLevel,
            roastDate: _roastDate,
            createdAt: _createdAt ?? DateTime.now().toString(), 
            updatedAt: DateTime.now().toString(),
            
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
    );
  }

  Widget CountryPicker() {
    //CountryCodePickerを使って国名から国コードを取得
    return CountryCodePicker(
      onChanged: (CountryCode countryCode) {
        print('onChanged: $countryCode');
        print('Country name: ${countryCode.name}');
        print('Country code: ${countryCode.code}');
        // _originCountryを更新する
        setState(() {
          _originCountryController.text = countryCode.localize(context).name!;
          _originCountryCode = countryCode.code;
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
                    _roastLevelController.text = _roastLevel!;
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

  void addCoffeeData(Coffee newCoffee) async {
    print('Adding new coffee...');
    
    try {
      // ユーザーが認証されていることを確認
      if (user == null) {
        user = FirebaseAuth.instance.currentUser;
        
        if (user == null) {
          throw Exception('ユーザーが認証されていません。ログインしてください。');
        }
      }
      
      // users/{uid}ドキュメントが存在するか確認し、存在しなければ作成
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user!.uid).get();
      if (!userDoc.exists) {
        await _firestore.collection('users').doc(user!.uid).set({
          'email': user!.email,
          'created_at': FieldValue.serverTimestamp(),
        });
      }
      
      // coffeeデータを追加
      DocumentReference docRef = await _firestore
        .collection('users')
        .doc(user!.uid)
        .collection('coffees')
        .add(newCoffee.toJson());
        
      print('Coffee added successfully. Doc id : ${docRef.id}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('コーヒー情報が正常に追加されました'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
      
    } catch (error) {
      print('Failed to add coffee: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('コーヒー情報の追加に失敗しました: $error'),
          backgroundColor: Colors.red,
        ),
      );
      
      // エラーの詳細をコンソールに出力
      print('Error details: $error');
    }
  }

  void updateCoffeeData(String documentId, Coffee newCoffee) async {
    print('Updating coffee with id: $documentId');
    
    try {
      // ユーザーが認証されていることを確認
      if (user == null) {
        user = FirebaseAuth.instance.currentUser;
        
        if (user == null) {
          throw Exception('ユーザーが認証されていません。ログインしてください。');
        }
      }
      
      await _firestore
        .collection('users')
        .doc(user!.uid)
        .collection('coffees')
        .doc(documentId)
        .update(newCoffee.toJson());
        
      print('Coffee updated successfully. Doc id : $documentId');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('コーヒー情報が正常に更新されました'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
      
    } catch (error) {
      print('Failed to update coffee: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('コーヒー情報の更新に失敗しました: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void fetchCoffeeData(String documentId) {
    print('Fetching coffee data for documentId: $documentId...');
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    user = FirebaseAuth.instance.currentUser;

    try {
      firestore.collection('users').doc(user!.uid).collection('coffees').doc(documentId).get().then((doc) {
        if (doc.exists) {
          Map<String, dynamic>? coffeeData = doc.data() as Map<String, dynamic>?;
          _coffeeName = coffeeData?['coffeeName'];
          _originCountryName = coffeeData?['originCountryName'];
          _originCountryCode = coffeeData?['originCountryCode'];
          _region = coffeeData?['region'];
          _farm = coffeeData?['farm'];
          _altitude = coffeeData?['altitude'];
          _variety = coffeeData?['variety'];
          _process = coffeeData?['process'];
          _storeName = coffeeData?['storeName'];
          // _storeLocation = coffeeData?['storeLocation'];
          _storeWebsite = coffeeData?['storeWebsite'];
          _roastLevel = coffeeData?['roastLevel'];
          _roastDate = coffeeData?['roastDate'];
          _createdAt = coffeeData?['createdAt'];
          _updatedAt = coffeeData?['updatedAt'];

          print('Coffee Name: $_coffeeName');
          setState(() {
            _coffeeNameController.text = _coffeeName!;
            _originCountryController.text = _originCountryName!;
            _roastLevelController.text = _roastLevel!;
            _processController.text = _process!;
            _varietyController.text = _variety!;
            _roastDateController.text = _roastDate!;
          });
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
          String originCountryName = coffeeData?['originCountryName'] ?? 'Unknown';
          String roastLevel = coffeeData?['roastLevel'] ?? 'Unknown';

          print("Coffee Name: $coffeeName, OriginCountry: $originCountryName, Roast Level: $roastLevel");
        }
      } else {
        print("No coffees found for this user.");
      }
    } catch (e) {
      print("Failed to fetch coffee data: $e");
    }
  }
}