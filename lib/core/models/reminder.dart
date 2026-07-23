import 'package:hive/hive.dart';

part 'reminder.g.dart';

@HiveType(typeId: 5)
enum ReminderType {
  @HiveField(0)
  water,
  @HiveField(1)
  exercise,
  @HiveField(2)
  measureWeight,
  @HiveField(3)
  eatHealthy,
  @HiveField(4)
  protein,
  @HiveField(5)
  custom,
}

extension ReminderTypeX on ReminderType {
  String get label {
    switch (this) {
      case ReminderType.water:
        return 'Drink Water';
      case ReminderType.exercise:
        return 'Exercise';
      case ReminderType.measureWeight:
        return 'Measure Weight';
      case ReminderType.eatHealthy:
        return 'Eat Healthy';
      case ReminderType.protein:
        return 'Take Protein';
      case ReminderType.custom:
        return 'Custom Reminder';
    }
  }

  String get emoji {
    switch (this) {
      case ReminderType.water:
        return '💧';
      case ReminderType.exercise:
        return '🏃';
      case ReminderType.measureWeight:
        return '⚖️';
      case ReminderType.eatHealthy:
        return '🥗';
      case ReminderType.protein:
        return '🍗';
      case ReminderType.custom:
        return '⏰';
    }
  }
}

@HiveType(typeId: 6)
class Reminder extends HiveObject {
  @HiveField(0)
  int notificationId;

  @HiveField(1)
  ReminderType type;

  @HiveField(2)
  String label;

  @HiveField(3)
  int hour;

  @HiveField(4)
  int minute;

  @HiveField(5)
  bool enabled;

  @HiveField(6)
  List<int> repeatDays; // 1 = Monday ... 7 = Sunday, empty = daily

  Reminder({
    required this.notificationId,
    required this.type,
    required this.label,
    required this.hour,
    required this.minute,
    this.enabled = true,
    this.repeatDays = const [],
  });
}
