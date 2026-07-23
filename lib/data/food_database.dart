import '../core/models/food_item.dart';

/// Static nutrition data (per stated serving), used to seed the local Hive
/// box on first launch. Values are standard USDA-style approximations.
final List<FoodItem> kSeedFoodDatabase = [
  FoodItem(name: 'Chicken Breast', calories: 165, proteinG: 31, carbsG: 0, fatG: 3.6, servingSize: '100 g', category: 'Protein'),
  FoodItem(name: 'Egg', calories: 78, proteinG: 6.3, carbsG: 0.6, fatG: 5.3, servingSize: '1 large', category: 'Protein'),
  FoodItem(name: 'Fish (Salmon)', calories: 208, proteinG: 20, carbsG: 0, fatG: 13, servingSize: '100 g', category: 'Protein'),
  FoodItem(name: 'Milk', calories: 103, proteinG: 8, carbsG: 12, fatG: 2.4, servingSize: '1 cup (244 ml)', category: 'Dairy'),
  FoodItem(name: 'Curd', calories: 98, proteinG: 11, carbsG: 3.4, fatG: 4.3, servingSize: '1 cup (245 g)', category: 'Dairy'),
  FoodItem(name: 'Paneer', calories: 265, proteinG: 18, carbsG: 6, fatG: 20, servingSize: '100 g', category: 'Dairy'),
  FoodItem(name: 'Tofu', calories: 76, proteinG: 8, carbsG: 1.9, fatG: 4.8, servingSize: '100 g', category: 'Plant Protein'),
  FoodItem(name: 'Soya Chunks', calories: 345, proteinG: 52, carbsG: 33, fatG: 0.5, servingSize: '100 g dry', category: 'Plant Protein'),
  FoodItem(name: 'Lentils', calories: 116, proteinG: 9, carbsG: 20, fatG: 0.4, servingSize: '1/2 cup cooked', category: 'Legumes'),
  FoodItem(name: 'Beans', calories: 127, proteinG: 8.7, carbsG: 22.8, fatG: 0.5, servingSize: '1/2 cup cooked', category: 'Legumes'),
  FoodItem(name: 'Peanuts', calories: 166, proteinG: 7, carbsG: 4.6, fatG: 14, servingSize: '28 g (small handful)', category: 'Nuts & Seeds'),
  FoodItem(name: 'Almonds', calories: 164, proteinG: 6, carbsG: 6.1, fatG: 14.2, servingSize: '28 g (about 23 nuts)', category: 'Nuts & Seeds'),
  FoodItem(name: 'Oats', calories: 154, proteinG: 5.3, carbsG: 27, fatG: 2.6, servingSize: '1/2 cup dry', category: 'Grains'),
  FoodItem(name: 'Rice (cooked)', calories: 206, proteinG: 4.3, carbsG: 45, fatG: 0.4, servingSize: '1 cup cooked', category: 'Grains'),
  FoodItem(name: 'Banana', calories: 105, proteinG: 1.3, carbsG: 27, fatG: 0.4, servingSize: '1 medium', category: 'Fruit'),
  FoodItem(name: 'Apple', calories: 95, proteinG: 0.5, carbsG: 25, fatG: 0.3, servingSize: '1 medium', category: 'Fruit'),
  FoodItem(name: 'Orange', calories: 62, proteinG: 1.2, carbsG: 15.4, fatG: 0.2, servingSize: '1 medium', category: 'Fruit'),
  FoodItem(name: 'Sweet Potato', calories: 112, proteinG: 2, carbsG: 26, fatG: 0.1, servingSize: '1 medium, baked', category: 'Vegetable'),
  FoodItem(name: 'Broccoli', calories: 55, proteinG: 3.7, carbsG: 11.2, fatG: 0.6, servingSize: '1 cup cooked', category: 'Vegetable'),
  FoodItem(name: 'Spinach', calories: 41, proteinG: 5.3, carbsG: 6.8, fatG: 0.5, servingSize: '1 cup cooked', category: 'Vegetable'),
];
