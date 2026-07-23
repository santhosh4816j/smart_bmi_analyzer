// GENERATED CODE - Hive TypeAdapters
// Hand-authored to match what `dart run build_runner build` would emit,
// since this sandbox has no network access to pub.dev to run codegen.
// If you run `flutter pub run build_runner build --delete-conflicting-outputs`
// locally, it is safe to let it regenerate/overwrite this file.
part of 'user_profile.dart';

class GenderAdapter extends TypeAdapter<Gender> {
  @override
  final int typeId = 0;

  @override
  Gender read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Gender.male;
      case 1:
        return Gender.female;
      case 2:
        return Gender.other;
      default:
        return Gender.male;
    }
  }

  @override
  void write(BinaryWriter writer, Gender obj) {
    switch (obj) {
      case Gender.male:
        writer.writeByte(0);
        break;
      case Gender.female:
        writer.writeByte(1);
        break;
      case Gender.other:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is GenderAdapter && other.typeId == typeId;
}

class ActivityLevelAdapter extends TypeAdapter<ActivityLevel> {
  @override
  final int typeId = 1;

  @override
  ActivityLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ActivityLevel.sedentary;
      case 1:
        return ActivityLevel.lightlyActive;
      case 2:
        return ActivityLevel.moderatelyActive;
      case 3:
        return ActivityLevel.veryActive;
      case 4:
        return ActivityLevel.athlete;
      default:
        return ActivityLevel.sedentary;
    }
  }

  @override
  void write(BinaryWriter writer, ActivityLevel obj) {
    switch (obj) {
      case ActivityLevel.sedentary:
        writer.writeByte(0);
        break;
      case ActivityLevel.lightlyActive:
        writer.writeByte(1);
        break;
      case ActivityLevel.moderatelyActive:
        writer.writeByte(2);
        break;
      case ActivityLevel.veryActive:
        writer.writeByte(3);
        break;
      case ActivityLevel.athlete:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ActivityLevelAdapter && other.typeId == typeId;
}

class UnitSystemAdapter extends TypeAdapter<UnitSystem> {
  @override
  final int typeId = 2;

  @override
  UnitSystem read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return UnitSystem.metric;
      case 1:
        return UnitSystem.imperial;
      default:
        return UnitSystem.metric;
    }
  }

  @override
  void write(BinaryWriter writer, UnitSystem obj) {
    switch (obj) {
      case UnitSystem.metric:
        writer.writeByte(0);
        break;
      case UnitSystem.imperial:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is UnitSystemAdapter && other.typeId == typeId;
}

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 3;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      name: fields[0] as String,
      age: fields[1] as int,
      gender: fields[2] as Gender,
      heightCm: fields[3] as double,
      weightKg: fields[4] as double,
      activityLevel: fields[5] as ActivityLevel,
      unitSystem: fields[6] as UnitSystem,
      createdAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.age)
      ..writeByte(2)
      ..write(obj.gender)
      ..writeByte(3)
      ..write(obj.heightCm)
      ..writeByte(4)
      ..write(obj.weightKg)
      ..writeByte(5)
      ..write(obj.activityLevel)
      ..writeByte(6)
      ..write(obj.unitSystem)
      ..writeByte(7)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is UserProfileAdapter && other.typeId == typeId;
}
