// main.dart
import 'package:cloud_firestore/cloud_firestore.dart';
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/login_signup': (context) => LoginSignupScreen(),
      },
    );
  }
}