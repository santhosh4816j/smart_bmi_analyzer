import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/water_service.dart';
import '../../core/themes/app_theme.dart';
import '../../providers/goal_provider.dart';
import '../../providers/profile_provider.dart';

class WaterScreen extends ConsumerWidget {
  const WaterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider)!;
    final result = WaterService.calculate(weightKg: profile.weightKg);
    final progress = ref.watch(dailyProgressProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Water Intake')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(Icons.water_drop, size: 48, color: AppColors.oceanLight),
                  const SizedBox(height: 12),
                  Text(
                    '${result.liters.toStringAsFixed(1)} L',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.oceanLight),
                  ),
                  Text('≈ ${result.glasses} glasses (250 ml) per day', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text("Today's Intake", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    '${progress.waterConsumedL.toStringAsFixed(2)} L logged',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      _glassButton(context, ref, 0.25, '1 Glass'),
                      _glassButton(context, ref, 0.5, '2 Glasses'),
                      _glassButton(context, ref, 1.0, '1 Bottle (1L)'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glassButton(BuildContext context, WidgetRef ref, double liters, String label) {
    return OutlinedButton(
      onPressed: () => ref.read(dailyProgressProvider.notifier).logWater(liters),
      child: Text('+ $label'),
    );
  }
}
