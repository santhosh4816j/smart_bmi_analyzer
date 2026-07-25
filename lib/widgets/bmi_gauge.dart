import 'package:flutter/material.dart';

import '../models/enums.dart';

class BmiGauge extends StatelessWidget {
  const BmiGauge({required this.bmi, required this.category, super.key});

  final double bmi;
  final BmiCategory category;

  Color _colorFor(BmiCategory category, ColorScheme scheme) => switch (category) {
        BmiCategory.underweight => Colors.lightBlue,
        BmiCategory.normal => Colors.green,
        BmiCategory.overweight => Colors.orange,
        BmiCategory.obeseClassI ||
        BmiCategory.obeseClassII ||
        BmiCategory.obeseClassIII =>
          scheme.error,
      };

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color color = _colorFor(category, scheme);
    // Clamp visual progress between BMI 10 and 45 for a stable gauge range.
    final double progress = ((bmi - 10) / (45 - 10)).clamp(0.0, 1.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: 160,
          height: 160,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              SizedBox(
                width: 160,
                height: 160,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 12,
                  strokeCap: StrokeCap.round,
                  backgroundColor: scheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    bmi.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  Text(
                    'BMI',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            category.label,
            style: TextStyle(color: color, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
