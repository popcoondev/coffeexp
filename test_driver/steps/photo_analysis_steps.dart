import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

// When "ユーザーが写真を選択する" step
class WhenUserSelectsPhoto extends WhenWithWorld<FlutterWorld> {
  @override
  Future<void> executeStep() async {
    // 写真選択ボタン（FAB）をタップ
    final photoButtonFinder = find.byValueKey('photo_button');
    await FlutterDriverUtils.tap(world.driver, photoButtonFinder);
    
    // テスト環境では実際の写真選択はシミュレートする
    // 代わりに、モックデータが返されるようにしておく
    await Future.delayed(Duration(seconds: 2)); // 写真選択をシミュレート
  }

  @override
  RegExp get pattern => RegExp(r"ユーザーが写真を選択する");
}

// Then "写真が分析される" step
class ThenPhotoShouldBeAnalyzed extends ThenWithWorld<FlutterWorld> {
  @override
  Future<void> executeStep() async {
    // 写真分析中のローディングインジケータが表示される
    final loadingIndicatorFinder = find.byValueKey('analyzing_indicator');
    await FlutterDriverUtils.isPresent(world.driver, loadingIndicatorFinder);
    
    // 分析完了を待つ（最大5秒）
    await Future.delayed(Duration(seconds: 5));
    
    // ローディングインジケータが消えたことを確認
    await FlutterDriverUtils.isAbsent(world.driver, loadingIndicatorFinder, timeout: Duration(seconds: 10));
    
    // 成功メッセージが表示されることを確認
    final successMessageFinder = find.byValueKey('analysis_success_message');
    await FlutterDriverUtils.isPresent(world.driver, successMessageFinder);
  }

  @override
  RegExp get pattern => RegExp(r"写真が分析される");
}

// Then "分析結果がフォームに自動入力される" step
class ThenFormShouldBeFilledWithAnalysisResults extends ThenWithWorld<FlutterWorld> {
  @override
  Future<void> executeStep() async {
    // 各フィールドにデータが入力されていることを確認
    
    // コーヒー名フィールド
    final coffeeNameFieldFinder = find.byValueKey('coffee_name_field');
    final coffeeNameText = await world.driver?.getText(coffeeNameFieldFinder);
    expect(coffeeNameText, isNotEmpty);
    
    // 生産国フィールド
    final countryFieldFinder = find.byValueKey('country_field');
    final countryText = await world.driver?.getText(countryFieldFinder);
    expect(countryText, isNotEmpty);
    
    // 地域フィールド
    final regionFieldFinder = find.byValueKey('region_field');
    final regionText = await world.driver?.getText(regionFieldFinder);
    expect(regionText, isNotEmpty);
    
    // 処理方法フィールド
    final processFieldFinder = find.byValueKey('process_field');
    final processText = await world.driver?.getText(processFieldFinder);
    expect(processText, isNotEmpty);
    
    // 焙煎度合いフィールド
    final roastLevelFieldFinder = find.byValueKey('roast_level_field');
    final roastLevelText = await world.driver?.getText(roastLevelFieldFinder);
    expect(roastLevelText, isNotEmpty);
  }

  @override
  RegExp get pattern => RegExp(r"分析結果がフォームに自動入力される");
}