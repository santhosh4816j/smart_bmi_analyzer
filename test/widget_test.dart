import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_bmi_analyzer/screens/splash/splash_screen.dart';

void main() {
  testWidgets('App shell renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SplashScreen()),
    );

    expect(find.byType(SplashScreen), findsOneWidget);

    // Avoid the pending navigation timer firing after the test disposes
    // the widget tree.
    await tester.pump(const Duration(milliseconds: 2000));
  });
}
