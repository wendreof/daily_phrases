// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:daily_phrases/main.dart';

void main() {
  testWidgets('Tap on share and change color', (tester) async {
    await tester.runAsync(() async {
      final Widget testWidget = MediaQuery(
          data: MediaQueryData(),
          child: MaterialApp(
              home: MyHomePage(
            title: 'Daily Phrase',
            theme: 'light',
          )));

      await tester.pumpWidget(testWidget, Duration(seconds: 30));

      // Verify that title is corret
      expect(find.text('Daily Phrase'), findsOneWidget);
      // Verify really there is not a text 1
      expect(find.text('1'), findsNothing);
      // Verify really there is not a text frase
      expect(find.textContaining('frase'), findsNothing);
    });
  });

  testWidgets('Tap on share', (tester) async {
    await tester.runAsync(() async {
      final Widget testWidget = MediaQuery(
          data: MediaQueryData(),
          child: MaterialApp(
              home: MyHomePage(
            title: 'Daily Phrase',
            theme: 'dark',
          )));

      await tester.pumpWidget(testWidget, Duration(seconds: 60));

      // Verify that title is corret
      expect(find.text('Daily Phrase'), findsOneWidget);
      // Verify really there is not a text 1
      expect(find.text('1'), findsNothing);
      // Verify really there is not a text frase
      expect(find.textContaining('frase'), findsNothing);

      //Tap on update phrase
      await tester.tap(find.byIcon(Icons.share));
      ;
    });
  });
}
