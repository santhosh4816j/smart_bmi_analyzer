import '../models/user_profile.dart';

class CalorieResult {
  final double bmr;
  final double maintenance;
  final double weightLoss;
  final double weightGain;

  CalorieResult({
    required this.bmr,
    required this.maintenance,
    required this.weightLoss,
    required this.weightGain,
  });
}

class CalorieService {
  /// Mifflin-St Jeor equation for Basal Metabolic Rate.
  static double bmr({
    required Gender gender,
    required double weightKg,
    required double heightCm,
    required int age,
  }) {
    final base = (10 * weightKg) + (6.25 * heightCm) - (5 * age);
    switch (gender) {
      case Gender.male:
        return base + 5;
      case Gender.female:
        return base - 161;
      case Gender.other:
        return base - 78; // midpoint approximation
    }
  }

  static CalorieResult calculate({
    required Gender gender,
    required double weightKg,
    required double heightCm,
    required int age,
    required ActivityLevel activityLevel,
  }) {
    final b = bmr(gender: gender, weightKg: weightKg, heightCm: heightCm, age: age);
    final maintenance = b * activityLevel.multiplier;
    return CalorieResult(
      bmr: b,
      maintenance: maintenance,
      // A ~500 kcal/day deficit/surplus is the standard sustainable rate,
      // roughly equating to ~0.5 kg/week change.
      weightLoss: maintenance - 500,
      weightGain: maintenance + 500,
    );
  }
}
