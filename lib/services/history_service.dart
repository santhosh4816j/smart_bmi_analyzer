import '../models/bmi_record.dart';
import '../storage/hive_boxes.dart';

/// Service layer for saving, reading, and deleting BMI history records.
/// Wraps Hive so the UI never talks to the database directly.
class HistoryService {
  /// Saves a new BMI record and returns it once persisted.
  static Future<void> addRecord(BmiRecord record) async {
    await HiveBoxes.historyBox.add(record);
  }

  /// Returns all saved records, most recent first.
  static List<BmiRecord> getAllRecords() {
    final records = HiveBoxes.historyBox.values.toList();
    records.sort((a, b) => b.date.compareTo(a.date));
    return records;
  }

  /// Deletes a single record from the box.
  static Future<void> deleteRecord(BmiRecord record) async {
    await record.delete();
  }

  /// Clears the entire BMI history.
  static Future<void> clearAll() async {
    await HiveBoxes.historyBox.clear();
  }
}
