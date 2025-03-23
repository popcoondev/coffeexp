# Coffee Explorer App

コーヒー豆の情報を記録・管理するためのFlutterアプリケーション。

## 機能

- コーヒー豆情報の追加、編集、削除
- 画像からのコーヒー豆情報自動抽出 (Gemini AI APIを使用)
- テイスティングフィードバックの記録とレーダーチャート表示
- お気に入り機能
- 検索機能

## セットアップ手順

1. Firebaseプロジェクトの設定

このアプリケーションはFirebaseのBlaze（従量課金）プランが必要です。次のサービスを有効にしてください：
- Firebase Authentication
- Firestore Database
- Firebase Storage
- Firebase Functions

```bash
# Firebase CLIのインストール
npm install -g firebase-tools

# ログイン
firebase login

# プロジェクトの初期化
firebase init
```

2. Gemini API設定

Gemini API を使用するには、API キーを取得して Firebase Functions に設定する必要があります。

```bash
# Gemini API キーの設定
firebase functions:config:set gemini.api_key="YOUR_GEMINI_API_KEY"

# Functionsのデプロイ
firebase deploy --only functions
```

3. Flutterアプリの実行

```bash
# 依存関係のインストール
flutter pub get

# アプリの実行
flutter run
```

## 注意事項

- このアプリケーションは Firebase の Blaze プランが必要です
- 画像解析機能を使用するには、有効な Gemini API キーが必要です
- Firestore および Storage のセキュリティルールを適切に設定してください

## 開発者向け情報

### 画像解析の仕組み

1. ユーザーがコーヒー豆のパッケージ写真を撮影/選択
2. 画像を Firebase Storage にアップロード
3. Firebase Functions を介して Gemini Vision API に送信
4. Gemini API が画像からコーヒー豆情報を抽出
5. 抽出された情報をJSON形式でアプリに返却
6. ユーザーが内容を確認・編集して保存

### 動作確認方法

Firebase Blaze プランにアップグレードできない場合:

1. アプリ側の photo_analysis_service.dart を修正して、ダミーデータを返すようにする:

```dart
Future<Map<String, dynamic>> analyzeCoffeePhoto(String imageUrl) async {
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
```

2. Gemini API が機能することを確認したい場合は、Googleの提供する公式サンプルページで動作を確認できます:
   https://ai.google.dev/tutorials/dart_quickstart