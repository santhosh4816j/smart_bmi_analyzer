import 'package:flutter/material.dart';

import '../../core/themes/app_theme.dart';
import '../../data/meal_database.dart';

class MealPlansScreen extends StatelessWidget {
  const MealPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: kMealPlans.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Meal Suggestions'),
          bottom: TabBar(
            isScrollable: true,
            tabs: kMealPlans.map((c) => Tab(text: '${c.emoji} ${c.title}')).toList(),
          ),
        ),
        body: TabBarView(
          children: kMealPlans.map((category) {
            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: category.meals.length,
              itemBuilder: (context, i) {
                final meal = category.meals[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(meal.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text(meal.description, style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _pill(context, '${meal.approxCalories} kcal', AppColors.sunGold),
                            const SizedBox(width: 8),
                            _pill(context, '${meal.approxProteinG.round()}g protein', AppColors.ocean),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _pill(BuildContext context, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12)),
    );
  }
}
