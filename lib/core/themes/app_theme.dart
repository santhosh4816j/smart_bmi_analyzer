import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Brand palette lifted from the Beach Weather logo:
/// deep navy wave, ocean blue, and sun gold.
class AppColors {
  static const navy = Color(0xFF0A2647);
  static const navyDark = Color(0xFF061A33);
  static const ocean = Color(0xFF2C9FDB);
  static const oceanLight = Color(0xFF7FD1F0);
  static const sunGold = Color(0xFFF5A623);
  static const sand = Color(0xFFFFF8EF);

  static const success = Color(0xFF2ECC71);
  static const warning = Color(0xFFF5A623);
  static const danger = Color(0xFFE74C3C);

  // BMI category colors
  static const underweight = Color(0xFF5DADE2);
  static const normal = Color(0xFF2ECC71);
  static const overweight = Color(0xFFF5A623);
  static const obese1 = Color(0xFFE67E22);
  static const obese2 = Color(0xFFE74C3C);
}

class AppTheme {
  static ThemeData get light => _base(Brightness.light);
  static ThemeData get dark => _base(Brightness.dark);

  static ThemeData _base(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme(
      brightness: brightness,
      primary: AppColors.ocean,
      onPrimary: Colors.white,
      secondary: AppColors.sunGold,
      onSecondary: AppColors.navyDark,
      error: AppColors.danger,
      onError: Colors.white,
      surface: isDark ? const Color(0xFF12233B) : Colors.white,
      onSurface: isDark ? Colors.white : AppColors.navyDark,
    );

    final textTheme = GoogleFonts.poppinsTextTheme(
      isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor:
          isDark ? const Color(0xFF0B1A2C) : AppColors.sand,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: isDark ? Colors.white : AppColors.navyDark,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : AppColors.navyDark,
        ),
      ),
      cardTheme: CardThemeData(
        color: isDark ? const Color(0xFF152A45) : Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.ocean,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF1C3352) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark ? const Color(0xFF12233B) : Colors.white,
        indicatorColor: AppColors.ocean.withValues(alpha: 0.15),
        elevation: 0,
      ),
    );
  }
}

/// Returns the color representing a BMI category.
Color colorForBmiCategory(String category) {
  switch (category) {
    case 'Underweight':
      return AppColors.underweight;
    case 'Normal':
      return AppColors.normal;
    case 'Overweight':
      return AppColors.overweight;
    case 'Obese Class I':
      return AppColors.obese1;
    case 'Obese Class II':
      return AppColors.obese2;
    default:
      return AppColors.ocean;
  }
}
