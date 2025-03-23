import 'package:coffeexp/screens/add_coffee_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Strings {
  // home_screen.dart
  static String get homeScreenAppBarTitle => Intl.message(
        'coffeExp',
        name: 'homeScreenAppBarTitle',
        desc: 'Title for the home screen appbar',
      );

  static String get homeScreenTabBarMyCoffees => Intl.message(
        'My Coffees',
        name: 'homeScreenTabBarMyCoffees',
        desc: '',
      );

  static String get homeScreenTabBarFavorites => Intl.message(
        'Favorites',
        name: 'homeScreenTabBarFavorites',
        desc: '',
      );

  static String get homeScreenFloatingActionButtonLabel => Intl.message(
        'Add Coffee',
        name: 'homeScreenFloatingActionButtonLabel',
        desc: '',
      );

  static String get homeScreenUserAuthError => Intl.message(
        'User is not signed in',
        name: 'homeScreenUserAuthError',
        desc: '',
      );

  static String get homeScreenUserCoffeeDataNone => Intl.message(
        'No coffee data',
        name: 'homeScreenUserCoffeeDataNone',
        desc: '',
      );

  //AlertDialog
  static String get homeScreenAlertDialogTitle => Intl.message(
        'Account',
        name: 'homeScreenAlertDialogTitle',
        desc: '',
      );

  static String get homeScreenAlertDialogContent => Intl.message(
        'Email: ',
        name: 'homeScreenAlertDialogContent',
        desc: '',
      );

  static String get homeScreenAlertDialogCancel => Intl.message(
        'Cancel',
        name: 'homeScreenAlertDialogCancel',
        desc: '',
      );

  static String get homeScreenAlertDialogSignOut => Intl.message(
        'Sign Out',
        name: 'homeScreenAlertDialogSignOut',
        desc: '',
      );

  // add_coffee_screen.dart
  static String get addCofffeScreenAppBarTitle => Intl.message(
        'Add New Coffee',
        name: 'addCofffeeScreenAppBarTitle',
        desc: '',
      );

  // list titles
  static String get addCofffeScreenCoffeeBeanLabel => Intl.message(
        'Coffee Bean Information',
        name: 'addCofffeScreenCoffeeBeanLabel',
        desc: '',
      );

  // from labels
  // Label is ('English', 'localeText (ex. Japanese)')
  // main is english
  // sub is localeText (ex. Japanese, If locale is English, it is empty)

  // Coffee Name
  static String get addCofffeScreenCofeeNameFormLabel => Intl.message(
        'Coffee Name',
        name: 'addCofffeScreenCofeeNameFormLabel',
        desc: '',
      );

  static String get addCofffeScreenCofeeNameFormLabelSub => Intl.message(
        'コーヒー名',
        name: 'addCofffeScreenCofeeNameFormLabel',
        desc: '',
      );

  static String get addCofffeScreenCofeeNameFormError => Intl.message(
        'Please enter the name of the coffee',
        name: 'addCofffeScreenCofeeNameFormError',
        desc: '',
      );

  static String get addCofffeScreenCountryFormLabel => Intl.message(
        'Origin Country',
        name: 'addCofffeScreenCountryFormLabel',
        desc: '',
      );

  static String get addCofffeScreenCountryFormLabelSub => Intl.message(
        '原産国',
        name: 'addCofffeScreenCountryFormLabelSub',
        desc: '',
      );

  static String get addCofffeScreenCountryFormError => Intl.message(
        'Please enter the origin country of the coffee',
        name: 'addCofffeScreenCountryFormError',
        desc: '',
      );

  static String get addCofffeScreenRegionFormLabel => Intl.message(
        'Region',
        name: 'addCofffeScreenRegionFormLabel',
        desc: '',
      );

  static String get addCofffeScreenRegionFormLabelSub => Intl.message(
        '地域',
        name: 'addCofffeScreenRegionFormLabelSub',
        desc: '',
      );

  static String get addCofffeScreenRegionFormError => Intl.message(
        'Please enter the region of the coffee',
        name: 'addCofffeScreenRegionFormError',
        desc: '',
      );

  static String get addCofffeScreenFarmFormLabel => Intl.message(
        'Farm/Producer',
        name: 'addCofffeScreenRoastLevelFormLabel',
        desc: '',
      );

  static String get addCofffeScreenFarmFormLabelSub => Intl.message(
        '農園/生産者',
        name: 'addCofffeScreenRoastLevelFormLabelSub',
        desc: '',
      );

  static String get addCofffeScreenFarmFormError => Intl.message(
        'Please enter the farm/producer of the coffee',
        name: 'addCofffeScreenFarmFormError',
        desc: '',
      );

  static String get AddCoffeeScreenAltitudeFormLabel => Intl.message(
        'Altitude(m)',
        name: 'AddCoffeeScreenAltitudeFormLabel',
        desc: '',
      );

  static String get AddCoffeeScreenAltitudeFormLabelSub => Intl.message(
        '標高',
        name: 'AddCoffeeScreenAltitudeFormLabelSub',
        desc: '',
      );

  static String get AddCoffeeScreenAltitudeFormError => Intl.message(
        'Please enter the altitude of the coffee',
        name: 'AddCoffeeScreenAltitudeFormError',
        desc: '',
      );

  static String get AddCoffeeScreenVarietyFormLabel => Intl.message(
        'Variety',
        name: 'AddCoffeeScreenVarietyFormLabel',
        desc: '',
      );

  static String get AddCoffeeScreenVarietyFormLabelSub => Intl.message(
        '品種',
        name: 'AddCoffeeScreenVarietyFormLabelSub',
        desc: '',
      );

  static String get AddCoffeeScreenVarietyFormError => Intl.message(
        'Please enter the variety of the coffee',
        name: 'AddCoffeeScreenVarietyFormError',
        desc: '',
      );

  static String get AddCoffeeScreenProcessFormLabel => Intl.message(
        'Process',
        name: 'AddCoffeeScreenProcessFormLabel',
        desc: '',
      );

  static String get AddCoffeeScreenProcessFormLabelSub => Intl.message(
        'プロセス',
        name: 'AddCoffeeScreenProcessFormLabelSub',
        desc: '',
      );

  static String get AddCoffeeScreenProcessFormError => Intl.message(
        'Please enter the process of the coffee',
        name: 'AddCoffeeScreenProcessFormError',
        desc: '',
      );

  static String get AddCoffeeScreenFlavorNotesFormLabel => Intl.message(
        'Flavor Notes',
        name: 'AddCoffeeScreenFlavorNotesFormLabel',
        desc: '',
      );

  static String get AddCoffeeScreenFlavorNotesFormLabelSub => Intl.message(
        'フレーバーノート',
        name: 'AddCoffeeScreenFlavorNotesFormLabelSub',
        desc: '',
      );

  static String get AddCoffeeScreenFlavorNotesFormError => Intl.message(
        'Please enter the flavor notes of the coffee',
        name: 'AddCoffeeScreenFlavorNotesFormError',
        desc: '',
      );

  // list titles
  static String get addCofffeScreenRoastInformationLabel => Intl.message(
        'Roast Information',
        name: 'addCofffeScreenRoastInformationLabel',
        desc: '',
      );

  static String get AddCoffeeScreenRoastLevelFormLabel => Intl.message(
        'Roast Level',
        name: 'AddCoffeeScreenRoastLevelFormLabel',
        desc: '',
      );
  
  static String get AddCoffeeScreenRoastLevelFormLabelSub => Intl.message(
        '焙煎度',
        name: 'AddCoffeeScreenRoastLevelFormLabelSub',
        desc: '',
      );
  
  static String get AddCoffeeScreenRoastLevelFormError => Intl.message(
        'Please enter the roast level of the coffee',
        name: 'AddCoffeeScreenRoastLevelFormError',
        desc: '',
      );

  static String get AddCoffeeScreenRoastDateFormLabel => Intl.message(
        'Roast Date',
        name: 'AddCoffeeScreenRoastDateFormLabel',
        desc: '',
      );

  static String get AddCoffeeScreenRoastDateFormLabelSub => Intl.message(
        '焙煎日',
        name: 'AddCoffeeScreenRoastDateFormLabelSub',
        desc: '',
      );

  static String get AddCoffeeScreenRoastDateFormError => Intl.message(
        'Please enter the roast date of the coffee (yyyy/mm/dd)',
        name: 'AddCoffeeScreenRoastDateFormError',
        desc: '',
      );

  // list titles
  static String get addCofffeScreenStoreInformationLabel => Intl.message(
        'Store Information',
        name: 'addCofffeScreenStoreInformationLabel',
        desc: '',
      );

  static String get AddCoffeeScreenStoreNameFormLabel => Intl.message(
        'Store Name',
        name: 'AddCoffeeScreenStoreNameFormLabel',
        desc: '',
      );

  static String get AddCoffeeScreenStoreNameFormLabelSub => Intl.message(
        '店舗名',
        name: 'AddCoffeeScreenStoreNameFormLabelSub',
        desc: '',
      );

  static String get AddCoffeeScreenStoreNameFormError => Intl.message(
        'Please enter the store name of the coffee',
        name: 'AddCoffeeScreenStoreNameFormError',
        desc: '',
      );

  static String get AddCoffeeScreenStoreAddressFormLabel => Intl.message(
        'Store Address',
        name: 'AddCoffeeScreenStoreAddressFormLabel',
        desc: '',
      );

  static String get AddCoffeeScreenStoreAddressFormLabelSub => Intl.message(
        '店舗住所',
        name: 'AddCoffeeScreenStoreAddressFormLabelSub',
        desc: '',
      );

  static String get AddCoffeeScreenStoreAddressFormError => Intl.message(
        'Please enter the store address of the coffee',
        name: 'AddCoffeeScreenStoreAddressFormError',
        desc: '',
      );

  static String get AddCoffeeScreenStoreWebSiteFormLabel => Intl.message(
        'Website URL',
        name: 'AddCoffeeScreenStoreWebSiteFormLabel',
        desc: '',
      );

  static String get AddCoffeeScreenStoreWebSiteFormLabelSub => Intl.message(
        'ウェブサイトURL',
        name: 'AddCoffeeScreenStoreWebSiteFormLabelSub',
        desc: '',
      );

  static String get AddCoffeeScreenStoreWebSiteFormError => Intl.message(
        'Please enter the website URL of the coffee',
        name: 'AddCoffeeScreenStoreWebSiteFormError',
        desc: '',
      );

  //save button
  static String get addCofffeScreenSaveButton => Intl.message(
        'Save',
        name: 'addCofffeScreenSaveButton',
        desc: '',
      );
  
  //floating action button
  static String get addCofffeScreenFloatingActionButtonLabel => Intl.message(
        'Scan with AI',
        name: 'addCofffeScreenFloatingActionButtonLabel',
        desc: 'AI will analyze the photo and input the data'
      );

  static String get addCofffeScreenFloatingActionButtonToolTip => Intl.message(
        'AI will analyze the photo and input the data',
        name: 'addCofffeScreenFloatingActionButtonToolTip',
        desc: ''
      );
  
  //country picker
  static String get addCofffeScreenCountryPickerLabel => Intl.message(
        'Select Country',
        name: 'addCofffeScreenCountryPickerLabel',
        desc: ''
      );

  //roast level picker
  static String get addCofffeScreenRoastLevelPickerLabel => Intl.message(
        'Select from options', 
        name: 'addCofffeScreenRoastLevelPickerLabel',
        desc: ''
      );

  static String get addCofffeScreenRoastLevelPickerTitle => Intl.message(
        'Roast Level',
        name: 'addCofffeScreenRoastLevelPickerTitle',
        desc: ''
      );

  static String get addCofffeScreenRoastLevelPickerLight => Intl.message(
        'Light', 
        name: 'addCofffeScreenRoastLevelPickerLight',
        desc: ''
      );

  static String get addCofffeScreenRoastLevelPickerMedium => Intl.message(
        'Medium', 
        name: 'addCofffeScreenRoastLevelPickerMedium',
        desc: ''
      );

  static String get addCofffeScreenRoastLevelPickerDark => Intl.message(
        'Dark', 
        name: 'addCofffeScreenRoastLevelPickerDark',
        desc: ''
      );

  static String get addCofffeScreenRoastLevelPickerCinnamon => Intl.message(
        'Cinnamon',
        name: 'addCofffeScreenRoastLevelPickerCinnamon',
        desc: ''
      );

  static String get addCofffeScreenRoastLevelPickerHigh => Intl.message(
        'High',
        name: 'addCofffeScreenRoastLevelPickerHigh',
        desc: ''
      );

  static String get addCofffeScreenRoastLevelPickerCity => Intl.message(
        'City',
        name: 'addCofffeScreenRoastLevelPickerCity',
        desc: ''
      );

  static String get addCofffeScreenRoastLevelPickerFullCity => Intl.message(
        'Full City',
        name: 'addCofffeScreenRoastLevelPickerFullCity',
        desc: ''
      );

  static String get addCofffeScreenRoastLevelPickerItalian => Intl.message(
        'Italian',
        name: 'addCofffeScreenRoastLevelPickerItalian',
        desc: ''
      );

  //process picker
  static String get addCofffeScreenProcessPickerLabel => Intl.message(
        'Select from options', 
        name: 'addCofffeScreenProcessPickerLabel',
        desc: ''
      );

  static String get addCofffeScreenProcessPickerTitle => Intl.message(
        'Process',
        name: 'addCofffeScreenProcessPickerTitle',
        desc: ''
      );

  static String get addCofffeScreenProcessPickerWashed => Intl.message(
        'Washed', 
        name: 'addCofffeScreenProcessPickerWashed',
        desc: ''
      );

  static String get addCofffeScreenProcessPickerNatural => Intl.message(
        'Natural', 
        name: 'addCofffeScreenProcessPickerNatural',
        desc: ''
      );

  static String get addCofffeScreenProcessPickerHoney => Intl.message(
        'Honey', 
        name: 'addCofffeScreenProcessPickerHoney',
        desc: ''
      );

  static String get addCofffeScreenProcessPickerPulpedNatural => Intl.message(
        'Pulped Natural',
        name: 'addCofffeScreenProcessPickerPulpedNatural',
        desc: ''
      );

  static String get addCofffeScreenProcessPickerSemiWashed => Intl.message(
        'Semi Washed',
        name: 'addCofffeScreenProcessPickerSemiWashed',
        desc: ''
      );

  //fuly washed
  static String get addCofffeScreenProcessPickerFullyWashed => Intl.message(
        'Fully Washed',
        name: 'addCofffeScreenProcessPickerFullyWashed',
        desc: ''
      );

  static String get addCofffeScreenProcessPickerAnaerobic => Intl.message(
        'Anaerobic',
        name: 'addCofffeScreenProcessPickerAnaerobic',
        desc: ''
      );

  static String get addCofffeScreenProcessPickerCarbonicMaceration => Intl.message(
        'Carbonic Maceration',
        name: 'addCofffeScreenProcessPickerCarbonicMaceration',
        desc: ''
      );


  //variety picker
  static String get addCofffeScreenVarietyPickerLabel => Intl.message(
        'Select from options', 
        name: 'addCofffeScreenVarietyPickerLabel',
        desc: ''
      );

  static String get addCofffeScreenVarietyPickerTitle => Intl.message(
        'Variety',
        name: 'addCofffeScreenVarietyPickerTitle',
        desc: ''
      );

  static String get addCofffeScreenVarietyPickerTypica => Intl.message(
        'Typica', 
        name: 'addCofffeScreenVarietyPickerTypica',
        desc: ''
      );

  static String get addCofffeScreenVarietyPickerBourbon => Intl.message(
        'Bourbon', 
        name: 'addCofffeScreenVarietyPickerBourbon',
        desc: ''
      );

  static String get addCofffeScreenVarietyPickerCaturra => Intl.message(
        'Caturra', 
        name: 'addCofffeScreenVarietyPickerCaturra',
        desc: ''
      );

  static String get addCofffeScreenVarietyPickerCatuai => Intl.message(
        'Catuai',
        name: 'addCofffeScreenVarietyPickerCatuai',
        desc: ''
      );

  static String get addCofffeScreenVarietyPickerSL28 => Intl.message(
        'SL28',
        name: 'addCofffeScreenVarietyPickerSL28',
        desc: ''
      );

  static String get addCofffeScreenVarietyPickerSL34 => Intl.message(
        'SL34',
        name: 'addCofffeScreenVarietyPickerSL34',
        desc: ''
      );

  static String get addCofffeScreenVarietyPickerGeisha => Intl.message(
        'Geisha',
        name: 'addCofffeScreenVarietyPickerGeisha',
        desc: ''
      );

  static String get addCofffeScreenVarietyPickerMundoNovo => Intl.message(
        'Mundo Novo',
        name: 'addCofffeScreenVarietyPickerMundoNovo',
        desc: ''
      );

  static String get addCofffeScreenVarietyPickerMaragogipe => Intl.message(
        'Maragogipe',
        name: 'addCofffeScreenVarietyPickerMaragogipe',
        desc: ''
      );

  static String get addCofffeScreenVarietyPickerPacamara => Intl.message(
        'Pacamara',
        name: 'addCofffeScreenVarietyPickerPacamara',
        desc: ''
      );

  static String get addCofffeScreenVarietyPickerPacas => Intl.message(
        'Pacas',
        name: 'addCofffeScreenVarietyPickerPacas',
        desc: ''
      );

  static String get addCofffeScreenVarietyPickerPache => Intl.message(
        'Pache',
        name: 'addCofffeScreenVarietyPickerPache',
        desc: ''
      );

  static String get addCofffeScreenVarietyPickerSL14 => Intl.message(
        'SL14',
        name: 'addCofffeScreenVarietyPickerSL14',
        desc: ''
      );

  static String get addCofffeScreenVarietyPickerHeirloom => Intl.message(
        'Heirloom',
        name: 'addCofffeScreenVarietyPickerHeirloom',
        desc: ''
      );

  static String get addCofffeScreenVarietyPickerRobusta => Intl.message(
        'Robusta',
        name: 'addCofffeScreenVarietyPickerRobusta',
        desc: ''
      );

      
  
}