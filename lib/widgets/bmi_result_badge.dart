import 'package:flutter/material.dart';
import '../services/bmi_service.dart';

/// A large circular badge showing the numeric BMI score and its category,
/// colored according to the BMI category (blue/green/orange/red).
class BmiResultBadge extends StatelessWidget {
  final double bmi;
  final String category;

  const BmiResultBadge({super.key, required this.bmi, required this.category});

  @override
  Widget build(BuildContext context) {
    final color = BmiService.colorFor(category);
    return Column(
      children: [
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [color.withOpacity(0.25), color.withOpacity(0.05)],
            ),
            border: Border.all(color: color, width: 4),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  bmi.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const Text(
                  'BMI',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            category,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
