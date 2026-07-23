import 'package:hive/hive.dart';

part 'bmi_record.g.dart';

/// A single saved BMI calculation entry, persisted locally with Hive.
@HiveType(typeId: 0)
class BmiRecord extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int age;

  @HiveField(2)
  final String gender;

  @HiveField(3)
  final double height; // in cm

  @HiveField(4)
  final double weight; // in kg

  @HiveField(5)
  final double bmi;

  @HiveField(6)
  final String category;

  @HiveField(7)
  final DateTime date;

  BmiRecord({
    required this.name,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    required this.bmi,
    required this.category,
    required this.date,
  });
}
