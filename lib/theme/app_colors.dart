import 'package:flutter/material.dart';

/// Centralized color palette for the app, including BMI category colors.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF4C6FFF);
  static const Color primaryDark = Color(0xFF2F49C7);
  static const Color secondary = Color(0xFF00C2A8);

  static const Color underweight = Color(0xFF3B82F6); // Blue
  static const Color normal = Color(0xFF22C55E); // Green
  static const Color overweight = Color(0xFFF97316); // Orange
  static const Color obese = Color(0xFFEF4444); // Red

  static const Color lightBackground = Color(0xFFF5F7FB);
  static const Color darkBackground = Color(0xFF121417);
  static const Color lightCard = Colors.white;
  static const Color darkCard = Color(0xFF1E2126);

  static const List<Color> primaryGradient = [
    Color(0xFF4C6FFF),
    Color(0xFF00C2A8),
  ];
}
