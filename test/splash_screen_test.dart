import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_bmi_analyzer/screens/splash/splash_screen.dart';

void main() {
  testWidgets('SplashScreen renders the app name', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SplashScreen()),
    );

    expect(find.text('Smart BMI Analyzer'), findsOneWidget);
    expect(find.text('by Beachweather'), findsOneWidget);

    // Avoid the pending navigation timer firing after the test disposes
    // the widget tree.
    await tester.pump(const Duration(milliseconds: 2000));
  });
}
