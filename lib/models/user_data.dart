/// Holds the raw form input collected from the user on the calculator screen.
class UserData {
  final String name;
  final int age;
  final String gender;
  final double height; // cm
  final double weight; // kg
  final String activityLevel;

  const UserData({
    required this.name,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    required this.activityLevel,
  });
}

/// The BMI category enum with helper info (color key + description) is kept
/// in the service layer; this model only carries computed numeric results.
class BmiResult {
  final double bmi;
  final String category;
  final double idealWeight;
  final double weightDifference; // positive = need to gain, negative = lose
  final double bmr;
  final double maintenanceCalories;
  final double weightLossCalories;
  final double weightGainCalories;
  final double waterIntakeLiters;

  const BmiResult({
    required this.bmi,
    required this.category,
    required this.idealWeight,
    required this.weightDifference,
    required this.bmr,
    required this.maintenanceCalories,
    required this.weightLossCalories,
    required this.weightGainCalories,
    required this.waterIntakeLiters,
  });
}
