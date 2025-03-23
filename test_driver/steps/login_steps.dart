import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

// Given "ユーザーはログインしている" step
class GivenUserIsLoggedIn extends Given1WithWorld<String, FlutterWorld> {
  @override
  Future<void> executeStep(String email) async {
    // すでにログイン済みという前提で、ホーム画面が表示されていることを確認
    final homeScreenFinder = find.byValueKey('home_screen');
    await FlutterDriverUtils.isPresent(world.driver, homeScreenFinder);
  }

  @override
  RegExp get pattern => RegExp(r"ユーザーは {string} としてログインしている");
}

// When "ユーザーが {string} と {string} でログインする" step
class WhenUserLogsIn extends When2WithWorld<String, String, FlutterWorld> {
  @override
  Future<void> executeStep(String email, String password) async {
    // ログイン画面への遷移ボタンを探す
    final loginButtonFinder = find.byValueKey('login_button');
    await FlutterDriverUtils.tap(world.driver, loginButtonFinder);
    
    // メールアドレス入力
    final emailFieldFinder = find.byValueKey('email_field');
    await FlutterDriverUtils.tap(world.driver, emailFieldFinder);
    await world.driver?.enterText(email);
    
    // パスワード入力
    final passwordFieldFinder = find.byValueKey('password_field');
    await FlutterDriverUtils.tap(world.driver, passwordFieldFinder);
    await world.driver?.enterText(password);
    
    // ログインボタンをタップ
    final submitButtonFinder = find.byValueKey('submit_button');
    await FlutterDriverUtils.tap(world.driver, submitButtonFinder);
    
    // ログイン処理完了を待つ
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  RegExp get pattern => RegExp(r"ユーザーが {string} と {string} でログインする");
}

// Then "ユーザーはログインできている" step
class ThenUserShouldBeLoggedIn extends ThenWithWorld<FlutterWorld> {
  @override
  Future<void> executeStep() async {
    // ホーム画面が表示されていることを確認
    final homeScreenFinder = find.byValueKey('home_screen');
    await FlutterDriverUtils.isPresent(world.driver, homeScreenFinder);
    
    // ログインユーザー名が表示されていることを確認
    final usernameFinder = find.byValueKey('username_text');
    await FlutterDriverUtils.isPresent(world.driver, usernameFinder);
  }

  @override
  RegExp get pattern => RegExp(r"ユーザーはログインできている");
}