import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/bmi_record_model.dart';
import '../../models/profile_model.dart';
import '../../providers/profile_provider.dart';
import '../../providers/unit_provider.dart';
import '../../services/bmi_calculator_service.dart';
import '../../services/bmr_calculator_service.dart';
import '../../widgets/bmi_gauge.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/stat_tile.dart';
import '../profiles/profile_form_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileProvider profileProvider = context.watch<ProfileProvider>();
    final UnitProvider unitProvider = context.watch<UnitProvider>();
    final ProfileModel? profile = profileProvider.activeProfile;

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: profile == null
          ? _EmptyDashboard(onCreateProfile: () => _openCreateProfile(context))
          : _DashboardBody(profile: profile, unitProvider: unitProvider),
    );
  }

  static void _openCreateProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ProfileFormScreen()),
    );
  }
}

class _EmptyDashboard extends StatelessWidget {
  const _EmptyDashboard({required this.onCreateProfile});

  final VoidCallback onCreateProfile;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.person_add_alt_1, size: 64),
            const SizedBox(height: 16),
            Text(
              'No profile yet',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Create a profile to see your BMI, calories, and trends.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onCreateProfile,
              icon: const Icon(Icons.add),
              label: const Text('Create Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({required this.profile, required this.unitProvider});

  final ProfileModel profile;
  final UnitProvider unitProvider;

  @override
  Widget build(BuildContext context) {
    final BmiAnalysisResult analysis = BmiCalculatorService.analyze(
      weightKg: profile.weightKg,
      heightCm: profile.heightCm,
      age: profile.age,
      sex: profile.sex,
    );
    final CalorieTargets calories = BmrCalculatorService.calculate(
      weightKg: profile.weightKg,
      heightCm: profile.heightCm,
      age: profile.age,
      sex: profile.sex,
      activityLevel: profile.activityLevel,
    );
    final double water = BmrCalculatorService.recommendedWaterLiters(profile.weightKg);
    final List<BmiRecordModel> history =
        context.watch<ProfileProvider>().historyFor(profile.id).take(14).toList().reversed.toList();

    return RefreshIndicator(
      onRefresh: () async {},
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Text(
            'Hi, ${profile.name} 👋',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 20),
          GlassCard(
            child: Column(
              children: <Widget>[
                BmiGauge(bmi: analysis.bmi, category: analysis.category),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    StatTile(
                      icon: Icons.monitor_weight_outlined,
                      label: 'Weight',
                      value:
                          '${unitProvider.displayWeight(profile.weightKg).toStringAsFixed(1)} ${unitProvider.weightUnitLabel}',
                    ),
                    StatTile(
                      icon: Icons.straighten,
                      label: 'Ideal range',
                      value:
                          '${unitProvider.displayWeight(analysis.idealWeightRangeKg.$1).toStringAsFixed(0)}-${unitProvider.displayWeight(analysis.idealWeightRangeKg.$2).toStringAsFixed(0)} ${unitProvider.weightUnitLabel}',
                    ),
                    StatTile(
                      icon: Icons.flag_outlined,
                      label: 'Goal',
                      value: profile.goal.label,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Expanded(
                child: GlassCard(
                  child: StatTile(
                    icon: Icons.local_fire_department_outlined,
                    label: 'Maintenance kcal/day',
                    value: calories.maintenanceCalories.toStringAsFixed(0),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GlassCard(
                  child: StatTile(
                    icon: Icons.water_drop_outlined,
                    label: 'Water target',
                    value: '${water.toStringAsFixed(1)} L',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Weight trend',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 160,
                  child: history.length < 2
                      ? Center(
                          child: Text(
                            'Log more weigh-ins to see your trend.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        )
                      : LineChart(
                          LineChartData(
                            gridData: const FlGridData(show: false),
                            titlesData: const FlTitlesData(show: false),
                            borderData: FlBorderData(show: false),
                            lineBarsData: <LineChartBarData>[
                              LineChartBarData(
                                isCurved: true,
                                color: Theme.of(context).colorScheme.primary,
                                barWidth: 3,
                                dotData: const FlDotData(show: false),
                                spots: <FlSpot>[
                                  for (int i = 0; i < history.length; i++)
                                    FlSpot(i.toDouble(), history[i].weightKg),
                                ],
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Personalized advice',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  analysis.healthRiskNote,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                for (final String tip in analysis.advice)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Icon(Icons.check_circle_outline, size: 18),
                        const SizedBox(width: 8),
                        Expanded(child: Text(tip)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
