import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/calorie_service.dart';
import '../../core/themes/app_theme.dart';
import '../../providers/profile_provider.dart';

class CalorieScreen extends ConsumerWidget {
  const CalorieScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider)!;
    final result = CalorieService.calculate(
      gender: profile.gender,
      weightKg: profile.weightKg,
      heightCm: profile.heightCm,
      age: profile.age,
      activityLevel: profile.activityLevel,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Daily Calories')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('Basal Metabolic Rate', style: Theme.of(context).textTheme.bodyMedium),
                  Text(
                    '${result.bmr.round()} kcal',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.ocean),
                  ),
                  Text('Calories your body burns at complete rest', style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _CalorieTile(
            title: 'Maintenance Calories',
            value: result.maintenance,
            color: AppColors.ocean,
            description: 'Calories needed to maintain your current weight, accounting for your activity level.',
          ),
          const SizedBox(height: 12),
          _CalorieTile(
            title: 'Weight Loss Calories',
            value: result.weightLoss,
            color: AppColors.overweight,
            description: 'A ~500 kcal daily deficit for a sustainable ~0.5 kg/week loss.',
          ),
          const SizedBox(height: 12),
          _CalorieTile(
            title: 'Weight Gain Calories',
            value: result.weightGain,
            color: AppColors.normal,
            description: 'A ~500 kcal daily surplus for a sustainable ~0.5 kg/week gain.',
          ),
        ],
      ),
    );
  }
}

class _CalorieTile extends StatelessWidget {
  final String title;
  final double value;
  final Color color;
  final String description;

  const _CalorieTile({
    required this.title,
    required this.value,
    required this.color,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 6,
              height: 60,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  Text('${value.round()} kcal / day', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: color, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(description, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
