/// Central home for constants used across the app so no magic numbers
/// or literals are scattered through UI/business logic.
abstract final class AppConstants {
  static const String appName = 'Smart BMI Analyzer';
  static const String appBrand = 'Beachweather';
  static const String appTagline = 'by Beachweather';

  // Hive box names
  static const String profileBoxName = 'profiles_box';
  static const String bmiRecordBoxName = 'bmi_records_box';
  static const String settingsBoxName = 'settings_box';

  // Shared preferences keys
  static const String prefThemeMode = 'pref_theme_mode';
  static const String prefUnitSystem = 'pref_unit_system';
  static const String prefAccentColor = 'pref_accent_color';
  static const String prefActiveProfileId = 'pref_active_profile_id';

  // BMI category thresholds (WHO standard, kg/m²)
  static const double bmiUnderweightMax = 18.5;
  static const double bmiNormalMax = 24.9;
  static const double bmiOverweightMax = 29.9;
  static const double bmiObeseIMax = 34.9;
  static const double bmiObeseIIMax = 39.9;

  // Activity level multipliers for TDEE (Mifflin-St Jeor)
  static const double activitySedentary = 1.2;
  static const double activityLight = 1.375;
  static const double activityModerate = 1.55;
  static const double activityActive = 1.725;
  static const double activityVeryActive = 1.9;

  // Calorie deficits/surplus for goals (kcal/day)
  static const int mildWeightLossDeficit = 250;
  static const int weightLossDeficit = 500;
  static const int mildWeightGainSurplus = 250;
  static const int weightGainSurplus = 500;

  // Unit conversions
  static const double kgToLb = 2.20462;
  static const double cmToInch = 0.393701;
  static const double lbToKg = 1 / kgToLb;
  static const double inchToCm = 1 / cmToInch;

  static const int splashDurationMs = 1800;
}
