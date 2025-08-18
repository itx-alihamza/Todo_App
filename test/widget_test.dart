// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:template/screens/home/homePage.dart';

void main() {
  testWidgets('TODO app loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our TODO app title is present.
    expect(find.text('TODO APP'), findsOneWidget);
    
    // Verify that the floating action button is present.
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Tap the '+' icon to navigate to add task screen.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle(); // Wait for navigation animation

    // Verify that we're on the add task screen.
    expect(find.text('Add Task'), findsOneWidget);
  });
}
