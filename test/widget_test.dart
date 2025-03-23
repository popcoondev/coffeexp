// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:coffeexp/firebase_options.dart';
import 'package:coffeexp/screens/home_screen.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coffeexp/main.dart';

import 'mock.dart';

void main() {
  setupFirebaseAuthMocks();
  setUpAll(() async {
    await Firebase.initializeApp();
      // Firebase Authをモックしてサインイン状態をシミュレートする
    final user = MockUser(
      isAnonymous: false,
      uid: 'someuid',
      email: 'bob@somedomain.com',
      displayName: 'Bob',
    );

    final auth = MockFirebaseAuth(mockUser: user);
    final result = await auth.signInWithEmailAndPassword(
      email: 'bob@somedomain.com',
      password : '123456',
    );
    
    
    print(user.displayName);
    print(user.email);
    print(user.uid);
    print(auth.currentUser);
    print(result.user);
  });
  
  testWidgets('Home Screen test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget( MaterialApp(
      home: HomeScreen(),
    ));

    debugPrint('Home Screen rendered'); // ここまで到達するか確認

    var finder = find.byKey(Key('home_screen'));
    debugPrint(finder.toString());
    expect(finder, findsOneWidget);

  });

}
