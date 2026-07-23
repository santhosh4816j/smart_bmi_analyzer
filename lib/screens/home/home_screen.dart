import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/goal.dart';
import '../../core/services/bmi_service.dart';
import '../../core/services/calorie_service.dart';
import '../../core/services/protein_service.dart';
import '../../core/services/water_service.dart';
import '../../core/themes/app_theme.dart';
import '../../providers/goal_provider.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/bmi_gauge.dart';
import '../../widgets/dashboard_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    if (profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final bmiResult = BmiService.evaluate(weightKg: profile.weightKg, heightCm: profile.heightCm);
    final calorieResult = CalorieService.calculate(
      gender: profile.gender,
      weightKg: profile.weightKg,
      heightCm: profile.heightCm,
      age: profile.age,
      activityLevel: profile.activityLevel,
    );
    final proteinG = ProteinService.recommendedFor(
      weightKg: profile.weightKg,
      objective: Objective.maintain,
    );
    final water = WaterService.calculate(weightKg: profile.weightKg);
    final progress = ref.watch(dailyProgressProvider);
    final goal = ref.watch(goalProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_greeting(), style: Theme.of(context).textTheme.bodyMedium),
                      Text(
                        profile.name,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => context.push('/settings'),
                  icon: const Icon(Icons.settings_outlined),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text("Today's Health Summary", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                    Center(child: BmiGauge(bmi: bmiResult.bmi, category: bmiResult.category)),
                    Text(
                      BmiService.tipFor(bmiResult.category),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 1.25,
              children: [
                DashboardCard(
                  title: 'BMI',
                  value: bmiResult.bmi.toStringAsFixed(1),
                  subtitle: bmiResult.category,
                  icon: Icons.monitor_weight_outlined,
                  color: colorForBmiCategory(bmiResult.category),
                  onTap: () => context.push('/bmi'),
                ),
                DashboardCard(
                  title: 'Calories',
                  value: '${calorieResult.maintenance.round()}',
                  subtitle: 'kcal / day target',
                  icon: Icons.local_fire_department_outlined,
                  color: AppColors.sunGold,
                  onTap: () => context.push('/calculators/calories'),
                ),
                DashboardCard(
                  title: 'Protein',
                  value: '${proteinG.round()} g',
                  subtitle: 'recommended / day',
                  icon: Icons.egg_alt_outlined,
                  color: AppColors.ocean,
                  onTap: () => context.push('/calculators/protein'),
                ),
                DashboardCard(
                  title: 'Water',
                  value: '${water.liters.toStringAsFixed(1)} L',
                  subtitle: '${water.glasses} glasses / day',
                  icon: Icons.water_drop_outlined,
                  color: AppColors.oceanLight,
                  onTap: () => context.push('/calculators/water'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Daily Progress', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ProgressRing(
                          progress: goal == null ? 0 : progress.caloriesConsumed / goal.calorieTarget,
                          label: 'Calories',
                          centerText: '${progress.caloriesConsumed.round()}',
                          color: AppColors.sunGold,
                        ),
                        ProgressRing(
                          progress: goal == null ? 0 : progress.proteinConsumedG / goal.proteinTargetG,
                          label: 'Protein',
                          centerText: '${progress.proteinConsumedG.round()}g',
                          color: AppColors.ocean,
                        ),
                        ProgressRing(
                          progress: goal == null ? 0 : progress.waterConsumedL / goal.waterTargetL,
                          label: 'Water',
                          centerText: '${progress.waterConsumedL.toStringAsFixed(1)}L',
                          color: AppColors.oceanLight,
                        ),
                      ],
                    ),
                    if (goal == null) ...[
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => context.push('/progress/goals'),
                        child: const Text('Set up your daily goals →'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _QuickLinksRow(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (i) {
          switch (i) {
            case 1:
              context.push('/nutrition');
              break;
            case 2:
              context.push('/meals');
              break;
            case 3:
              context.push('/progress/history');
              break;
            case 4:
              context.push('/reminders');
              break;
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.restaurant_outlined), label: 'Nutrition'),
          NavigationDestination(icon: Icon(Icons.ramen_dining_outlined), label: 'Meals'),
          NavigationDestination(icon: Icon(Icons.show_chart), label: 'Progress'),
          NavigationDestination(icon: Icon(Icons.notifications_outlined), label: 'Reminders'),
        ],
      ),
    );
  }
}

class _QuickLinksRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => context.push('/progress/history'),
            icon: const Icon(Icons.scale_outlined),
            label: const Text('Log Weight'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => context.push('/reminders'),
            icon: const Icon(Icons.alarm_add_outlined),
            label: const Text('Add Reminder'),
          ),
        ),
      ],
    );
  }
}
