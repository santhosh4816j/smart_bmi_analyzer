/// App-wide constant values used across screens and services.
class AppConstants {
  AppConstants._();

  static const String appName = 'Smart BMI Analyzer';
  static const String appVersion = '1.0.0';
  static const String developerName = 'Smart BMI Analyzer Team';
  static const String appPurpose =
      'Smart BMI Analyzer helps you calculate your Body Mass Index, '
      'discover your ideal weight, estimate daily calorie needs, track '
      'your water intake, and get personalized food and exercise '
      'recommendations — all completely offline.';

  // Hive box names
  static const String bmiHistoryBox = 'bmi_history_box';
  static const String settingsBox = 'settings_box';

  // Shared preferences keys
  static const String prefThemeMode = 'pref_theme_mode';

  // Activity level multipliers (Harris-Benedict / Mifflin adjusted)
  static const Map<String, double> activityMultipliers = {
    'Sedentary (little or no exercise)': 1.2,
    'Lightly active (1-3 days/week)': 1.375,
    'Moderately active (3-5 days/week)': 1.55,
    'Very active (6-7 days/week)': 1.725,
    'Super active (athlete/physical job)': 1.9,
  };

  static const List<String> activityLevels = [
    'Sedentary (little or no exercise)',
    'Lightly active (1-3 days/week)',
    'Moderately active (3-5 days/week)',
    'Very active (6-7 days/week)',
    'Super active (athlete/physical job)',
  ];

  static const List<String> genders = ['Male', 'Female'];
}
