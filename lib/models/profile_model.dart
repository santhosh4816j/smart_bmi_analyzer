import 'package:hive/hive.dart';

import 'enums.dart';

/// A user profile. Height is stored in centimeters and weight in
/// kilograms regardless of the user's display-unit preference — unit
/// conversion is purely a presentation concern (see [AppConstants]).
class ProfileModel {
  ProfileModel({
    required this.id,
    required this.name,
    required this.age,
    required this.sex,
    required this.heightCm,
    required this.weightKg,
    required this.activityLevel,
    required this.goal,
    this.goalWeightKg,
    this.photoPath,
    this.notes,
    this.dietPreference,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  final String id;
  String name;
  int age;
  BiologicalSex sex;
  double heightCm;
  double weightKg;
  ActivityLevel activityLevel;
  FitnessGoal goal;
  double? goalWeightKg;
  String? photoPath;
  String? notes;
  DietPreference? dietPreference;
  final DateTime createdAt;

  ProfileModel copyWith({
    String? name,
    int? age,
    BiologicalSex? sex,
    double? heightCm,
    double? weightKg,
    ActivityLevel? activityLevel,
    FitnessGoal? goal,
    double? goalWeightKg,
    String? photoPath,
    String? notes,
    DietPreference? dietPreference,
  }) {
    return ProfileModel(
      id: id,
      name: name ?? this.name,
      age: age ?? this.age,
      sex: sex ?? this.sex,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      activityLevel: activityLevel ?? this.activityLevel,
      goal: goal ?? this.goal,
      goalWeightKg: goalWeightKg ?? this.goalWeightKg,
      photoPath: photoPath ?? this.photoPath,
      notes: notes ?? this.notes,
      dietPreference: dietPreference ?? this.dietPreference,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'age': age,
        'sex': sex.name,
        'heightCm': heightCm,
        'weightKg': weightKg,
        'activityLevel': activityLevel.name,
        'goal': goal.name,
        'goalWeightKg': goalWeightKg,
        'photoPath': photoPath,
        'notes': notes,
        'dietPreference': dietPreference?.name,
        'createdAt': createdAt.toIso8601String(),
      };

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        id: json['id'] as String,
        name: json['name'] as String,
        age: json['age'] as int,
        sex: BiologicalSex.values.byName(json['sex'] as String),
        heightCm: (json['heightCm'] as num).toDouble(),
        weightKg: (json['weightKg'] as num).toDouble(),
        activityLevel:
            ActivityLevel.values.byName(json['activityLevel'] as String),
        goal: FitnessGoal.values.byName(json['goal'] as String),
        goalWeightKg: (json['goalWeightKg'] as num?)?.toDouble(),
        photoPath: json['photoPath'] as String?,
        notes: json['notes'] as String?,
        dietPreference: json['dietPreference'] == null
            ? null
            : DietPreference.values.byName(json['dietPreference'] as String),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

/// Hand-written Hive adapter — kept explicit rather than generated so the
/// project builds without a `build_runner` codegen step.
class ProfileModelAdapter extends TypeAdapter<ProfileModel> {
  @override
  final int typeId = 0;

  @override
  ProfileModel read(BinaryReader reader) {
    final int fieldCount = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < fieldCount; i++) reader.readByte(): reader.read(),
    };
    return ProfileModel(
      id: fields[0] as String,
      name: fields[1] as String,
      age: fields[2] as int,
      sex: BiologicalSex.values[fields[3] as int],
      heightCm: fields[4] as double,
      weightKg: fields[5] as double,
      activityLevel: ActivityLevel.values[fields[6] as int],
      goal: FitnessGoal.values[fields[7] as int],
      goalWeightKg: fields[8] as double?,
      photoPath: fields[9] as String?,
      notes: fields[10] as String?,
      dietPreference: fields[11] == null
          ? null
          : DietPreference.values[fields[11] as int],
      createdAt: DateTime.fromMillisecondsSinceEpoch(fields[12] as int),
    );
  }

  @override
  void write(BinaryWriter writer, ProfileModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.age)
      ..writeByte(3)
      ..write(obj.sex.index)
      ..writeByte(4)
      ..write(obj.heightCm)
      ..writeByte(5)
      ..write(obj.weightKg)
      ..writeByte(6)
      ..write(obj.activityLevel.index)
      ..writeByte(7)
      ..write(obj.goal.index)
      ..writeByte(8)
      ..write(obj.goalWeightKg)
      ..writeByte(9)
      ..write(obj.photoPath)
      ..writeByte(10)
      ..write(obj.notes)
      ..writeByte(11)
      ..write(obj.dietPreference?.index)
      ..writeByte(12)
      ..write(obj.createdAt.millisecondsSinceEpoch);
  }
}
