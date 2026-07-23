/// Local, offline exercise recommendation data grouped by BMI category.
class ExerciseData {
  ExerciseData._();

  static const Map<String, List<Map<String, String>>> recommendations = {
    'Underweight': [
      {'name': 'Strength Training', 'detail': '3-4x/week, focus on compound lifts to build muscle mass'},
      {'name': 'Yoga', 'detail': '2x/week for flexibility and stress reduction'},
      {'name': 'Walking', 'detail': '20-30 min/day light walking to stay active without burning too many calories'},
    ],
    'Normal': [
      {'name': 'Walking', 'detail': '30 min/day to maintain cardiovascular health'},
      {'name': 'Running', 'detail': '2-3x/week for endurance and heart health'},
      {'name': 'Strength Training', 'detail': '2-3x/week full body to maintain muscle tone'},
      {'name': 'Cycling', 'detail': '1-2x/week as a fun low-impact cardio option'},
      {'name': 'Yoga', 'detail': '1-2x/week for flexibility and balance'},
    ],
    'Overweight': [
      {'name': 'Walking', 'detail': '30-45 min/day brisk walking, the safest fat-burning activity'},
      {'name': 'Cycling', 'detail': '3x/week, low-impact cardio great for joints'},
      {'name': 'Swimming', 'detail': '2-3x/week full-body, joint-friendly workout'},
      {'name': 'Strength Training', 'detail': '2x/week to preserve lean muscle while losing fat'},
    ],
    'Obese': [
      {'name': 'Walking', 'detail': '20-30 min/day at a comfortable pace, gradually increasing'},
      {'name': 'Swimming', 'detail': '2x/week — very low impact on joints'},
      {'name': 'Yoga', 'detail': '2x/week gentle yoga to improve mobility'},
      {'name': 'Cycling', 'detail': 'Stationary cycling 2x/week at low resistance'},
    ],
  };
}
