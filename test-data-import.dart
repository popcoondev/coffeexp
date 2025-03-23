// test-data-import.dart
// テストデータインポート用のユーティリティスクリプト
// 
// 使用方法:
// 1. Firebaseにログインした状態でこのスクリプトを実行します
// 2. dart test-data-import.dart コマンドを実行

import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'lib/firebase_options.dart';

void main() async {
  // Flutterバインディングの初期化
  WidgetsFlutterBinding.ensureInitialized();
  
  // Firebaseの初期化
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // ユーザーが認証されているか確認
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    print('Error: ユーザーがログインしていません。ログインしてから再実行してください。');
    exit(1);
  }
  
  print('ログインユーザー: ${user.email} (${user.uid})');
  
  // テストデータの読み込み
  final file = File('test-data.json');
  if (!file.existsSync()) {
    print('Error: test-data.json ファイルが見つかりません。');
    exit(1);
  }
  
  final jsonString = file.readAsStringSync();
  final List<dynamic> coffeeList = json.decode(jsonString);
  
  print('テストデータの読み込み完了: ${coffeeList.length}件のコーヒーデータ');
  
  // Firestoreへのデータ登録
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  
  // ユーザードキュメントの確認と作成
  final userDoc = await firestore.collection('users').doc(user.uid).get();
  if (!userDoc.exists) {
    await firestore.collection('users').doc(user.uid).set({
      'email': user.email,
      'created_at': FieldValue.serverTimestamp(),
    });
    print('ユーザードキュメントを作成しました');
  }
  
  // コーヒーデータの登録
  int successCount = 0;
  int errorCount = 0;
  
  for (var coffee in coffeeList) {
    try {
      // createdAtとupdatedAtの設定
      coffee['createdAt'] = DateTime.now().toString();
      coffee['updatedAt'] = DateTime.now().toString();
      
      // コーヒーデータの登録
      await firestore
          .collection('users')
          .doc(user.uid)
          .collection('coffees')
          .add(coffee);
      
      successCount++;
      print('登録成功: ${coffee['coffeeName']}');
    } catch (e) {
      errorCount++;
      print('登録エラー: ${coffee['coffeeName']} - $e');
    }
    
    // 少し待機してFirebaseの負荷を抑える
    await Future.delayed(Duration(milliseconds: 500));
  }
  
  print('====== インポート完了 ======');
  print('成功: $successCount件');
  print('エラー: $errorCount件');
  print('合計: ${coffeeList.length}件');
  
  exit(0);
}