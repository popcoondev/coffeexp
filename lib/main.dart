// main.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'google_map_options.dart';
import 'screens/home_screen.dart';
import 'dart:html' as html;

import 'screens/login_signup_screen';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Firebase Remote Configを使用してGoogle Maps APIキーを取得
  if(false) {
    final remoteConfig = FirebaseRemoteConfig.instance;
    String googleMapsApiKey = remoteConfig.getString('google_maps_api_key');
    // JavaScriptでGoogle Maps APIスクリプトを動的に追加
    final script = html.ScriptElement();
    // script.src = 'https://maps.googleapis.com/maps/api/js?key=$googleMapsApiKey';
    script.src = testGoogleMapsApiKey;
    html.document.head?.append(script);
    print('Google Maps API key: $googleMapsApiKey');
  }

  // ローカルエミュレーターを使用する場合はtrueに設定
  if(false) {
  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  }
  
  runApp(MyApp());
} 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'coffeExp',
      localizationsDelegates: [
        CountryLocalizations.delegate,
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