import 'package:hive_flutter/hive_flutter.dart';
import '../models/bmi_record.dart';

/// Initializes Hive, registers adapters, and opens the boxes used by the app.
/// Call [HiveBoxes.init] once in main() before runApp().
class HiveBoxes {
  HiveBoxes._();

  static const String bmiHistory = 'bmi_history_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(BmiRecordAdapter());
    }
    await Hive.openBox<BmiRecord>(bmiHistory);
  }

  static Box<BmiRecord> get historyBox => Hive.box<BmiRecord>(bmiHistory);
}
