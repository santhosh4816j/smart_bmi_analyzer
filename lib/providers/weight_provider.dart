import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../core/database/hive_boxes.dart';
import '../core/models/weight_record.dart';

class WeightHistoryNotifier extends StateNotifier<List<WeightRecord>> {
  WeightHistoryNotifier() : super(_box.values.toList()..sort((a, b) => a.date.compareTo(b.date)));

  static Box<WeightRecord> get _box =>
      Hive.box<WeightRecord>(HiveBoxes.weightHistory);

  Future<void> addRecord(double weightKg, {String? note}) async {
    final record = WeightRecord(weightKg: weightKg, date: DateTime.now(), note: note);
    await _box.add(record);
    state = [...state, record]..sort((a, b) => a.date.compareTo(b.date));
  }

  List<WeightRecord> recordsSince(Duration duration) {
    final cutoff = DateTime.now().subtract(duration);
    return state.where((r) => r.date.isAfter(cutoff)).toList();
  }
}

final weightHistoryProvider =
    StateNotifierProvider<WeightHistoryNotifier, List<WeightRecord>>((ref) {
  return WeightHistoryNotifier();
});
