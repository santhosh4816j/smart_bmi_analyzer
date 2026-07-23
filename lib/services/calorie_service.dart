import '../models/user_data.dart';
import '../utils/constants.dart';

/// Business logic for BMR and daily calorie calculations.
class CalorieService {
  /// Calculates Basal Metabolic Rate using the Mifflin-St Jeor equation.
  /// Male:   10*weight + 6.25*height - 5*age + 5
  /// Female: 10*weight + 6.25*height - 5*age - 161
  static double calculateBmr({
    required String gender,
    required double weightKg,
    required double heightCm,
    required int age,
  }) {
    final base = 10 * weightKg + 6.25 * heightCm - 5 * age;
    return gender == 'Male' ? base + 5 : base - 161;
  }

  /// Applies the activity multiplier to BMR to get maintenance calories.
  static double maintenanceCalories({
    required double bmr,
    required String activityLevel,
  }) {
    final multiplier = AppConstants.activityMultipliers[activityLevel] ?? 1.2;
    return bmr * multiplier;
  }

  /// Standard deficit of ~500 kcal/day for a safe ~0.5kg/week weight loss.
  static double weightLossCalories(double maintenance) => maintenance - 500;

  /// Standard surplus of ~500 kcal/day for gradual, healthy weight gain.
  static double weightGainCalories(double maintenance) => maintenance + 500;

  /// Convenience method running all calorie calculations for a [UserData].
  static ({double bmr, double maintenance, double loss, double gain})
      analyze(UserData data) {
    final bmr = calculateBmr(
      gender: data.gender,
      weightKg: data.weight,
      heightCm: data.height,
      age: data.age,
    );
    final maintenance =
        maintenanceCalories(bmr: bmr, activityLevel: data.activityLevel);
    return (
      bmr: bmr,
      maintenance: maintenance,
      loss: weightLossCalories(maintenance),
      gain: weightGainCalories(maintenance),
    );
  }
}
