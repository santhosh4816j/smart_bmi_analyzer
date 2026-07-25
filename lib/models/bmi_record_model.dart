import 'package:hive/hive.dart';

/// A single point-in-time measurement snapshot for a profile — powers
/// the History timeline/charts and the Dashboard trend lines.
class BmiRecordModel {
  BmiRecordModel({
    required this.id,
    required this.profileId,
    required this.weightKg,
    required this.bmi,
    required this.recordedAt,
    this.note,
  });

  final String id;
  final String profileId;
  final double weightKg;
  final double bmi;
  final DateTime recordedAt;
  final String? note;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'profileId': profileId,
        'weightKg': weightKg,
        'bmi': bmi,
        'recordedAt': recordedAt.toIso8601String(),
        'note': note,
      };

  factory BmiRecordModel.fromJson(Map<String, dynamic> json) =>
      BmiRecordModel(
        id: json['id'] as String,
        profileId: json['profileId'] as String,
        weightKg: (json['weightKg'] as num).toDouble(),
        bmi: (json['bmi'] as num).toDouble(),
        recordedAt: DateTime.parse(json['recordedAt'] as String),
        note: json['note'] as String?,
      );
}

class BmiRecordModelAdapter extends TypeAdapter<BmiRecordModel> {
  @override
  final int typeId = 1;

  @override
  BmiRecordModel read(BinaryReader reader) {
    final int fieldCount = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < fieldCount; i++) reader.readByte(): reader.read(),
    };
    return BmiRecordModel(
      id: fields[0] as String,
      profileId: fields[1] as String,
      weightKg: fields[2] as double,
      bmi: fields[3] as double,
      recordedAt: DateTime.fromMillisecondsSinceEpoch(fields[4] as int),
      note: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BmiRecordModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.profileId)
      ..writeByte(2)
      ..write(obj.weightKg)
      ..writeByte(3)
      ..write(obj.bmi)
      ..writeByte(4)
      ..write(obj.recordedAt.millisecondsSinceEpoch)
      ..writeByte(5)
      ..write(obj.note);
  }
}
