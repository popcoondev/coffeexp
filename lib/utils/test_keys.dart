/// Flutter Driver用のテストキーを集中管理するクラス
class TestKeys {
  // 画面キー
  static const String homeScreen = 'home_screen';
  static const String loginScreen = 'login_signup_screen';
  static const String addCoffeeScreen = 'add_coffee_screen';
  static const String coffeeDetailScreen = 'coffee_detail_screen';
  static const String tastingFeedbackScreen = 'tasting_feedback_screen';
  
  // ログイン関連
  static const String emailField = 'email_field';
  static const String passwordField = 'password_field';
  static const String loginButton = 'login_button';
  static const String submitButton = 'submit_button';
  static const String usernameText = 'username_text';
  
  // コーヒーリスト関連
  static const String coffeeList = 'coffee_list';
  static String coffeeItem(int index) => 'coffee_item_$index';
  static const String addCoffeeButton = 'add_coffee_button';
  
  // コーヒー追加/編集フォーム
  static const String coffeeNameField = 'coffee_name_field';
  static const String countryField = 'country_field';
  static const String regionField = 'region_field';
  static const String processField = 'process_field';
  static const String varietyField = 'variety_field';
  static const String roastLevelField = 'roast_level_field';
  static const String saveButton = 'save_button';
  static const String photoButton = 'photo_button';
  
  // 写真分析関連
  static const String analyzingIndicator = 'analyzing_indicator';
  static const String analysisSuccessMessage = 'analysis_success_message';
  static const String analysisErrorMessage = 'analysis_error_message';
  
  // テイスティング関連
  static const String addTastingButton = 'add_tasting_button';
  static const String aciditySlider = 'acidity_slider';
  static const String bodySlider = 'body_slider';
  static const String sweetnessSlider = 'sweetness_slider';
  static const String balanceSlider = 'balance_slider';
  static const String aftertasteSlider = 'aftertaste_slider';
  static const String tastingNoteField = 'tasting_note_field';
  static const String saveTastingButton = 'save_tasting_button';
  static const String tastingRadarChart = 'tasting_radar_chart';
  static const String tastingHistoryList = 'tasting_history_list';
  static String tastingItem(int index) => 'tasting_item_$index';
  
  // 共通要素
  static const String snackbar = 'snackbar';
  static const String errorMessage = 'error_message';
}