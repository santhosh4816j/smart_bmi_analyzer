import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../core/themes/app_theme.dart';

/// A colorful semicircular gauge showing where the user's BMI sits within
/// the standard bands (Underweight → Obese Class II).
class BmiGauge extends StatefulWidget {
  final double bmi;
  final String category;

  const BmiGauge({super.key, required this.bmi, required this.category});

  @override
  State<BmiGauge> createState() => _BmiGaugeState();
}

class _BmiGaugeState extends State<BmiGauge> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  // Gauge spans BMI 10 to 45 for visual purposes.
  static const double _min = 10;
  static const double _max = 45;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _animation = Tween<double>(begin: _min, end: widget.bmi.clamp(_min, _max))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant BmiGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bmi != widget.bmi) {
      _animation = Tween<double>(begin: oldWidget.bmi.clamp(_min, _max), end: widget.bmi.clamp(_min, _max))
          .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return SizedBox(
          height: 180,
          width: 260,
          child: CustomPaint(
            painter: _GaugePainter(value: _animation.value, min: _min, max: _max),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.bmi.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorForBmiCategory(widget.category),
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.category,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colorForBmiCategory(widget.category),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double value;
  final double min;
  final double max;

  _GaugePainter({required this.value, required this.min, required this.max});

  static const _bands = [
    (18.5, AppColors.underweight),
    (25.0, AppColors.normal),
    (30.0, AppColors.overweight),
    (35.0, AppColors.obese1),
    (45.0, AppColors.obese2),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(10, 10, size.width - 20, (size.width - 20));
    const startAngle = math.pi; // left
    const sweepTotal = math.pi; // semicircle

    double prevBound = min;
    for (final (bound, color) in _bands) {
      final segmentStart = (prevBound - min) / (max - min) * sweepTotal;
      final segmentSweep = ((bound.clamp(min, max)) - prevBound) / (max - min) * sweepTotal;
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 18
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(rect, startAngle + segmentStart, segmentSweep, false, paint);
      prevBound = bound;
    }

    // Needle
    final fraction = ((value - min) / (max - min)).clamp(0.0, 1.0);
    final angle = startAngle + fraction * sweepTotal;
    final center = Offset(rect.center.dx, rect.center.dy);
    final radius = rect.width / 2;
    final needleEnd = Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );
    final needlePaint = Paint()
      ..color = AppColors.navyDark
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, needleEnd, needlePaint);
    canvas.drawCircle(center, 6, Paint()..color = AppColors.navyDark);
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      oldDelegate.value != value;
}
