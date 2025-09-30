// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/di/injection_container.dart' as di;

void main() {
  testWidgets('App loads restaurant list page', (WidgetTester tester) async {
    // Initialize dependencies since tests don't run main()
    await di.initDependencies();
    await tester.pumpWidget(const MyApp());
    // Let initial BLoC load proceed
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Discover Restaurants'), findsOneWidget);
  });
}
