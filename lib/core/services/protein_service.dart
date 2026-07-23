import '../models/goal.dart';

class ProteinService {
  /// Returns recommended protein range (min, max) in grams/day based on
  /// bodyweight and objective.
  static (double min, double max) rangeFor({
    required double weightKg,
    required Objective objective,
  }) {
    switch (objective) {
      case Objective.maintain:
        return (weightKg * 1.0, weightKg * 1.2);
      case Objective.gainMuscle:
        return (weightKg * 1.6, weightKg * 2.2);
      case Objective.loseWeight:
        return (weightKg * 1.2, weightKg * 1.8);
    }
  }

  static double recommendedFor({
    required double weightKg,
    required Objective objective,
  }) {
    final (min, max) = rangeFor(weightKg: weightKg, objective: objective);
    return (min + max) / 2;
  }
}
