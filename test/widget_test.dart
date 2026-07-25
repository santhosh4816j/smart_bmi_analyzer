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

  testWidgets('App shell renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SplashScreen(nextScreenBuilder: () => const SizedBox.shrink()),
      ),
    );

    expect(find.byType(SplashScreen), findsOneWidget);

    // Avoid the pending navigation timer firing after the test disposes
    // the widget tree.
    await tester.pump(const Duration(milliseconds: 2000));
  });
}