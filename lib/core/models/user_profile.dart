import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 0)
enum Gender {
  @HiveField(0)
  male,
  @HiveField(1)
  female,
  @HiveField(2)
  other,
}

@HiveType(typeId: 1)
enum ActivityLevel {
  @HiveField(0)
  sedentary,
  @HiveField(1)
  lightlyActive,
  @HiveField(2)
  moderatelyActive,
  @HiveField(3)
  veryActive,
  @HiveField(4)
  athlete,
}

extension ActivityLevelX on ActivityLevel {
  String get label {
    switch (this) {
      case ActivityLevel.sedentary:
        return 'Sedentary';
      case ActivityLevel.lightlyActive:
        return 'Lightly Active';
      case ActivityLevel.moderatelyActive:
        return 'Moderately Active';
      case ActivityLevel.veryActive:
        return 'Very Active';
      case ActivityLevel.athlete:
        return 'Athlete';
    }
  }

  String get description {
    switch (this) {
      case ActivityLevel.sedentary:
        return 'Little or no exercise';
      case ActivityLevel.lightlyActive:
        return 'Light exercise 1-3 days/week';
      case ActivityLevel.moderatelyActive:
        return 'Moderate exercise 3-5 days/week';
      case ActivityLevel.veryActive:
        return 'Hard exercise 6-7 days/week';
      case ActivityLevel.athlete:
        return 'Very hard exercise, physical job, or 2x training';
    }
  }

  /// Multiplier applied to BMR to estimate total daily energy expenditure.
  double get multiplier {
    switch (this) {
      case ActivityLevel.sedentary:
        return 1.2;
      case ActivityLevel.lightlyActive:
        return 1.375;
      case ActivityLevel.moderatelyActive:
        return 1.55;
      case ActivityLevel.veryActive:
        return 1.725;
      case ActivityLevel.athlete:
        return 1.9;
    }
  }
}

@HiveType(typeId: 2)
enum UnitSystem {
  @HiveField(0)
  metric,
  @HiveField(1)
  imperial,
}

@HiveType(typeId: 3)
class UserProfile extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int age;

  @HiveField(2)
  Gender gender;

  @HiveField(3)
  double heightCm;

  @HiveField(4)
  double weightKg;

  @HiveField(5)
  ActivityLevel activityLevel;

  @HiveField(6)
  UnitSystem unitSystem;

  @HiveField(7)
  DateTime createdAt;

  UserProfile({
    required this.name,
    required this.age,
    required this.gender,
    required this.heightCm,
    required this.weightKg,
    required this.activityLevel,
    this.unitSystem = UnitSystem.metric,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
