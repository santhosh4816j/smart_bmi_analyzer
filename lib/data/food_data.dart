/// Local, offline food recommendation data grouped by BMI category.
/// No network or API calls are used — everything lives in this Dart map.
class FoodData {
  FoodData._();

  static const Map<String, Map<String, List<String>>> recommendations = {
    'Underweight': {
      'Breakfast': [
        'Whole milk oatmeal with banana and peanut butter',
        'Scrambled eggs with avocado toast',
        'Greek yogurt with granola, nuts, and honey',
      ],
      'Lunch': [
        'Grilled chicken with brown rice and olive oil dressing',
        'Salmon with quinoa and roasted vegetables',
        'Bean and cheese burrito with guacamole',
      ],
      'Dinner': [
        'Beef or paneer stir-fry with noodles and vegetables',
        'Baked fish with sweet potato and steamed broccoli',
        'Lentil curry with rice and ghee',
      ],
      'Snacks': [
        'Trail mix with nuts, seeds, and dried fruit',
        'Peanut butter banana smoothie',
        'Cheese and whole-grain crackers',
      ],
    },
    'Normal': {
      'Breakfast': [
        'Vegetable omelette with whole-grain toast',
        'Overnight oats with berries and chia seeds',
        'Smoothie bowl with fruits and nuts',
      ],
      'Lunch': [
        'Grilled chicken salad with olive oil vinaigrette',
        'Quinoa bowl with chickpeas and roasted veggies',
        'Whole-grain wrap with turkey and greens',
      ],
      'Dinner': [
        'Baked salmon with steamed vegetables',
        'Stir-fried tofu with brown rice',
        'Grilled fish with a side salad',
      ],
      'Snacks': [
        'A handful of mixed nuts',
        'Apple slices with almond butter',
        'Carrot sticks with hummus',
      ],
    },
    'Overweight': {
      'Breakfast': [
        'Egg whites with spinach and whole-grain toast',
        'Low-fat Greek yogurt with berries',
        'Vegetable smoothie with a scoop of protein',
      ],
      'Lunch': [
        'Grilled chicken breast with steamed vegetables',
        'Large mixed salad with lean protein, light dressing',
        'Lentil soup with a small whole-grain roll',
      ],
      'Dinner': [
        'Baked fish with sautéed greens',
        'Vegetable and tofu stir-fry (light oil)',
        'Grilled turkey with roasted vegetables',
      ],
      'Snacks': [
        'Cucumber and cherry tomatoes',
        'A small handful of almonds',
        'Herbal tea with a boiled egg',
      ],
    },
    'Obese': {
      'Breakfast': [
        'Boiled eggs with steamed vegetables',
        'Plain oatmeal (no added sugar) with cinnamon',
        'Green smoothie with spinach and cucumber',
      ],
      'Lunch': [
        'Grilled chicken breast with a large green salad',
        'Steamed vegetables with a small portion of brown rice',
        'Clear vegetable soup with lean protein',
      ],
      'Dinner': [
        'Grilled fish with steamed broccoli and cauliflower',
        'Vegetable soup with a boiled egg',
        'Baked chicken breast with sautéed spinach',
      ],
      'Snacks': [
        'Celery sticks with a small amount of hummus',
        'A small bowl of berries',
        'Green tea with a few almonds',
      ],
    },
  };
}
