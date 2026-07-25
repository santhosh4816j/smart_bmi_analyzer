import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_constants.dart';
import '../../models/enums.dart';
import '../../providers/theme_provider.dart';
import '../../providers/unit_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = context.watch<ThemeProvider>();
    final UnitProvider unitProvider = context.watch<UnitProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Appearance', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                SegmentedButton<ThemeMode>(
                  segments: const <ButtonSegment<ThemeMode>>[
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.light,
                      icon: Icon(Icons.light_mode_outlined),
                      label: Text('Light'),
                    ),
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.dark,
                      icon: Icon(Icons.dark_mode_outlined),
                      label: Text('Dark'),
                    ),
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.system,
                      icon: Icon(Icons.brightness_auto_outlined),
                      label: Text('Auto'),
                    ),
                  ],
                  selected: <ThemeMode>{themeProvider.themeMode},
                  onSelectionChanged: (Set<ThemeMode> selection) =>
                      themeProvider.setThemeMode(selection.first),
                ),
                const SizedBox(height: 16),
                Text('Accent color', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  children: AppTheme.accentOptions.map((Color color) {
                    final bool selected = color.toARGB32() ==
                        themeProvider.accentColor.toARGB32();
                    return GestureDetector(
                      onTap: () => themeProvider.setAccentColor(color),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: selected
                              ? Border.all(color: Colors.white, width: 3)
                              : null,
                          boxShadow: selected
                              ? <BoxShadow>[
                                  BoxShadow(
                                    color: color.withValues(alpha: 0.5),
                                    blurRadius: 8,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    );
                  }).toList(growable: false),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Units', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                SegmentedButton<UnitSystem>(
                  segments: const <ButtonSegment<UnitSystem>>[
                    ButtonSegment<UnitSystem>(
                      value: UnitSystem.metric,
                      label: Text('Metric (kg/cm)'),
                    ),
                    ButtonSegment<UnitSystem>(
                      value: UnitSystem.imperial,
                      label: Text('Imperial (lb/in)'),
                    ),
                  ],
                  selected: <UnitSystem>{unitProvider.unitSystem},
                  onSelectionChanged: (Set<UnitSystem> selection) =>
                      unitProvider.setUnitSystem(selection.first),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('About', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                const Text('${AppConstants.appName} ${AppConstants.appTagline}'),
                const SizedBox(height: 4),
                Text(
                  'Version 1.0.0 · 100% offline, all data stays on this device.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
