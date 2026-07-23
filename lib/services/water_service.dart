/// Business logic for daily water intake recommendation.
class WaterService {
  /// Recommends daily water intake in liters, using weight(kg) * 35ml.
  static double recommendedIntakeLiters(double weightKg) {
    final ml = weightKg * 35;
    return ml / 1000;
  }
}
