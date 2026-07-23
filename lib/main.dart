import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/database/hive_boxes.dart';
import 'core/services/notification_service.dart';
import 'core/themes/app_theme.dart';
import 'core/utils/router.dart';
import 'providers/profile_provider.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveBoxes.init();
  await NotificationService.instance.init();
  runApp(const ProviderScope(child: SmartBmiApp()));
}

class SmartBmiApp extends ConsumerWidget {
  const SmartBmiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final hasProfile = ref.watch(profileProvider) != null;
    final router = buildRouter(hasProfile);

    return MaterialApp.router(
      title: 'Smart BMI Analyzer by BeachWeather',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
