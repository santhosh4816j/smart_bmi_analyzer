/// A single food item in the bundled offline nutrition database.
/// Loaded once at startup from `assets/data/food_database.json` and
/// kept in memory — it is reference data, not something the user
/// edits, so it does not need Hive persistence.
class FoodModel {
  const FoodModel({
    required this.id,
    required this.name,
    required this.category,
    required this.tags,
    required this.caloriesPerServing,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.fiberG,
    required this.sugarG,
    required this.servingSize,
  });

  final String id;
  final String name;

  /// e.g. "South Indian", "North Indian", "Snack", "Beverage"
  final String category;

  /// e.g. ["vegetarian", "weight_loss", "high_protein", "diabetic_friendly"]
  final List<String> tags;
  final double caloriesPerServing;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final double fiberG;
  final double sugarG;

  /// Human-readable serving description, e.g. "1 bowl (150g)"
  final String servingSize;

  factory FoodModel.fromJson(Map<String, dynamic> json) => FoodModel(
        id: json['id'] as String,
        name: json['name'] as String,
        category: json['category'] as String,
        tags: (json['tags'] as List<dynamic>).cast<String>(),
        caloriesPerServing: (json['caloriesPerServing'] as num).toDouble(),
        proteinG: (json['proteinG'] as num).toDouble(),
        carbsG: (json['carbsG'] as num).toDouble(),
        fatG: (json['fatG'] as num).toDouble(),
        fiberG: (json['fiberG'] as num).toDouble(),
        sugarG: (json['sugarG'] as num).toDouble(),
        servingSize: json['servingSize'] as String,
      );
}
