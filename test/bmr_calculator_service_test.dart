import 'package:flutter_test/flutter_test.dart';
import 'package:smart_bmi_analyzer/models/enums.dart';
import 'package:smart_bmi_analyzer/services/bmr_calculator_service.dart';

void main() {
  group('BmrCalculatorService', () {
    test('calculateBmr matches Mifflin-St Jeor for males', () {
      final double bmr = BmrCalculatorService.calculateBmr(
        weightKg: 70,
        heightCm: 175,
        age: 30,
        sex: BiologicalSex.male,
      );
      // (10*70) + (6.25*175) - (5*30) + 5 = 700 + 1093.75 - 150 + 5
      expect(bmr, closeTo(1648.75, 0.01));
    });

    test('calculateBmr matches Mifflin-St Jeor for females', () {
      final double bmr = BmrCalculatorService.calculateBmr(
        weightKg: 60,
        heightCm: 165,
        age: 25,
        sex: BiologicalSex.female,
      );
      // (10*60) + (6.25*165) - (5*25) - 161 = 600 + 1031.25 - 125 - 161
      expect(bmr, closeTo(1345.25, 0.01));
    });

    test('calculate scales maintenance calories by activity level', () {
      final CalorieTargets sedentary = BmrCalculatorService.calculate(
        weightKg: 70,
        heightCm: 175,
        age: 30,
        sex: BiologicalSex.male,
        activityLevel: ActivityLevel.sedentary,
      );
      final CalorieTargets active = BmrCalculatorService.calculate(
        weightKg: 70,
        heightCm: 175,
        age: 30,
        sex: BiologicalSex.male,
        activityLevel: ActivityLevel.veryActive,
      );
      expect(active.maintenanceCalories, greaterThan(sedentary.maintenanceCalories));
    });

    test('weight loss target is below maintenance', () {
      final CalorieTargets targets = BmrCalculatorService.calculate(
        weightKg: 80,
        heightCm: 170,
        age: 40,
        sex: BiologicalSex.female,
        activityLevel: ActivityLevel.light,
      );
      expect(targets.weightLossCalories, lessThan(targets.maintenanceCalories));
      expect(targets.weightGainCalories, greaterThan(targets.maintenanceCalories));
    });

    test('recommendedWaterLiters scales with weight', () {
      expect(BmrCalculatorService.recommendedWaterLiters(70), closeTo(2.45, 0.01));
    });
  });
}
