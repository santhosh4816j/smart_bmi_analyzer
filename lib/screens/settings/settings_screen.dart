import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/database/hive_boxes.dart';
import '../../core/models/user_profile.dart';
import '../../providers/profile_provider.dart';
import '../../providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final unitSystem = ref.watch(unitSystemProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _SectionHeader('Appearance'),
          RadioListTile<ThemeMode>(
            title: const Text('Light'),
            value: ThemeMode.light,
            groupValue: themeMode,
            onChanged: (v) => ref.read(themeModeProvider.notifier).setMode(v!),
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Dark'),
            value: ThemeMode.dark,
            groupValue: themeMode,
            onChanged: (v) => ref.read(themeModeProvider.notifier).setMode(v!),
          ),
          RadioListTile<ThemeMode>(
            title: const Text('System Default'),
            value: ThemeMode.system,
            groupValue: themeMode,
            onChanged: (v) => ref.read(themeModeProvider.notifier).setMode(v!),
          ),
          const _SectionHeader('Units'),
          RadioListTile<UnitSystem>(
            title: const Text('Metric (kg, cm)'),
            value: UnitSystem.metric,
            groupValue: unitSystem,
            onChanged: (v) => ref.read(unitSystemProvider.notifier).setUnit(v!),
          ),
          RadioListTile<UnitSystem>(
            title: const Text('Imperial (lb, ft/in)'),
            value: UnitSystem.imperial,
            groupValue: unitSystem,
            onChanged: (v) => ref.read(unitSystemProvider.notifier).setUnit(v!),
          ),
          const _SectionHeader('Data'),
          ListTile(
            leading: const Icon(Icons.restart_alt),
            title: const Text('Reset All Data'),
            subtitle: const Text('Clears your profile, history, and goals from this device'),
            onTap: () => _confirmReset(context, ref),
          ),
          const _SectionHeader('About'),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Smart BMI Analyzer by BeachWeather'),
            subtitle: Text('Version 1.0.0 — 100% offline health companion'),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy'),
            subtitle: const Text('All your data stays on this device. Nothing is uploaded or shared.'),
            onTap: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Privacy'),
                content: const Text(
                  'Smart BMI Analyzer stores your profile, weight history, goals, and '
                  'reminders locally on your device using an offline database. No data '
                  'is transmitted over the internet, and no account is required.',
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmReset(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset All Data?'),
        content: const Text('This will permanently delete your profile, weight history, goals, and reminders. This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await Hive.box<UserProfile>(HiveBoxes.profile).clear();
              await Hive.box(HiveBoxes.weightHistory).clear();
              await Hive.box(HiveBoxes.reminders).clear();
              await Hive.box(HiveBoxes.goals).clear();
              await Hive.box(HiveBoxes.dailyProgress).clear();
              ref.invalidate(profileProvider);
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            child: const Text('Reset', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
      ),
    );
  }
}
