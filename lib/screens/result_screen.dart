import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/bmi_record.dart';
import '../models/user_data.dart';
import '../services/bmi_service.dart';
import '../services/calorie_service.dart';
import '../services/history_service.dart';
import '../services/water_service.dart';
import '../data/food_data.dart';
import '../data/exercise_data.dart';
import '../widgets/bmi_result_badge.dart';
import '../widgets/custom_card.dart';
import '../widgets/stat_row.dart';

/// Displays the full BMI analysis: score, category, ideal weight, calories,
/// water intake, and personalized food + exercise recommendations.
class ResultScreen extends StatefulWidget {
  final UserData userData;
  const ResultScreen({super.key, required this.userData});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _saveToHistory();
  }

  Future<void> _saveToHistory() async {
    final data = widget.userData;
    final bmi = BmiService.calculateBmi(weightKg: data.weight, heightCm: data.height);
    final category = BmiService.categoryFor(bmi);

    final record = BmiRecord(
      name: data.name,
      age: data.age,
      gender: data.gender,
      height: data.height,
      weight: data.weight,
      bmi: bmi,
      category: category,
      date: DateTime.now(),
    );
    await HistoryService.addRecord(record);
    if (mounted) setState(() => _saved = true);
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.userData;
    final bmi = BmiService.calculateBmi(weightKg: data.weight, heightCm: data.height);
    final category = BmiService.categoryFor(bmi);
    final description = BmiService.descriptionFor(category);
    final idealWeight = BmiService.idealWeightFor(data.height);
    final diff = BmiService.weightDifference(currentWeight: data.weight, idealWeight: idealWeight);
    final calorieResult = CalorieService.analyze(data);
    final water = WaterService.recommendedIntakeLiters(data.weight);
    final foods = FoodData.recommendations[category] ?? {};
    final exercises = ExerciseData.recommendations[category] ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Your BMI Analysis')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(child: BmiResultBadge(bmi: bmi, category: category)),
            const SizedBox(height: 20),
            CustomCard(
              child: Text(description, style: const TextStyle(fontSize: 14, height: 1.5)),
            ),
            const SizedBox(height: 12),
            _sectionTitle('Ideal Weight'),
            CustomCard(
              child: Column(
                children: [
                  StatRow(
                    icon: Icons.monitor_weight_outlined,
                    label: 'Current Weight',
                    value: '${data.weight.toStringAsFixed(1)} kg',
                  ),
                  StatRow(
                    icon: Icons.flag_outlined,
                    label: 'Ideal Weight',
                    value: '${idealWeight.toStringAsFixed(1)} kg',
                  ),
                  StatRow(
                    icon: diff >= 0 ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                    label: diff >= 0 ? 'You need to gain' : 'You need to lose',
                    value: '${diff.abs().toStringAsFixed(1)} kg',
                    iconColor: diff >= 0 ? Colors.blue : Colors.red,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _sectionTitle('Calorie Needs'),
            CustomCard(
              child: Column(
                children: [
                  StatRow(icon: Icons.local_fire_department_outlined, label: 'BMR', value: '${calorieResult.bmr.toStringAsFixed(0)} kcal'),
                  StatRow(icon: Icons.balance_rounded, label: 'Maintenance', value: '${calorieResult.maintenance.toStringAsFixed(0)} kcal/day'),
                  StatRow(icon: Icons.trending_down_rounded, label: 'Weight Loss', value: '${calorieResult.loss.toStringAsFixed(0)} kcal/day'),
                  StatRow(icon: Icons.trending_up_rounded, label: 'Weight Gain', value: '${calorieResult.gain.toStringAsFixed(0)} kcal/day'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _sectionTitle('Water Intake'),
            CustomCard(
              child: StatRow(
                icon: Icons.water_drop_outlined,
                label: 'Recommended daily intake',
                value: '${water.toStringAsFixed(2)} L',
                iconColor: Colors.blue,
              ),
            ),
            const SizedBox(height: 12),
            _sectionTitle('Food Recommendations'),
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: foods.entries
                    .map((entry) => _foodMealSection(entry.key, entry.value))
                    .toList(),
              ),
            ),
            const SizedBox(height: 12),
            _sectionTitle('Exercise Recommendations'),
            ...exercises.map(
              (ex) => CustomCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.fitness_center_rounded),
                  title: Text(ex['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(ex['detail'] ?? ''),
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (_saved)
              Center(
                child: Text(
                  'Saved to history on ${DateFormat.yMMMd().format(DateTime.now())}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                  ),
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 4),
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );

  Widget _foodMealSection(String meal, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(meal, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 4),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text('• $item', style: const TextStyle(fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }
}
