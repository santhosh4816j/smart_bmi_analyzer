import 'dart:ui';

import 'package:flutter/material.dart';

/// A frosted-glass style card: blurred, translucent background with a
/// subtle border — used throughout the dashboard for the "premium"
/// glassmorphism look requested in the design brief.
class GlassCard extends StatelessWidget {
  const GlassCard({
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = 24,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: scheme.surface.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: scheme.onSurface.withValues(alpha: 0.08),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
