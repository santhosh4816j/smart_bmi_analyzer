/// A meal plan "category" (e.g. Weight Loss, Vegan) made up of simple,
/// offline meal suggestions. This is intentionally lightweight — a fixed
/// curated list rather than an algorithmic generator — so it works with
/// zero network calls.
class MealPlanCategory {
  final String title;
  final String emoji;
  final List<MealSuggestion> meals;

  const MealPlanCategory({
    required this.title,
    required this.emoji,
    required this.meals,
  });
}

class MealSuggestion {
  final String name;
  final String description;
  final int approxCalories;
  final double approxProteinG;

  const MealSuggestion({
    required this.name,
    required this.description,
    required this.approxCalories,
    required this.approxProteinG,
  });
}

final List<MealPlanCategory> kMealPlans = [
  const MealPlanCategory(
    title: 'Weight Loss',
    emoji: '📉',
    meals: [
      MealSuggestion(name: 'Grilled chicken & broccoli bowl', description: 'Grilled chicken breast, steamed broccoli, small portion of rice.', approxCalories: 420, approxProteinG: 40),
      MealSuggestion(name: 'Egg & spinach scramble', description: '2 eggs scrambled with spinach, served with an apple.', approxCalories: 300, approxProteinG: 18),
      MealSuggestion(name: 'Lentil soup & salad', description: 'Lentil soup with a side salad and olive oil dressing.', approxCalories: 350, approxProteinG: 20),
    ],
  ),
  const MealPlanCategory(
    title: 'Maintenance',
    emoji: '⚖️',
    meals: [
      MealSuggestion(name: 'Salmon, sweet potato & greens', description: 'Baked salmon, roasted sweet potato, sauteed spinach.', approxCalories: 520, approxProteinG: 32),
      MealSuggestion(name: 'Curd & fruit bowl', description: 'Curd topped with banana and almonds.', approxCalories: 380, approxProteinG: 16),
      MealSuggestion(name: 'Rice, beans & vegetables', description: 'Rice with beans, sauteed broccoli, and a drizzle of oil.', approxCalories: 480, approxProteinG: 18),
    ],
  ),
  const MealPlanCategory(
    title: 'Muscle Gain',
    emoji: '💪',
    meals: [
      MealSuggestion(name: 'Chicken, rice & peanut sauce', description: 'Grilled chicken breast, large portion of rice, peanut sauce.', approxCalories: 680, approxProteinG: 48),
      MealSuggestion(name: 'Paneer & oats power bowl', description: 'Paneer cubes, oats, and a banana on the side.', approxCalories: 620, approxProteinG: 32),
      MealSuggestion(name: 'Soya chunks curry & rice', description: 'Soya chunks curry served over a generous portion of rice.', approxCalories: 650, approxProteinG: 45),
    ],
  ),
  const MealPlanCategory(
    title: 'Vegetarian',
    emoji: '🥦',
    meals: [
      MealSuggestion(name: 'Paneer & vegetable stir-fry', description: 'Paneer stir-fried with broccoli and spinach.', approxCalories: 430, approxProteinG: 24),
      MealSuggestion(name: 'Lentil & rice bowl', description: 'Lentils over rice with a side of curd.', approxCalories: 460, approxProteinG: 20),
      MealSuggestion(name: 'Oats with milk & almonds', description: 'Oats cooked in milk, topped with almonds and banana.', approxCalories: 400, approxProteinG: 16),
    ],
  ),
  const MealPlanCategory(
    title: 'Vegan',
    emoji: '🌱',
    meals: [
      MealSuggestion(name: 'Tofu & vegetable stir-fry', description: 'Tofu stir-fried with broccoli and spinach over rice.', approxCalories: 450, approxProteinG: 22),
      MealSuggestion(name: 'Soya chunks & bean curry', description: 'Soya chunks and beans in a light curry with rice.', approxCalories: 500, approxProteinG: 35),
      MealSuggestion(name: 'Peanut & banana oats', description: 'Oats with peanut butter swirl and sliced banana.', approxCalories: 420, approxProteinG: 14),
    ],
  ),
  const MealPlanCategory(
    title: 'High Protein',
    emoji: '🍗',
    meals: [
      MealSuggestion(name: 'Chicken & egg power plate', description: 'Grilled chicken breast with two boiled eggs and greens.', approxCalories: 480, approxProteinG: 55),
      MealSuggestion(name: 'Soya chunks & paneer bowl', description: 'Soya chunks and paneer cubes sauteed with spices.', approxCalories: 510, approxProteinG: 50),
      MealSuggestion(name: 'Fish & lentil plate', description: 'Baked fish with a side of lentils.', approxCalories: 460, approxProteinG: 44),
    ],
  ),
  const MealPlanCategory(
    title: 'Budget Friendly',
    emoji: '💰',
    meals: [
      MealSuggestion(name: 'Egg & rice bowl', description: 'Boiled eggs over rice with a side of curd.', approxCalories: 420, approxProteinG: 20),
      MealSuggestion(name: 'Lentils & rice', description: 'A simple, filling bowl of lentils and rice.', approxCalories: 400, approxProteinG: 16),
      MealSuggestion(name: 'Banana & peanut oats', description: 'Oats with sliced banana and peanuts.', approxCalories: 380, approxProteinG: 12),
    ],
  ),
];
