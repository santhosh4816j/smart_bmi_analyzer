import 'package:hive/hive.dart';

import '../constants/app_constants.dart';
import '../models/bmi_record_model.dart';

class BmiRecordRepository {
  BmiRecordRepository(this._box);

  final Box<BmiRecordModel> _box;

  static Future<BmiRecordRepository> open() async {
    final Box<BmiRecordModel> box =
        await Hive.openBox<BmiRecordModel>(AppConstants.bmiRecordBoxName);
    return BmiRecordRepository(box);
  }

  List<BmiRecordModel> getAllForProfile(String profileId) {
    final List<BmiRecordModel> records = _box.values
        .where((BmiRecordModel r) => r.profileId == profileId)
        .toList();
    records.sort(
      (BmiRecordModel a, BmiRecordModel b) =>
          b.recordedAt.compareTo(a.recordedAt),
    );
    return records;
  }

  Future<void> add(BmiRecordModel record) => _box.put(record.id, record);

  Future<void> delete(String id) => _box.delete(id);

  Future<void> deleteAllForProfile(String profileId) async {
    final Iterable<String> keys = _box.keys
        .cast<String>()
        .where((String key) => _box.get(key)?.profileId == profileId);
    await _box.deleteAll(keys);
  }
}
