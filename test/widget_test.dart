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
      // Build our app and trigger a frame.
      await tester.pumpWidget(MyApp(), Duration(seconds: 30));

      await tester.pump(Duration(seconds: 30));

      expect(find.text('Daily Phrase'), findsOneWidget);
      expect(find.textContaining('frase'), findsNothing);

      await tester.tap(find.byIcon(Icons.color_lens));
      await tester.tap(find.byIcon(Icons.share));
      //await tester.tap(find.byTooltip('New Phrase'));
      // await tester.pump(Duration(minutes: 1));

      expect(find.text('Daily Phrase'), findsOneWidget);
      expect(find.textContaining('frase'), findsNothing);
    });
  });
}
