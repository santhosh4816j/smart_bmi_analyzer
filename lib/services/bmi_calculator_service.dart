import 'dart:math' as math;

import '../constants/app_constants.dart';
import '../models/enums.dart';

/// Result bundle returned by [BmiCalculatorService.analyze].
class BmiAnalysisResult {
  const BmiAnalysisResult({
    required this.bmi,
    required this.category,
    required this.idealWeightRangeKg,
    required this.bodyFatPercentEstimate,
    required this.bodySurfaceAreaM2,
    required this.healthRiskNote,
    required this.advice,
  });

  final double bmi;
  final BmiCategory category;
  final (double min, double max) idealWeightRangeKg;
  final double bodyFatPercentEstimate;
  final double bodySurfaceAreaM2;
  final String healthRiskNote;
  final List<String> advice;
}

/// Pure, stateless BMI/body-composition math. No I/O, fully unit-testable.
abstract final class BmiCalculatorService {
  static double calculateBmi({
    required double weightKg,
    required double heightCm,
  }) {
    final double heightM = heightCm / 100;
    return weightKg / (heightM * heightM);
  }

  static BmiCategory categoryFor(double bmi) {
    if (bmi < AppConstants.bmiUnderweightMax) return BmiCategory.underweight;
    if (bmi <= AppConstants.bmiNormalMax) return BmiCategory.normal;
    if (bmi <= AppConstants.bmiOverweightMax) return BmiCategory.overweight;
    if (bmi <= AppConstants.bmiObeseIMax) return BmiCategory.obeseClassI;
    if (bmi <= AppConstants.bmiObeseIIMax) return BmiCategory.obeseClassII;
    return BmiCategory.obeseClassIII;
  }

  /// Devine-formula-based healthy weight range for the given height,
  /// expressed as the weight range that maps to a BMI of 18.5–24.9.
  static (double, double) idealWeightRangeKg(double heightCm) {
    final double heightM = heightCm / 100;
    final double min = AppConstants.bmiUnderweightMax * heightM * heightM;
    final double max = AppConstants.bmiNormalMax * heightM * heightM;
    return (min, max);
  }

  /// Deurenberg formula: body fat % from BMI, age, and sex.
  static double bodyFatPercentEstimate({
    required double bmi,
    required int age,
    required BiologicalSex sex,
  }) {
    final int sexFactor = sex == BiologicalSex.male ? 1 : 0;
    return (1.20 * bmi) + (0.23 * age) - (10.8 * sexFactor) - 5.4;
  }

  /// Mosteller formula for body surface area (m²).
  static double bodySurfaceAreaM2({
    required double weightKg,
    required double heightCm,
  }) {
    return math.sqrt((heightCm * weightKg) / 3600);
  }

  static String healthRiskNoteFor(BmiCategory category) => switch (category) {
        BmiCategory.underweight =>
          'Increased risk of nutritional deficiency and weakened immunity.',
        BmiCategory.normal => 'Lowest risk range for weight-related disease.',
        BmiCategory.overweight =>
          'Mildly elevated risk of cardiovascular strain and type 2 diabetes.',
        BmiCategory.obeseClassI =>
          'Moderately elevated risk of heart disease, hypertension, and diabetes.',
        BmiCategory.obeseClassII =>
          'High risk of cardiovascular disease, diabetes, and joint strain.',
        BmiCategory.obeseClassIII =>
          'Very high risk — clinical guidance strongly recommended.',
      };

  static List<String> adviceFor(BmiCategory category) => switch (category) {
        BmiCategory.underweight => const <String>[
            'Increase calorie intake with nutrient-dense foods.',
            'Add strength training to build lean mass, not just weight.',
            'Consider a check-up to rule out underlying causes.',
          ],
        BmiCategory.normal => const <String>[
            'Maintain your current habits — this range is associated with lowest risk.',
            'Keep a mix of cardio and strength training for long-term health.',
            'Recheck your BMI periodically as weight naturally fluctuates.',
          ],
        BmiCategory.overweight => const <String>[
            'A modest calorie deficit of 250–500 kcal/day is a sustainable start.',
            'Aim for 150+ minutes of moderate activity per week.',
            'Prioritize protein and fiber to stay full on fewer calories.',
          ],
        BmiCategory.obeseClassI ||
        BmiCategory.obeseClassII ||
        BmiCategory.obeseClassIII =>
          const <String>[
            'Consider consulting a healthcare provider for a personalized plan.',
            'Small, consistent changes (walking daily, reducing sugary drinks) compound over time.',
            'Track weight weekly rather than daily to see the real trend.',
          ],
      };

  static BmiAnalysisResult analyze({
    required double weightKg,
    required double heightCm,
    required int age,
    required BiologicalSex sex,
  }) {
    final double bmi = calculateBmi(weightKg: weightKg, heightCm: heightCm);
    final BmiCategory category = categoryFor(bmi);
    return BmiAnalysisResult(
      bmi: bmi,
      category: category,
      idealWeightRangeKg: idealWeightRangeKg(heightCm),
      bodyFatPercentEstimate:
          bodyFatPercentEstimate(bmi: bmi, age: age, sex: sex),
      bodySurfaceAreaM2:
          bodySurfaceAreaM2(weightKg: weightKg, heightCm: heightCm),
      healthRiskNote: healthRiskNoteFor(category),
      advice: adviceFor(category),
    );
  }
}
