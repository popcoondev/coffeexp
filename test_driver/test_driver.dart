import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

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
  });
}