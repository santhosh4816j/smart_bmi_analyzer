import 'package:hive/hive.dart';

part 'goal.g.dart';

@HiveType(typeId: 8)
enum Objective {
  @HiveField(0)
  loseWeight,
  @HiveField(1)
  maintain,
  @HiveField(2)
  gainMuscle,
}

extension ObjectiveX on Objective {
  String get label {
    switch (this) {
      case Objective.loseWeight:
        return 'Weight Loss';
      case Objective.maintain:
        return 'Maintenance';
      case Objective.gainMuscle:
        return 'Muscle Gain';
    }
  }
}

@HiveType(typeId: 9)
class DailyGoal extends HiveObject {
  @HiveField(0)
  Objective objective;

  @HiveField(1)
  double calorieTarget;

  @HiveField(2)
  double proteinTargetG;

  @HiveField(3)
  double waterTargetL;

  @HiveField(4)
  double? targetWeightKg;

  DailyGoal({
    required this.objective,
    required this.calorieTarget,
    required this.proteinTargetG,
    required this.waterTargetL,
    this.targetWeightKg,
  });
}

/// A single day's logged progress toward the active goal.
/// Keyed by date string (yyyy-MM-dd) in DailyProgressBox.
@HiveType(typeId: 10)
class DailyProgress extends HiveObject {
  @HiveField(0)
  String dateKey;

  @HiveField(1)
  double caloriesConsumed;

  @HiveField(2)
  double proteinConsumedG;

  @HiveField(3)
  double waterConsumedL;

  DailyProgress({
    required this.dateKey,
    this.caloriesConsumed = 0,
    this.proteinConsumedG = 0,
    this.waterConsumedL = 0,
  });
}
