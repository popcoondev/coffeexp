import 'dart:convert';
import 'dart:io';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhotoAnalysisService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

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
      // 開発環境では、Firebase Functionsが設定されていない場合にダミーデータを返すロジック
      bool useDummyData = true; // 本番環境では false に設定
      
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