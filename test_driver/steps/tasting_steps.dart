import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

// Given "ユーザーはコーヒーを選択している" step
class GivenUserSelectsCoffee extends GivenWithWorld<FlutterWorld> {
  @override
  Future<void> executeStep() async {
    // コーヒーリストから最初のアイテムをタップ
    final coffeeItemFinder = find.byValueKey('coffee_item_0');
    await FlutterDriverUtils.tap(world.driver, coffeeItemFinder);
    
    // コーヒー詳細画面が表示されていることを確認
    final coffeeDetailScreenFinder = find.byValueKey('coffee_detail_screen');
    await FlutterDriverUtils.isPresent(world.driver, coffeeDetailScreenFinder);
  }

  @override
  RegExp get pattern => RegExp(r"ユーザーはコーヒーを選択している");
}

// When "ユーザーがテイスティングフィードバックを追加する" step
class WhenUserAddsTastingFeedback extends WhenWithWorld<FlutterWorld> {
  @override
  Future<void> executeStep() async {
    // テイスティングボタンをタップ
    final tastingButtonFinder = find.byValueKey('add_tasting_button');
    await FlutterDriverUtils.tap(world.driver, tastingButtonFinder);
    
    // テイスティング画面が表示されていることを確認
    final tastingScreenFinder = find.byValueKey('tasting_feedback_screen');
    await FlutterDriverUtils.isPresent(world.driver, tastingScreenFinder);
    
    // 各評価項目を設定
    // 酸味スライダー
    final aciditySliderFinder = find.byValueKey('acidity_slider');
    await world.driver?.scroll(aciditySliderFinder, 100, 0, Duration(milliseconds: 500));
    
    // コクスライダー
    final bodySliderFinder = find.byValueKey('body_slider');
    await world.driver?.scroll(bodySliderFinder, 80, 0, Duration(milliseconds: 500));
    
    // 甘みスライダー
    final sweetnessSliderFinder = find.byValueKey('sweetness_slider');
    await world.driver?.scroll(sweetnessSliderFinder, 70, 0, Duration(milliseconds: 500));
    
    // バランススライダー
    final balanceSliderFinder = find.byValueKey('balance_slider');
    await world.driver?.scroll(balanceSliderFinder, 75, 0, Duration(milliseconds: 500));
    
    // 後味スライダー
    final aftertasteSliderFinder = find.byValueKey('aftertaste_slider');
    await world.driver?.scroll(aftertasteSliderFinder, 65, 0, Duration(milliseconds: 500));
    
    // メモを追加
    final noteFieldFinder = find.byValueKey('tasting_note_field');
    await FlutterDriverUtils.tap(world.driver, noteFieldFinder);
    await world.driver?.enterText('テストメモです。フルーティーな風味と良いバランス。');
    
    // 保存ボタンをタップ
    final saveButtonFinder = find.byValueKey('save_tasting_button');
    await FlutterDriverUtils.tap(world.driver, saveButtonFinder);
  }

  @override
  RegExp get pattern => RegExp(r"ユーザーがテイスティングフィードバックを追加する");
}

// Then "テイスティングが保存される" step
class ThenTastingShouldBeSaved extends ThenWithWorld<FlutterWorld> {
  @override
  Future<void> executeStep() async {
    // コーヒー詳細画面に戻ったことを確認
    final coffeeDetailScreenFinder = find.byValueKey('coffee_detail_screen');
    await FlutterDriverUtils.isPresent(world.driver, coffeeDetailScreenFinder);
    
    // テイスティング履歴リストが表示されていることを確認
    final tastingListFinder = find.byValueKey('tasting_history_list');
    await FlutterDriverUtils.isPresent(world.driver, tastingListFinder);
    
    // 最新のテイスティングが表示されていることを確認
    final latestTastingFinder = find.byValueKey('tasting_item_0');
    await FlutterDriverUtils.isPresent(world.driver, latestTastingFinder);
  }

  @override
  RegExp get pattern => RegExp(r"テイスティングが保存される");
}

// Then "レーダーチャートが表示される" step
class ThenRadarChartShouldDisplay extends ThenWithWorld<FlutterWorld> {
  @override
  Future<void> executeStep() async {
    // レーダーチャートが表示されていることを確認
    final radarChartFinder = find.byValueKey('tasting_radar_chart');
    await FlutterDriverUtils.isPresent(world.driver, radarChartFinder);
  }

  @override
  RegExp get pattern => RegExp(r"レーダーチャートが表示される");
}