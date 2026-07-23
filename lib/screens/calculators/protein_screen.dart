import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/goal.dart';
import '../../core/services/protein_service.dart';
import '../../core/themes/app_theme.dart';
import '../../providers/profile_provider.dart';

class ProteinScreen extends ConsumerStatefulWidget {
  const ProteinScreen({super.key});

  @override
  ConsumerState<ProteinScreen> createState() => _ProteinScreenState();
}

class _ProteinScreenState extends ConsumerState<ProteinScreen> {
  Objective _objective = Objective.maintain;

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider)!;
    final (min, max) = ProteinService.rangeFor(weightKg: profile.weightKg, objective: _objective);

    return Scaffold(
      appBar: AppBar(title: const Text('Daily Protein')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SegmentedButton<Objective>(
            segments: Objective.values
                .map((o) => ButtonSegment(value: o, label: Text(o.label)))
                .toList(),
            selected: {_objective},
            onSelectionChanged: (s) => setState(() => _objective = s.first),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(Icons.egg_alt_outlined, size: 48, color: AppColors.ocean),
                  const SizedBox(height: 12),
                  Text(
                    '${min.round()}–${max.round()} g',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.ocean),
                  ),
                  Text('recommended protein per day', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Why this range?', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  const Text('Maintenance: 1.0–1.2 g per kg of bodyweight'),
                  const Text('Muscle Gain: 1.6–2.2 g per kg of bodyweight'),
                  const Text('Weight Loss: 1.2–1.8 g per kg (helps preserve muscle in a deficit)'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
