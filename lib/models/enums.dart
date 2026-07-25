/// Biological sex as used by BMR formulas (Mifflin-St Jeor requires this
/// distinction). Not a statement about gender identity — kept narrow and
/// only used for the calorie math.
enum BiologicalSex {
  male,
  female;

  String get label => this == BiologicalSex.male ? 'Male' : 'Female';
}

enum ActivityLevel {
  sedentary,
  light,
  moderate,
  active,
  veryActive;

  String get label => switch (this) {
        ActivityLevel.sedentary => 'Sedentary (little/no exercise)',
        ActivityLevel.light => 'Light (1-3 days/week)',
        ActivityLevel.moderate => 'Moderate (3-5 days/week)',
        ActivityLevel.active => 'Active (6-7 days/week)',
        ActivityLevel.veryActive => 'Very active (athlete)',
      };
}

enum FitnessGoal {
  loseWeight,
  maintainWeight,
  gainWeight,
  buildMuscle;

  String get label => switch (this) {
        FitnessGoal.loseWeight => 'Lose Weight',
        FitnessGoal.maintainWeight => 'Maintain Weight',
        FitnessGoal.gainWeight => 'Gain Weight',
        FitnessGoal.buildMuscle => 'Build Muscle',
      };
}

enum UnitSystem { metric, imperial }

enum DietPreference {
  vegetarian,
  nonVegetarian,
  vegan,
  eggetarian;

  String get label => switch (this) {
        DietPreference.vegetarian => 'Vegetarian',
        DietPreference.nonVegetarian => 'Non-Vegetarian',
        DietPreference.vegan => 'Vegan',
        DietPreference.eggetarian => 'Eggetarian',
      };
}

enum BmiCategory {
  underweight,
  normal,
  overweight,
  obeseClassI,
  obeseClassII,
  obeseClassIII;

  String get label => switch (this) {
        BmiCategory.underweight => 'Underweight',
        BmiCategory.normal => 'Normal weight',
        BmiCategory.overweight => 'Overweight',
        BmiCategory.obeseClassI => 'Obese (Class I)',
        BmiCategory.obeseClassII => 'Obese (Class II)',
        BmiCategory.obeseClassIII => 'Obese (Class III)',
      };
}
