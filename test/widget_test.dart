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
  testWidgets('Clica no botão atualizar frase', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MyApp(), Duration(minutes: 1));

      await tester.pump(Duration(seconds: 3));

      expect(find.text('Frase Diária'), findsOneWidget);
      expect(find.textContaining('flutter'), findsNothing);

      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pump(Duration(minutes: 1));

      expect(find.text('Carregando...'), findsNothing);

      expect(find.text('Frase Diária'), findsOneWidget);
      expect(find.textContaining('flutter'), findsNothing);
    });
  });
}
