import 'package:go_router/go_router.dart';

import '../screens/onboarding/onboarding_screen.dart';
import '../screens/onboarding/profile_setup_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/bmi/bmi_screen.dart';
import '../screens/calculators/calorie_screen.dart';
import '../screens/calculators/protein_screen.dart';
import '../screens/calculators/water_screen.dart';
import '../screens/nutrition/nutrition_screen.dart';
import '../screens/meals/meal_plans_screen.dart';
import '../screens/progress/weight_history_screen.dart';
import '../screens/progress/goals_screen.dart';
import '../screens/reminders/reminders_screen.dart';
import '../screens/settings/settings_screen.dart';

GoRouter buildRouter(bool hasProfile) {
  return GoRouter(
    initialLocation: hasProfile ? '/home' : '/onboarding',
    routes: [
      GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
      GoRoute(path: '/profile-setup', builder: (context, state) => const ProfileSetupScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/bmi', builder: (context, state) => const BmiScreen()),
      GoRoute(path: '/calculators/calories', builder: (context, state) => const CalorieScreen()),
      GoRoute(path: '/calculators/protein', builder: (context, state) => const ProteinScreen()),
      GoRoute(path: '/calculators/water', builder: (context, state) => const WaterScreen()),
      GoRoute(path: '/nutrition', builder: (context, state) => const NutritionScreen()),
      GoRoute(path: '/meals', builder: (context, state) => const MealPlansScreen()),
      GoRoute(path: '/progress/history', builder: (context, state) => const WeightHistoryScreen()),
      GoRoute(path: '/progress/goals', builder: (context, state) => const GoalsScreen()),
      GoRoute(path: '/reminders', builder: (context, state) => const RemindersScreen()),
      GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
    ],
  );
}
