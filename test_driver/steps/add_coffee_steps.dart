import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

// Given "ユーザーはコーヒー追加画面にいる" step
class GivenUserIsOnAddCoffeeScreen extends GivenWithWorld<FlutterWorld> {
  @override
  Future<void> executeStep() async {
    // プラスボタンを見つけてタップ
    final addButtonFinder = find.byValueKey('add_coffee_button');
    await FlutterDriverUtils.tap(world.driver, addButtonFinder);
    
    // コーヒー追加画面が表示されていることを確認
    final addCoffeeScreenFinder = find.byValueKey('add_coffee_screen');
    await FlutterDriverUtils.isPresent(world.driver, addCoffeeScreenFinder);
  }

  @override
  RegExp get pattern => RegExp(r"ユーザーはコーヒー追加画面にいる");
}

// When "ユーザーがコーヒー情報を入力する" step
class WhenUserFillsCoffeeDetails extends WhenWithWorld<FlutterWorld> {
  @override
  Future<void> executeStep() async {
    // コーヒー名入力
    final coffeeNameFieldFinder = find.byValueKey('coffee_name_field');
    await FlutterDriverUtils.tap(world.driver, coffeeNameFieldFinder);
    await world.driver?.enterText('テストコーヒー');
    
    // 生産国入力
    final countryFieldFinder = find.byValueKey('country_field');
    await FlutterDriverUtils.tap(world.driver, countryFieldFinder);
    await world.driver?.enterText('エチオピア');
    
    // 地域入力
    final regionFieldFinder = find.byValueKey('region_field');
    await FlutterDriverUtils.tap(world.driver, regionFieldFinder);
    await world.driver?.enterText('イルガチェフェ');
    
    // 処理方法入力
    final processFieldFinder = find.byValueKey('process_field');
    await FlutterDriverUtils.tap(world.driver, processFieldFinder);
    await world.driver?.enterText('ウォッシュド');
    
    // 焙煎度合い入力
    final roastLevelFieldFinder = find.byValueKey('roast_level_field');
    await FlutterDriverUtils.tap(world.driver, roastLevelFieldFinder);
    await world.driver?.enterText('ミディアム');
  }

  @override
  RegExp get pattern => RegExp(r"ユーザーがコーヒー情報を入力する");
}

// When "ユーザーが保存ボタンをタップする" step
class WhenUserSavesCoffeeDetails extends WhenWithWorld<FlutterWorld> {
  @override
  Future<void> executeStep() async {
    // 保存ボタンをタップ
    final saveButtonFinder = find.byValueKey('save_button');
    await FlutterDriverUtils.tap(world.driver, saveButtonFinder);
    
    // 保存処理完了を待つ
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  RegExp get pattern => RegExp(r"ユーザーが保存ボタンをタップする");
}

// Then "コーヒー情報が保存される" step
class ThenCoffeeShouldBeSaved extends ThenWithWorld<FlutterWorld> {
  @override
  Future<void> executeStep() async {
    // ホーム画面に戻ったことを確認
    final homeScreenFinder = find.byValueKey('home_screen');
    await FlutterDriverUtils.isPresent(world.driver, homeScreenFinder);
    
    // スナックバーで成功メッセージが表示されたことを確認
    final snackbarFinder = find.byValueKey('snackbar');
    final snackbarText = await world.driver?.getText(snackbarFinder);
    
    // テキストに「成功」が含まれているか確認
    expect(snackbarText, contains('成功'));
  }

  @override
  RegExp get pattern => RegExp(r"コーヒー情報が保存される");
}