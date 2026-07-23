// GENERATED CODE - Hive TypeAdapter (hand-authored, see user_profile.g.dart note)
part of 'food_item.dart';

class FoodItemAdapter extends TypeAdapter<FoodItem> {
  @override
  final int typeId = 7;

  @override
  FoodItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FoodItem(
      name: fields[0] as String,
      calories: fields[1] as double,
      proteinG: fields[2] as double,
      carbsG: fields[3] as double,
      fatG: fields[4] as double,
      servingSize: fields[5] as String,
      category: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FoodItem obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.calories)
      ..writeByte(2)
      ..write(obj.proteinG)
      ..writeByte(3)
      ..write(obj.carbsG)
      ..writeByte(4)
      ..write(obj.fatG)
      ..writeByte(5)
      ..write(obj.servingSize)
      ..writeByte(6)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is FoodItemAdapter && other.typeId == typeId;
}
