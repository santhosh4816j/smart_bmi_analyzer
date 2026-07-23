import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/database/hive_boxes.dart';
import '../../core/models/food_item.dart';
import '../../core/themes/app_theme.dart';
import '../../providers/goal_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  String _query = '';
  String? _category;

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<FoodItem>(HiveBoxes.foods);
    final foods = box.values.where((f) {
      final matchesQuery = _query.isEmpty || f.name.toLowerCase().contains(_query.toLowerCase());
      final matchesCategory = _category == null || f.category == _category;
      return matchesQuery && matchesCategory;
    }).toList();
    final categories = box.values.map((f) => f.category).toSet().toList()..sort();

    return Scaffold(
      appBar: AppBar(title: const Text('Nutrition Guide')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search foods…',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: const Text('All'),
                    selected: _category == null,
                    onSelected: (_) => setState(() => _category = null),
                  ),
                ),
                ...categories.map(
                  (c) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(c),
                      selected: _category == c,
                      onSelected: (_) => setState(() => _category = _category == c ? null : c),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: foods.length,
              itemBuilder: (context, i) => _FoodTile(food: foods[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _FoodTile extends ConsumerWidget {
  final FoodItem food;
  const _FoodTile({required this.food});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        title: Text(food.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('${food.servingSize} • ${food.calories.round()} kcal'),
        leading: CircleAvatar(
          backgroundColor: AppColors.ocean.withValues(alpha: 0.15),
          child: Text(food.name.characters.first, style: const TextStyle(color: AppColors.ocean, fontWeight: FontWeight.bold)),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _macro(context, 'Protein', '${food.proteinG.toStringAsFixed(1)} g'),
                    _macro(context, 'Carbs', '${food.carbsG.toStringAsFixed(1)} g'),
                    _macro(context, 'Fat', '${food.fatG.toStringAsFixed(1)} g'),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      ref.read(dailyProgressProvider.notifier).logCalories(food.calories);
                      ref.read(dailyProgressProvider.notifier).logProtein(food.proteinG);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Logged ${food.name} to today\'s progress')),
                      );
                    },
                    child: const Text('Log this serving'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _macro(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
