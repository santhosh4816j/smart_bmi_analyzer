import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/food_model.dart';

/// Loads and queries the bundled offline food database.
/// The bundled dataset ships with a curated starter set of Indian and
/// South Indian staples across common dietary tags; it's designed to be
/// extended by adding rows to `assets/data/food_database.json` — no code
/// changes needed to grow the catalog.
class FoodDatabaseService {
  FoodDatabaseService._();
  static final FoodDatabaseService instance = FoodDatabaseService._();

  List<FoodModel> _foods = <FoodModel>[];
  bool _loaded = false;

  Future<void> load() async {
    if (_loaded) return;
    final String raw =
        await rootBundle.loadString('assets/data/food_database.json');
    final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
    _foods = decoded
        .map((dynamic e) => FoodModel.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
    _loaded = true;
  }

  List<FoodModel> get all => List<FoodModel>.unmodifiable(_foods);

  List<FoodModel> byTag(String tag) =>
      _foods.where((FoodModel f) => f.tags.contains(tag)).toList();

  List<FoodModel> search(String query) {
    final String q = query.trim().toLowerCase();
    if (q.isEmpty) return all;
    return _foods
        .where(
          (FoodModel f) =>
              f.name.toLowerCase().contains(q) ||
              f.category.toLowerCase().contains(q) ||
              f.tags.any((String t) => t.contains(q)),
        )
        .toList();
  }

  List<FoodModel> byCategory(String category) => _foods
      .where((FoodModel f) => f.category.toLowerCase() == category.toLowerCase())
      .toList();
}
