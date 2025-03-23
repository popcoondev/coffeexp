// main.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'google_map_options.dart';
import 'screens/home_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/login_signup_screen';

// リリースビルドでtrueに設定したい場合は、--dart-defineを使用する
// flutter run --dart-define=USE_EMULATOR=true
const bool USE_EMULATOR = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    print('Firebase initialized successfully');
    
    // Firebase Remote Configの初期化と設定
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    
    // デフォルト値の設定
    await remoteConfig.setDefaults({
      'google_maps_api_key': '',
    });
    
    // 設定を取得
    await remoteConfig.fetchAndActivate();
    
    // ローカルエミュレーターを使用する場合
    if (USE_EMULATOR) {
      print('Using Firebase emulators');
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
      FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
      FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
    }
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'coffeExp',
      locale: Locale('ja', 'JP'),
      localizationsDelegates: [
        CountryLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        
      ],
      supportedLocales: [
        Locale('ja', 'JP'),
    ],
      theme: ThemeData(
        // アプリ全体の配色を設定
        // アクセントカラー: 深いグリーン (#003F2D) とゴールド (#D4AF37)
        // サブカラー: 明るいグリーン (#00A896)
        // 背景とテキストのベースカラー: ホワイト (#FFFFFF) とスレートグレー (#4A4A4A) を基調に、洗練された印象を演出。
        brightness: Brightness.light,  // 明るいテーマ（ダークテーマの場合は .dark を使用）
        primaryColor: Color(0xFFD4AF37),  // アクセントカラー
        scaffoldBackgroundColor: Color(0xFFFFFFFF),  // 全体の背景色
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Color(0xFF4A4A4A)),  // 一般的なテキストの色
          bodySmall: TextStyle(color: Color(0xFF7B7B7B)),  // サブテキストの色
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF00A896),  // 明るいグリーン
            foregroundColor: Colors.white,  // テキストはホワイト
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Color(0xFF00A896),  // 明るいグリーン

          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF00A896)),  // 明るいグリーン
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF7B7B7B)),  // スレートグレー
          ),
          
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF003F2D),  // 深いグリーン
          titleTextStyle: TextStyle(
            color: Colors.white,  // テキストはホワイト
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(
            color: Colors.white,  // アイコンもホワイト
          ),
        ),
        //tabbarの色
        tabBarTheme: TabBarTheme(
          indicatorColor: Color(0xFFD4AF37),  // ゴールド
          labelColor: Colors.white,  // 選択されたタブ
          unselectedLabelColor: Colors.white.withOpacity(0.5),  // 選択されていないタブ
        ),
        dividerColor: Color(0xFFE0E0E0),  // ディバイダーの色
        // floatingActionButtonの色
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFD4AF37),  // ゴールド
          foregroundColor: Colors.white
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/login_signup': (context) => LoginSignupScreen(),
      },
    );
  }
}