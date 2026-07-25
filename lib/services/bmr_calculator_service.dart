import '../constants/app_constants.dart';
import '../models/enums.dart';

class CalorieTargets {
  const CalorieTargets({
    required this.bmr,
    required this.maintenanceCalories,
    required this.mildWeightLossCalories,
    required this.weightLossCalories,
    required this.mildWeightGainCalories,
    required this.weightGainCalories,
  });

  final double bmr;
  final double maintenanceCalories;
  final double mildWeightLossCalories;
  final double weightLossCalories;
  final double mildWeightGainCalories;
  final double weightGainCalories;
}

/// Mifflin-St Jeor BMR/TDEE math — the most accurate widely-used formula
/// for a general population, per the American Dietetic Association.
abstract final class BmrCalculatorService {
  static double activityMultiplier(ActivityLevel level) => switch (level) {
        ActivityLevel.sedentary => AppConstants.activitySedentary,
        ActivityLevel.light => AppConstants.activityLight,
        ActivityLevel.moderate => AppConstants.activityModerate,
        ActivityLevel.active => AppConstants.activityActive,
        ActivityLevel.veryActive => AppConstants.activityVeryActive,
      };

  static double calculateBmr({
    required double weightKg,
    required double heightCm,
    required int age,
    required BiologicalSex sex,
  }) {
    final double base = (10 * weightKg) + (6.25 * heightCm) - (5 * age);
    return sex == BiologicalSex.male ? base + 5 : base - 161;
  }

  static CalorieTargets calculate({
    required double weightKg,
    required double heightCm,
    required int age,
    required BiologicalSex sex,
    required ActivityLevel activityLevel,
  }) {
    final double bmr =
        calculateBmr(weightKg: weightKg, heightCm: heightCm, age: age, sex: sex);
    final double maintenance = bmr * activityMultiplier(activityLevel);

    return CalorieTargets(
      bmr: bmr,
      maintenanceCalories: maintenance,
      mildWeightLossCalories:
          maintenance - AppConstants.mildWeightLossDeficit,
      weightLossCalories: maintenance - AppConstants.weightLossDeficit,
      mildWeightGainCalories:
          maintenance + AppConstants.mildWeightGainSurplus,
      weightGainCalories: maintenance + AppConstants.weightGainSurplus,
    );
  }

  /// Recommended daily water intake in liters — a widely used rule of
  /// thumb of ~35 ml per kg of body weight.
  static double recommendedWaterLiters(double weightKg) =>
      (weightKg * 35) / 1000;
}
