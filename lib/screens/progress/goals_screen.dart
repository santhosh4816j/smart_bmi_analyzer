import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/goal.dart';
import '../../core/services/calorie_service.dart';
import '../../core/services/protein_service.dart';
import '../../core/services/water_service.dart';
import '../../providers/goal_provider.dart';
import '../../providers/profile_provider.dart';

class GoalsScreen extends ConsumerStatefulWidget {
  const GoalsScreen({super.key});

  @override
  ConsumerState<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends ConsumerState<GoalsScreen> {
  Objective _objective = Objective.maintain;

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider)!;
    final calorieResult = CalorieService.calculate(
      gender: profile.gender,
      weightKg: profile.weightKg,
      heightCm: profile.heightCm,
      age: profile.age,
      activityLevel: profile.activityLevel,
    );
    final proteinTarget = ProteinService.recommendedFor(weightKg: profile.weightKg, objective: _objective);
    final waterTarget = WaterService.calculate(weightKg: profile.weightKg).liters;
    final calorieTarget = switch (_objective) {
      Objective.loseWeight => calorieResult.weightLoss,
      Objective.maintain => calorieResult.maintenance,
      Objective.gainMuscle => calorieResult.weightGain,
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Daily Goals')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Choose your objective', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          SegmentedButton<Objective>(
            segments: Objective.values.map((o) => ButtonSegment(value: o, label: Text(o.label))).toList(),
            selected: {_objective},
            onSelectionChanged: (s) => setState(() => _objective = s.first),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _targetRow(context, 'Calories', '${calorieTarget.round()} kcal'),
                  const Divider(),
                  _targetRow(context, 'Protein', '${proteinTarget.round()} g'),
                  const Divider(),
                  _targetRow(context, 'Water', '${waterTarget.toStringAsFixed(1)} L'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              ref.read(goalProvider.notifier).save(
                    DailyGoal(
                      objective: _objective,
                      calorieTarget: calorieTarget,
                      proteinTargetG: proteinTarget,
                      waterTargetL: waterTarget,
                    ),
                  );
              Navigator.of(context).pop();
            },
            child: const Text('Save Goals'),
          ),
        ],
      ),
    );
  }

  Widget _targetRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
