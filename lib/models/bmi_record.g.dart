// GENERATED CODE - DO NOT MODIFY BY HAND
// This adapter is equivalent to what `flutter pub run build_runner build`
// would generate for the @HiveType annotated BmiRecord class above.

part of 'bmi_record.dart';

class BmiRecordAdapter extends TypeAdapter<BmiRecord> {
  @override
  final int typeId = 0;

  @override
  BmiRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BmiRecord(
      name: fields[0] as String,
      age: fields[1] as int,
      gender: fields[2] as String,
      height: fields[3] as double,
      weight: fields[4] as double,
      bmi: fields[5] as double,
      category: fields[6] as String,
      date: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, BmiRecord obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.age)
      ..writeByte(2)
      ..write(obj.gender)
      ..writeByte(3)
      ..write(obj.height)
      ..writeByte(4)
      ..write(obj.weight)
      ..writeByte(5)
      ..write(obj.bmi)
      ..writeByte(6)
      ..write(obj.category)
      ..writeByte(7)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BmiRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
