import 'package:hive/hive.dart';

part 'weight_record.g.dart';

@HiveType(typeId: 4)
class WeightRecord extends HiveObject {
  @HiveField(0)
  double weightKg;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  String? note;

  WeightRecord({
    required this.weightKg,
    required this.date,
    this.note,
  });
}
