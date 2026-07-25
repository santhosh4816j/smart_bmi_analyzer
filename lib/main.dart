import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/app_constants.dart';
import 'models/bmi_record_model.dart';
import 'models/profile_model.dart';
import 'providers/profile_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/unit_provider.dart';
import 'repositories/bmi_record_repository.dart';
import 'repositories/profile_repository.dart';
import 'screens/splash/splash_screen.dart';
import 'services/food_database_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ProfileModelAdapter());
  Hive.registerAdapter(BmiRecordModelAdapter());

  final ProfileRepository profileRepository = await ProfileRepository.open();
  final BmiRecordRepository bmiRecordRepository =
      await BmiRecordRepository.open();
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  await FoodDatabaseService.instance.load();

  runApp(
    SmartBmiAnalyzerApp(
      profileRepository: profileRepository,
      bmiRecordRepository: bmiRecordRepository,
      prefs: prefs,
    ),
  );
}

class SmartBmiAnalyzerApp extends StatelessWidget {
  const SmartBmiAnalyzerApp({
    required this.profileRepository,
    required this.bmiRecordRepository,
    required this.prefs,
    super.key,
  });

  final ProfileRepository profileRepository;
  final BmiRecordRepository bmiRecordRepository;
  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <ChangeNotifierProvider<ChangeNotifier>>[
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(prefs),
        ),
        ChangeNotifierProvider<UnitProvider>(
          create: (_) => UnitProvider(prefs),
        ),
        ChangeNotifierProvider<ProfileProvider>(
          create: (_) => ProfileProvider(
            profileRepository: profileRepository,
            bmiRecordRepository: bmiRecordRepository,
            prefs: prefs,
          ),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (BuildContext context, ThemeProvider themeProvider, _) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: AppTheme.light(themeProvider.accentColor),
            darkTheme: AppTheme.dark(themeProvider.accentColor),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
