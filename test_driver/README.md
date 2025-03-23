# CoffeeExp アプリケーションのテスト

> **注意**: 現在、Flutter SDK 3.5.3と最新のFirebaseパッケージ（5.x系）との間に依存関係の不一致があるため、Gherkin/BDDテストは一時的に無効化されています。代わりに、FlutterDriverを直接使用したIntegrationテストに切り替えています。このREADMEには将来的なBDDテスト実装のリファレンスとしての情報が含まれています。

このディレクトリには、BDD (Behavior-Driven Development) 手法を用いたCoffeeExpアプリケーションの統合テストが含まれています。

## ディレクトリ構造

```
test_driver/
├── app.dart                    # テスト用のアプリケーション初期化ファイル
├── test_config.dart            # BDDテスト設定
├── README.md                   # このファイル
├── features/                   # Gerkinシナリオ定義
│   ├── login.feature           # ログイン機能のシナリオ
│   ├── add_coffee.feature      # コーヒー追加機能のシナリオ
│   ├── photo_analysis.feature  # 写真分析機能のシナリオ
│   └── tasting_feedback.feature # テイスティング機能のシナリオ
└── steps/                      # ステップ定義
    ├── login_steps.dart        # ログイン関連のステップ
    ├── add_coffee_steps.dart   # コーヒー追加関連のステップ
    ├── photo_analysis_steps.dart # 写真分析関連のステップ
    └── tasting_steps.dart      # テイスティング関連のステップ
```

## テストの実行方法

### 前提条件

- Flutter SDKがインストールされていること
- エミュレータまたは実機がセットアップされていること

### テスト実行コマンド

```bash
flutter drive --target=test_driver/app.dart --driver=test_driver/test_config.dart
```

## Gerkinシナリオの記述ガイド

Gerkinシナリオは日本語で記述されています。以下の形式に従って新しいシナリオを追加できます：

```gherkin
# language: ja
機能: 機能名
  機能の説明
  
  背景:
    前提 共通の前提条件
    
  シナリオ: シナリオ名
    前提 前提条件
    もし アクション
    ならば 期待される結果
```

## ウィジェットへのテストキーの追加

テストで識別するために、ウィジェットにはテストキーを追加する必要があります。`lib/utils/test_keys.dart` に定義されたキーを使用してください。

例：

```dart
ElevatedButton(
  key: ValueKey(TestKeys.loginButton),
  onPressed: () => _login(),
  child: Text('ログイン'),
)
```

## テストデータ

テストで使用されるダミーデータは `app.dart` 内の `setupFirebaseMocks()` メソッドで設定されています。新しいテストシナリオに必要なデータがある場合は、このメソッドを拡張してください。

## Firebase Functions のモック

Firebae Functionsのモックは `app.dart` 内で以下のようにカスタム実装しています:

```dart
class MockFirebaseFunctions extends Mock implements FirebaseFunctions {
  @override
  HttpsCallable httpsCallable(String name, {HttpsCallableOptions? options}) {
    // 写真分析のモックレスポンスを返す
    if (name == 'analyzeCoffeePhoto') {
      return MockHttpsCallable({
        'success': true,
        'data': {
          'name': 'エチオピア イルガチェフェ',
          'roaster': 'Sample Coffee Roasters',
          // ...
        }
      });
    }
    return MockHttpsCallable({'success': false, 'error': 'Function not implemented in mock'});
  }
}
```

新しいCloud Functions関数をモックする必要がある場合は、`httpsCallable`メソッド内に条件分岐を追加してください。

## 注意事項

- テストはFirebaseのモックを使用しているため、実際のFirebase環境には影響を与えません
- 写真選択など、デバイス依存の機能はモックされています
- CI/CD環境では特別な設定が必要な場合があります
- BDDテストは初回実行時に依存関係をダウンロードするため、完了までに時間がかかる場合があります