// main.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'dart:html' as html;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if(false) {
    final remoteConfig = FirebaseRemoteConfig.instance;
    String googleMapsApiKey = remoteConfig.getString('google_maps_api_key');
    // JavaScriptでGoogle Maps APIスクリプトを動的に追加
    final script = html.ScriptElement();
    // script.src = 'https://maps.googleapis.com/maps/api/js?key=$googleMapsApiKey';
    script.src = 'https://maps.googleapis.com/maps/api/js?key=AIzaSyDbeIXlV-_2mOzJ-FgYChk7Bz6L5UgPaIY';
    html.document.head?.append(script);
    print('Google Maps API key: $googleMapsApiKey');
  }

  if(false) {
  // Use the emulator for Firestore and Authentication
  // FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  // FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  }
  
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
} 