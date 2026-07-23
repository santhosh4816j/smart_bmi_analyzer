import 'package:flutter/material.dart';
import '../models/user_data.dart';
import '../theme/app_colors.dart';

/// Business logic for computing BMI, category, and ideal weight.
/// Kept completely separate from the UI layer.
class BmiService {
  /// Calculates BMI given weight (kg) and height (cm).
  /// Formula: BMI = weight / (height_in_meters ^ 2)
  static double calculateBmi({required double weightKg, required double heightCm}) {
    final heightM = heightCm / 100;
    if (heightM <= 0) return 0;
    return weightKg / (heightM * heightM);
  }

  /// Returns the BMI category label for a given BMI score.
  static String categoryFor(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  /// Returns a short, friendly description for a BMI category.
  static String descriptionFor(String category) {
    switch (category) {
      case 'Underweight':
        return 'Your weight is below the healthy range for your height. '
            'Consider a nutrient-rich diet to gain weight gradually.';
      case 'Normal':
        return 'Great job! Your weight is within the healthy range for '
            'your height. Keep maintaining a balanced lifestyle.';
      case 'Overweight':
        return 'Your weight is above the healthy range for your height. '
            'A balanced diet and regular activity can help you reach a '
            'healthier BMI.';
      case 'Obese':
        default:
        return 'Your BMI indicates a significantly higher weight range. '
            'Consider consulting a healthcare professional and adopting '
            'sustainable lifestyle changes.';
    }
  }

  /// Maps a BMI category to its representative color.
  static Color colorFor(String category) {
    switch (category) {
      case 'Underweight':
        return AppColors.underweight;
      case 'Normal':
        return AppColors.normal;
      case 'Overweight':
        return AppColors.overweight;
      case 'Obese':
      default:
        return AppColors.obese;
    }
  }

  /// Calculates the ideal weight (kg) for a given height, using BMI = 22
  /// as the healthy reference point (midpoint of the normal BMI range).
  static double idealWeightFor(double heightCm) {
    final heightM = heightCm / 100;
    return 22 * heightM * heightM;
  }

  /// Returns weight difference: positive means the user should gain weight,
  /// negative means the user should lose weight, to reach their ideal weight.
  static double weightDifference({
    required double currentWeight,
    required double idealWeight,
  }) {
    return idealWeight - currentWeight;
  }

  /// Runs the full BMI + ideal weight analysis for the given user input.
  static ({double bmi, String category, double idealWeight, double diff})
      analyze(UserData data) {
    final bmi = calculateBmi(weightKg: data.weight, heightCm: data.height);
    final category = categoryFor(bmi);
    final ideal = idealWeightFor(data.height);
    final diff = weightDifference(currentWeight: data.weight, idealWeight: ideal);
    return (bmi: bmi, category: category, idealWeight: ideal, diff: diff);
  }
}
