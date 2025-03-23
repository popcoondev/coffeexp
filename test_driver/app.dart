import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:coffeexp/main.dart' as app;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mockito/mockito.dart';
import 'package:coffeexp/services/photo_analysis_service.dart';

// モックユーザー
class MockUser implements User {
  @override
  String get uid => 'test-uid';
  
  @override
  String? get email => 'test@example.com';
  
  @override
  String? get displayName => 'Test User';
  
  @override
  bool get isAnonymous => false;
  
  // その他の必要なメソッドやプロパティの実装をここに追加
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockPhotoAnalysisService implements PhotoAnalysisService {
  // API呼び出しのモック実装
  @override
  Future<Map<String, dynamic>> analyzeCoffeePhoto(String imageUrl) async {
    await Future.delayed(Duration(seconds: 1)); // 分析処理を装う遅延
    return {
      "name": "テスト エチオピア イルガチェフェ",
      "roaster": "Test Roasters",
      "country": "エチオピア",
      "region": "イルガチェフェ",
      "process": "ウォッシュド",
      "variety": "ハイランド",
      "elevation": "1800-2000m",
      "roastLevel": "Medium"
    };
  }

  // 画像アップロードのモック
  @override
  Future<String> uploadImage(imageData) async {
    await Future.delayed(Duration(milliseconds: 500)); // アップロードを装う遅延
    return 'gs://test-bucket/test-image.jpg';
  }

  // 必須のゲッター
  @override
  FirebaseAuth get auth => FirebaseAuth.instance;

  @override
  FirebaseFunctions get functions => FirebaseFunctions.instance;

  @override
  FirebaseStorage get storage => FirebaseStorage.instance;
}

void main() async {
  // Flutter Driver拡張を有効化
  enableFlutterDriverExtension();
  
  // Flutterの初期化
  WidgetsFlutterBinding.ensureInitialized();
  
  // Firebaseの初期化
  await Firebase.initializeApp();
  
  // モックサービスを設定
  PhotoAnalysisService.setMockInstance(MockPhotoAnalysisService());
  
  // アプリを起動
  app.main();
}