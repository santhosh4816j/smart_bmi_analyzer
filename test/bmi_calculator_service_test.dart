import 'package:flutter_test/flutter_test.dart';
import 'package:smart_bmi_analyzer/models/enums.dart';
import 'package:smart_bmi_analyzer/services/bmi_calculator_service.dart';

void main() {
  group('BmiCalculatorService', () {
    test('calculateBmi returns correct value', () {
      final double bmi = BmiCalculatorService.calculateBmi(
        weightKg: 70,
        heightCm: 175,
      );
      expect(bmi, closeTo(22.86, 0.01));
    });

    test('categoryFor classifies BMI correctly', () {
      expect(BmiCalculatorService.categoryFor(17.0), BmiCategory.underweight);
      expect(BmiCalculatorService.categoryFor(22.0), BmiCategory.normal);
      expect(BmiCalculatorService.categoryFor(27.0), BmiCategory.overweight);
      expect(BmiCalculatorService.categoryFor(32.0), BmiCategory.obeseClassI);
      expect(BmiCalculatorService.categoryFor(37.0), BmiCategory.obeseClassII);
      expect(BmiCalculatorService.categoryFor(42.0), BmiCategory.obeseClassIII);
    });

    test('idealWeightRangeKg brackets the normal BMI range', () {
      final (double min, double max) =
          BmiCalculatorService.idealWeightRangeKg(170);
      final double minBmi = BmiCalculatorService.calculateBmi(
        weightKg: min,
        heightCm: 170,
      );
      final double maxBmi = BmiCalculatorService.calculateBmi(
        weightKg: max,
        heightCm: 170,
      );
      expect(minBmi, closeTo(18.5, 0.01));
      expect(maxBmi, closeTo(24.9, 0.01));
    });

    test('bodySurfaceAreaM2 is positive and reasonable for an adult', () {
      final double bsa = BmiCalculatorService.bodySurfaceAreaM2(
        weightKg: 70,
        heightCm: 175,
      );
      expect(bsa, greaterThan(1.5));
      expect(bsa, lessThan(2.5));
    });

    test('analyze bundles a consistent result', () {
      final BmiAnalysisResult result = BmiCalculatorService.analyze(
        weightKg: 70,
        heightCm: 175,
        age: 30,
        sex: BiologicalSex.male,
      );
      expect(result.category, BmiCalculatorService.categoryFor(result.bmi));
      expect(result.advice, isNotEmpty);
    });
  });
}
