// Basic Flutter widget test for Кототиндер app

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_hw1/main.dart';

void main() {
  testWidgets('App starts and shows navigation bar', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app has a BottomNavigationBar
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Verify that the navigation items are present
    expect(find.text('Котики'), findsOneWidget);
    expect(find.text('Список пород'), findsOneWidget);
  });
}
