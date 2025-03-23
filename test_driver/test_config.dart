import 'dart:async';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'steps/photo_analysis_steps.dart';
import 'steps/add_coffee_steps.dart';
import 'steps/login_steps.dart';
import 'steps/tasting_steps.dart';

Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [RegExp('features/*.*.feature')]
    ..reporters = [
      StdoutReporter(),
      ProgressReporter(),
      TestRunSummaryReporter(),
      JsonReporter(path: './test_report.json')
    ]
    ..hooks = []
    ..stepDefinitions = [
      // ログイン関連のステップ
      GivenUserIsLoggedIn(),
      WhenUserLogsIn(),
      ThenUserShouldBeLoggedIn(),
      
      // コーヒー追加関連のステップ
      GivenUserIsOnAddCoffeeScreen(),
      WhenUserFillsCoffeeDetails(),
      WhenUserSavesCoffeeDetails(),
      ThenCoffeeShouldBeSaved(),
      
      // 写真分析関連のステップ
      WhenUserSelectsPhoto(),
      ThenPhotoShouldBeAnalyzed(),
      ThenFormShouldBeFilledWithAnalysisResults(),
      
      // テイスティング関連のステップ
      GivenUserSelectsCoffee(),
      WhenUserAddsTastingFeedback(),
      ThenTastingShouldBeSaved(),
      ThenRadarChartShouldDisplay(),
    ]
    ..customStepParameterDefinitions = []
    ..restartAppBetweenScenarios = true
    ..targetAppPath = 'test_driver/app.dart'
    ..exitAfterTestRun = true;

  return GherkinRunner().execute(config);
}