import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../data/health_tips_data.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_card.dart';

/// About screen showing app info, version, purpose, and a random health tip.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final randomTip = HealthTipsData.tips[Random().nextInt(HealthTipsData.tips.length)];

    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: AppColors.primaryGradient),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(Icons.monitor_weight_rounded, color: Colors.white, size: 42),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                AppConstants.appName,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text(
                'Version ${AppConstants.appVersion}',
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                ),
              ),
            ),
            const SizedBox(height: 24),
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Purpose', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 8),
                  Text(AppConstants.appPurpose, style: const TextStyle(fontSize: 14, height: 1.5)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            CustomCard(
              child: Row(
                children: [
                  const Icon(Icons.wifi_off_rounded, color: AppColors.secondary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'This app works 100% offline. No internet permission, '
                      'no APIs, and no Firebase are used — your data never '
                      'leaves your device.',
                      style: const TextStyle(fontSize: 13, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            CustomCard(
              child: Row(
                children: [
                  const Icon(Icons.person_outline_rounded, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text('Developer: ${AppConstants.developerName}',
                      style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.lightbulb_outline_rounded, color: AppColors.overweight),
                      SizedBox(width: 8),
                      Text('Health Tip', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(randomTip, style: const TextStyle(fontSize: 14, height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
