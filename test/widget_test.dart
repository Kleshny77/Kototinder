// Basic Flutter widget test for Кототиндер app

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_hw1/main.dart';

void main() {
  testWidgets('App starts and shows gate (loading then onboarding or login or main)', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Either still loading or one of: onboarding, login, main
    final hasLoading = find.byType(CircularProgressIndicator).evaluate().isNotEmpty;
    final hasNavBar = find.byType(BottomNavigationBar).evaluate().isNotEmpty;
    final hasKototinder = find.text('Кототиндер').evaluate().isNotEmpty;
    final hasLogin = find.text('Вход').evaluate().isNotEmpty;
    final hasOnboarding = find.text('Свайпай котиков').evaluate().isNotEmpty;

    expect(hasLoading || hasNavBar || hasKototinder || hasLogin || hasOnboarding, isTrue);
  });
}
