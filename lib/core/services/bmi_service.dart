/// Pure calculation logic for BMI. No Flutter dependencies so it is
/// trivially unit-testable.
class BmiResult {
  final double bmi;
  final String category;
  final double healthyMinKg;
  final double healthyMaxKg;
  final double weightToGoalKg; // positive = needs to lose, negative = needs to gain

  BmiResult({
    required this.bmi,
    required this.category,
    required this.healthyMinKg,
    required this.healthyMaxKg,
    required this.weightToGoalKg,
  });
}

class BmiService {
  /// Standard BMI formula: weight(kg) / height(m)^2
  static double calculate({required double weightKg, required double heightCm}) {
    final heightM = heightCm / 100;
    if (heightM <= 0) return 0;
    return weightKg / (heightM * heightM);
  }

  static String categoryFor(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    if (bmi < 35) return 'Obese Class I';
    return 'Obese Class II';
  }

  /// Healthy weight range for a given height, using the standard
  /// BMI 18.5–24.9 band.
  static BmiResult evaluate({required double weightKg, required double heightCm}) {
    final heightM = heightCm / 100;
    final minKg = 18.5 * heightM * heightM;
    final maxKg = 24.9 * heightM * heightM;
    final bmi = calculate(weightKg: weightKg, heightCm: heightCm);

    double diff = 0;
    if (weightKg > maxKg) {
      diff = weightKg - maxKg; // needs to lose
    } else if (weightKg < minKg) {
      diff = weightKg - minKg; // negative -> needs to gain
    }

    return BmiResult(
      bmi: bmi,
      category: categoryFor(bmi),
      healthyMinKg: minKg,
      healthyMaxKg: maxKg,
      weightToGoalKg: diff,
    );
  }

  static String tipFor(String category) {
    switch (category) {
      case 'Underweight':
        return 'Focus on nutrient-dense meals and a modest calorie surplus '
            'with adequate protein to build healthy weight.';
      case 'Normal':
        return 'Great work — maintain your current habits with balanced '
            'meals and regular activity.';
      case 'Overweight':
        return 'A moderate calorie deficit combined with regular activity '
            'can help bring your BMI back into the normal range.';
      case 'Obese Class I':
        return 'Consider a structured plan combining diet, activity, and '
            'consistent tracking — small sustainable changes add up.';
      default:
        return 'A gradual, sustainable calorie deficit paired with medical '
            'guidance is recommended for long-term results.';
    }
  }
}
