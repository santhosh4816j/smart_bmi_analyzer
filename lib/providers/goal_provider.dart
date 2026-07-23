import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../core/database/hive_boxes.dart';
import '../core/models/goal.dart';

String _todayKey() => DateFormat('yyyy-MM-dd').format(DateTime.now());

class GoalNotifier extends StateNotifier<DailyGoal?> {
  GoalNotifier() : super(_box.isEmpty ? null : _box.getAt(0));

  static Box<DailyGoal> get _box => Hive.box<DailyGoal>(HiveBoxes.goals);

  Future<void> save(DailyGoal goal) async {
    if (_box.isEmpty) {
      await _box.add(goal);
    } else {
      await _box.putAt(0, goal);
    }
    state = goal;
  }
}

final goalProvider = StateNotifierProvider<GoalNotifier, DailyGoal?>((ref) {
  return GoalNotifier();
});

class DailyProgressNotifier extends StateNotifier<DailyProgress> {
  DailyProgressNotifier() : super(_loadOrCreateToday());

  static Box<DailyProgress> get _box =>
      Hive.box<DailyProgress>(HiveBoxes.dailyProgress);

  static DailyProgress _loadOrCreateToday() {
    final key = _todayKey();
    final existing = _box.values.where((p) => p.dateKey == key);
    if (existing.isNotEmpty) return existing.first;
    return DailyProgress(dateKey: key);
  }

  Future<void> _persist() async {
    final key = state.dateKey;
    final existingKey = _box.keys.firstWhere(
      (k) => _box.get(k)?.dateKey == key,
      orElse: () => null,
    );
    if (existingKey != null) {
      await _box.put(existingKey, state);
    } else {
      await _box.add(state);
    }
  }

  Future<void> logCalories(double kcal) async {
    state = DailyProgress(
      dateKey: state.dateKey,
      caloriesConsumed: state.caloriesConsumed + kcal,
      proteinConsumedG: state.proteinConsumedG,
      waterConsumedL: state.waterConsumedL,
    );
    await _persist();
  }

  Future<void> logProtein(double grams) async {
    state = DailyProgress(
      dateKey: state.dateKey,
      caloriesConsumed: state.caloriesConsumed,
      proteinConsumedG: state.proteinConsumedG + grams,
      waterConsumedL: state.waterConsumedL,
    );
    await _persist();
  }

  Future<void> logWater(double liters) async {
    state = DailyProgress(
      dateKey: state.dateKey,
      caloriesConsumed: state.caloriesConsumed,
      proteinConsumedG: state.proteinConsumedG,
      waterConsumedL: state.waterConsumedL + liters,
    );
    await _persist();
  }
}

final dailyProgressProvider =
    StateNotifierProvider<DailyProgressNotifier, DailyProgress>((ref) {
  return DailyProgressNotifier();
});
