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

}