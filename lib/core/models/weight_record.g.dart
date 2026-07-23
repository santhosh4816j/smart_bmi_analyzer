// GENERATED CODE - Hive TypeAdapter (hand-authored, see user_profile.g.dart note)
part of 'weight_record.dart';

class WeightRecordAdapter extends TypeAdapter<WeightRecord> {
  @override
  final int typeId = 4;

  @override
  WeightRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeightRecord(
      weightKg: fields[0] as double,
      date: fields[1] as DateTime,
      note: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, WeightRecord obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.weightKg)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is WeightRecordAdapter && other.typeId == typeId;
}
