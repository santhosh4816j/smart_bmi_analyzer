import 'package:hive_flutter/hive_flutter.dart';

import '../models/user_profile.dart';
import '../models/weight_record.dart';
import '../models/reminder.dart';
import '../models/food_item.dart';
import '../models/goal.dart';
import '../../data/food_database.dart';

/// Central place for Hive box names + one-time setup. Keeping this in one
/// file avoids "magic string" box names scattered across the app.
class HiveBoxes {
  static const profile = 'profileBox';
  static const weightHistory = 'weightHistoryBox';
  static const reminders = 'remindersBox';
  static const foods = 'foodsBox';
  static const goals = 'goalsBox';
  static const dailyProgress = 'dailyProgressBox';
  static const preferences = 'preferencesBox';

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(GenderAdapter());
    Hive.registerAdapter(ActivityLevelAdapter());
    Hive.registerAdapter(UnitSystemAdapter());
    Hive.registerAdapter(UserProfileAdapter());
    Hive.registerAdapter(WeightRecordAdapter());
    Hive.registerAdapter(ReminderTypeAdapter());
    Hive.registerAdapter(ReminderAdapter());
    Hive.registerAdapter(FoodItemAdapter());
    Hive.registerAdapter(ObjectiveAdapter());
    Hive.registerAdapter(DailyGoalAdapter());
    Hive.registerAdapter(DailyProgressAdapter());

    await Hive.openBox<UserProfile>(profile);
    await Hive.openBox<WeightRecord>(weightHistory);
    await Hive.openBox<Reminder>(reminders);
    await Hive.openBox<FoodItem>(foods);
    await Hive.openBox<DailyGoal>(goals);
    await Hive.openBox<DailyProgress>(dailyProgress);
    await Hive.openBox(preferences);

    await _seedFoodDatabaseIfEmpty();
  }

  static Future<void> _seedFoodDatabaseIfEmpty() async {
    final box = Hive.box<FoodItem>(foods);
    if (box.isEmpty) {
      for (final food in kSeedFoodDatabase) {
        await box.add(food);
      }
    }
  }
}
