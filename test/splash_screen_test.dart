import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_bmi_analyzer/screens/splash/splash_screen.dart';

void main() {
  setUpAll(() {
    // Prevent google_fonts from trying to fetch fonts over the network
    // during tests (CI runners block/restrict this and it throws).
    GoogleFonts.config.allowRuntimeFetching = false;
  });

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