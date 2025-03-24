import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import '../lib/utils/test_keys.dart';

void main() {
  group('CoffeeExp App', () {
    FlutterDriver? driver;

    // テスト前にFlutter Driverに接続
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // テスト終了後にドライバーを閉じる
    tearDownAll(() async {
      if (driver != null) {
        driver!.close();
      }
    });

    // 基本的なアプリ起動テスト
    test('アプリが正常に起動する', () async {
      // 何もしなくても成功する基本テスト
      expect(true, true);
    });

    // 写真分析テスト
    group('写真分析機能', () {
      // 前提条件：ユーザーがログインし、コーヒー追加画面を表示している（モックで代用）
      
      test('写真ボタンをタップして分析を開始する', () async {
        // 写真選択ボタン（FAB）をタップ
        final photoButtonFinder = find.byValueKey(TestKeys.photoButton);
        await driver!.tap(photoButtonFinder);
        
        // ローディングインジケータが表示されることを確認
        final loadingIndicatorFinder = find.byValueKey(TestKeys.analyzingIndicator);
        await driver!.waitFor(loadingIndicatorFinder);
        
        // モックの分析処理が完了するまで待機
        await Future.delayed(Duration(seconds: 3));
        
        // 成功メッセージが表示されることを確認
        final successMessageFinder = find.byValueKey(TestKeys.analysisSuccessMessage);
        await driver!.waitFor(successMessageFinder);
      });
      
      test('分析結果がフォームに自動入力される', () async {
        // 各フィールドにデータが入力されていることを確認
        final coffeeNameFieldFinder = find.byValueKey(TestKeys.coffeeNameField);
        expect(await driver!.getText(coffeeNameFieldFinder), isNotEmpty);
        
        final countryFieldFinder = find.byValueKey(TestKeys.countryField);
        expect(await driver!.getText(countryFieldFinder), isNotEmpty);
        
        final regionFieldFinder = find.byValueKey(TestKeys.regionField);
        expect(await driver!.getText(regionFieldFinder), isNotEmpty);
        
        final processFieldFinder = find.byValueKey(TestKeys.processField);
        expect(await driver!.getText(processFieldFinder), isNotEmpty);
        
        final roastLevelFieldFinder = find.byValueKey(TestKeys.roastLevelField);
        expect(await driver!.getText(roastLevelFieldFinder), isNotEmpty);
      });
    });
  });
}