// GENERATED CODE - Hive TypeAdapters (hand-authored, see user_profile.g.dart note)
part of 'reminder.dart';

class ReminderTypeAdapter extends TypeAdapter<ReminderType> {
  @override
  final int typeId = 5;

  @override
  ReminderType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ReminderType.water;
      case 1:
        return ReminderType.exercise;
      case 2:
        return ReminderType.measureWeight;
      case 3:
        return ReminderType.eatHealthy;
      case 4:
        return ReminderType.protein;
      case 5:
        return ReminderType.custom;
      default:
        return ReminderType.custom;
    }
  }

  @override
  void write(BinaryWriter writer, ReminderType obj) {
    switch (obj) {
      case ReminderType.water:
        writer.writeByte(0);
        break;
      case ReminderType.exercise:
        writer.writeByte(1);
        break;
      case ReminderType.measureWeight:
        writer.writeByte(2);
        break;
      case ReminderType.eatHealthy:
        writer.writeByte(3);
        break;
      case ReminderType.protein:
        writer.writeByte(4);
        break;
      case ReminderType.custom:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ReminderTypeAdapter && other.typeId == typeId;
}

class ReminderAdapter extends TypeAdapter<Reminder> {
  @override
  final int typeId = 6;

  @override
  Reminder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Reminder(
      notificationId: fields[0] as int,
      type: fields[1] as ReminderType,
      label: fields[2] as String,
      hour: fields[3] as int,
      minute: fields[4] as int,
      enabled: fields[5] as bool,
      repeatDays: (fields[6] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, Reminder obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.notificationId)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.label)
      ..writeByte(3)
      ..write(obj.hour)
      ..writeByte(4)
      ..write(obj.minute)
      ..writeByte(5)
      ..write(obj.enabled)
      ..writeByte(6)
      ..write(obj.repeatDays);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ReminderAdapter && other.typeId == typeId;
}
