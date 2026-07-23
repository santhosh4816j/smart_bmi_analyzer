import 'package:hive/hive.dart';

part 'food_item.g.dart';

@HiveType(typeId: 7)
class FoodItem extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  double calories; // per serving

  @HiveField(2)
  double proteinG;

  @HiveField(3)
  double carbsG;

  @HiveField(4)
  double fatG;

  @HiveField(5)
  String servingSize;

  @HiveField(6)
  String category;

  FoodItem({
    required this.name,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.servingSize,
    required this.category,
  });
}
