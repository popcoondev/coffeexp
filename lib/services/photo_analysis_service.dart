import 'dart:convert';
import 'dart:io';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhotoAnalysisService {
  // テストでモックに置き換えられるようにインスタンスを静的変数に
  static PhotoAnalysisService? _instance;
  
  // テスト用にインスタンスを置き換えるメソッド
  static void setMockInstance(PhotoAnalysisService mockService) {
    _instance = mockService;
  }
  
  // インスタンスの取得
  static PhotoAnalysisService getInstance() {
    return _instance ?? PhotoAnalysisService._();
  }
  
  // テスト用にモック可能なようにprotected変数として公開
  FirebaseAuth get auth => _auth;
  FirebaseStorage get storage => _storage;
  FirebaseFunctions get functions => _functions;
  
  // 内部で使用するプライベート変数
  final FirebaseAuth _auth;
  final FirebaseStorage _storage;
  final FirebaseFunctions _functions;
  
  // プライベートコンストラクタ
  PhotoAnalysisService._({
    FirebaseAuth? auth, 
    FirebaseStorage? storage,
    FirebaseFunctions? functions
  }) : 
    _auth = auth ?? FirebaseAuth.instance,
    _storage = storage ?? FirebaseStorage.instance,
    _functions = functions ?? FirebaseFunctions.instance;

  // 画像アップロード処理
  Future<String> uploadImage(dynamic imageData) async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("ログインしていません");
    }

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageRef = _storage.ref('user_files/${user.uid}/$fileName');
    
    UploadTask uploadTask;
    
    // Web環境の場合
    if (kIsWeb) {
      var metadata = SettableMetadata(contentType: "image/jpeg");
      uploadTask = storageRef.putData(imageData, metadata);
    } 
    // モバイル環境の場合
    else if (imageData is XFile) {
      List<int> bytes = await imageData.readAsBytes();
      var metadata = SettableMetadata(contentType: "image/jpeg");
      uploadTask = storageRef.putData(Uint8List.fromList(bytes), metadata);
    } 
    else {
      throw Exception("対応していない画像形式です");
    }

    TaskSnapshot snapshot = await uploadTask;
    if (snapshot.state == TaskState.success) {
      // アップロードされた画像のFirebase Storage URLを取得
      String downloadUrl = await snapshot.ref.getDownloadURL();
      
      // Storage URLをCloud Functions用のgsURL形式に変換
      String bucket = _storage.bucket;
      String gsUrl = 'gs://$bucket/${storageRef.fullPath}';
      
      return gsUrl;
    } else {
      throw Exception("画像アップロードに失敗しました");
    }
  }

  // Gemini APIを呼び出す処理
  Future<Map<String, dynamic>> analyzeCoffeePhoto(String imageUrl) async {
    try {
      // 本番環境設定に切り替え
      bool useDummyData = false; // 本番環境用
      
      if (useDummyData) {
        // ダミーデータを返す（開発用）
        await Future.delayed(Duration(seconds: 2)); // 分析している振りをする遅延
        return {
          "name": "エチオピア イルガチェフェ",
          "roaster": "Sample Coffee Roasters",
          "country": "エチオピア",
          "region": "イルガチェフェ",
          "process": "ウォッシュド",
          "variety": "ハイランド",
          "elevation": "1900-2200m",
          "roastLevel": "Medium"
        };
      }
      
      // 本番環境では、Firebase Functionsを呼び出す
      HttpsCallable callable = _functions.httpsCallable('analyzeCoffeePhoto');
      final result = await callable.call({
        'imageUrl': imageUrl,
      });

      final data = result.data;
      
      if (data['success'] == true) {
        return data['data'];
      } else {
        throw Exception(data['error'] ?? "写真分析に失敗しました");
      }
    } catch (e) {
      print('Error analyzing photo: $e');
      throw Exception("写真分析中にエラーが発生しました: $e");
    }
  }
}