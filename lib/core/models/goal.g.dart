// GENERATED CODE - Hive TypeAdapters (hand-authored, see user_profile.g.dart note)
part of 'goal.dart';

class ObjectiveAdapter extends TypeAdapter<Objective> {
  @override
  final int typeId = 8;

  @override
  Objective read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Objective.loseWeight;
      case 1:
        return Objective.maintain;
      case 2:
        return Objective.gainMuscle;
      default:
        return Objective.maintain;
    }
  }

  @override
  void write(BinaryWriter writer, Objective obj) {
    switch (obj) {
      case Objective.loseWeight:
        writer.writeByte(0);
        break;
      case Objective.maintain:
        writer.writeByte(1);
        break;
      case Objective.gainMuscle:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ObjectiveAdapter && other.typeId == typeId;
}

class DailyGoalAdapter extends TypeAdapter<DailyGoal> {
  @override
  final int typeId = 9;

  @override
  DailyGoal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyGoal(
      objective: fields[0] as Objective,
      calorieTarget: fields[1] as double,
      proteinTargetG: fields[2] as double,
      waterTargetL: fields[3] as double,
      targetWeightKg: fields[4] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, DailyGoal obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.objective)
      ..writeByte(1)
      ..write(obj.calorieTarget)
      ..writeByte(2)
      ..write(obj.proteinTargetG)
      ..writeByte(3)
      ..write(obj.waterTargetL)
      ..writeByte(4)
      ..write(obj.targetWeightKg);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is DailyGoalAdapter && other.typeId == typeId;
}

class DailyProgressAdapter extends TypeAdapter<DailyProgress> {
  @override
  final int typeId = 10;

  @override
  DailyProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyProgress(
      dateKey: fields[0] as String,
      caloriesConsumed: fields[1] as double,
      proteinConsumedG: fields[2] as double,
      waterConsumedL: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, DailyProgress obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.dateKey)
      ..writeByte(1)
      ..write(obj.caloriesConsumed)
      ..writeByte(2)
      ..write(obj.proteinConsumedG)
      ..writeByte(3)
      ..write(obj.waterConsumedL);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is DailyProgressAdapter && other.typeId == typeId;
}
