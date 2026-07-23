import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/bmi_service.dart';
import '../../core/themes/app_theme.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/bmi_gauge.dart';

class BmiScreen extends ConsumerWidget {
  const BmiScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider)!;
    final result = BmiService.evaluate(weightKg: profile.weightKg, heightCm: profile.heightCm);
    final goalText = result.weightToGoalKg > 0
        ? 'Lose about ${result.weightToGoalKg.toStringAsFixed(1)} kg to reach a healthy range'
        : result.weightToGoalKg < 0
            ? 'Gain about ${(-result.weightToGoalKg).toStringAsFixed(1)} kg to reach a healthy range'
            : "You're within the healthy weight range";

    return Scaffold(
      appBar: AppBar(title: const Text('BMI Details')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(child: BmiGauge(bmi: result.bmi, category: result.category)),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Healthy Weight Range', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  _row(context, 'Minimum', '${result.healthyMinKg.toStringAsFixed(1)} kg'),
                  _row(context, 'Maximum', '${result.healthyMaxKg.toStringAsFixed(1)} kg'),
                  const Divider(height: 24),
                  Text(goalText, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: colorForBmiCategory(result.category).withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lightbulb_outline, color: colorForBmiCategory(result.category)),
                  const SizedBox(width: 12),
                  Expanded(child: Text(BmiService.tipFor(result.category))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'BMI is a general screening tool and does not directly measure body fat '
            'or account for muscle mass. For personalized medical advice, consult a '
            'healthcare professional.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
