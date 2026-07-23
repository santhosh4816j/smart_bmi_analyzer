class WaterResult {
  final double liters;
  final int glasses; // ~250ml per glass

  WaterResult({required this.liters, required this.glasses});
}

class WaterService {
  /// A common, simple guideline: ~33ml per kg of bodyweight per day.
  static WaterResult calculate({required double weightKg}) {
    final liters = (weightKg * 0.033);
    final glasses = (liters * 1000 / 250).round();
    return WaterResult(liters: liters, glasses: glasses);
  }
}
