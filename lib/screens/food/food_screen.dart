import 'package:flutter/material.dart';

import '../../models/food_model.dart';
import '../../services/food_database_service.dart';
import '../../widgets/glass_card.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String? _activeTag;

  static const List<(String, String)> _tagOptions = <(String, String)>[
    ('vegetarian', 'Vegetarian'),
    ('vegan', 'Vegan'),
    ('non_vegetarian', 'Non-Veg'),
    ('high_protein', 'High Protein'),
    ('low_carb', 'Low Carb'),
    ('high_fiber', 'High Fiber'),
    ('weight_loss', 'Weight Loss'),
    ('weight_gain', 'Weight Gain'),
    ('diabetic_friendly', 'Diabetic-Friendly'),
    ('balanced', 'Balanced'),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FoodModel> _filteredFoods() {
    final FoodDatabaseService service = FoodDatabaseService.instance;
    List<FoodModel> foods =
        _query.trim().isEmpty ? service.all : service.search(_query);
    if (_activeTag != null) {
      foods = foods.where((FoodModel f) => f.tags.contains(_activeTag)).toList();
    }
    return foods;
  }

  @override
  Widget build(BuildContext context) {
    final List<FoodModel> foods = _filteredFoods();

    return Scaffold(
      appBar: AppBar(title: const Text('Food')),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (String value) => setState(() => _query = value),
              decoration: const InputDecoration(
                hintText: 'Search foods (e.g. chicken, tofu, rice)',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: <Widget>[
                for (final (String value, String label) in _tagOptions)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(label),
                      selected: _activeTag == value,
                      onSelected: (bool selected) {
                        setState(() => _activeTag = selected ? value : null);
                      },
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: foods.isEmpty
                ? Center(
                    child: Text(
                      'No foods match your filters',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    itemCount: foods.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (BuildContext context, int index) =>
                        _FoodCard(food: foods[index]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _FoodCard extends StatelessWidget {
  const _FoodCard({required this.food});

  final FoodModel food;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      food.name,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    Text(
                      '${food.category} · ${food.servingSize}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    food.caloriesPerServing.toStringAsFixed(0),
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: scheme.primary,
                    ),
                  ),
                  Text('kcal', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 4,
            children: <Widget>[
              _MacroLabel(label: 'Protein', value: food.proteinG),
              _MacroLabel(label: 'Carbs', value: food.carbsG),
              _MacroLabel(label: 'Fat', value: food.fatG),
              _MacroLabel(label: 'Fiber', value: food.fiberG),
              _MacroLabel(label: 'Sugar', value: food.sugarG),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroLabel extends StatelessWidget {
  const _MacroLabel({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$label ${value.toStringAsFixed(1)}g',
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}
