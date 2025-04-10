// lib/models/diet_model.dart
class DietPlan {
  final String id;
  final String name;
  final String description;
  final String createdBy;
  final String target;
  final String duration;
  final int mealCount;
  final int calories;
  final List<Meal> meals;
  final Map<String, String> adherenceData; // date -> full/partial/missed

  DietPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.createdBy,
    required this.target,
    required this.duration,
    required this.mealCount,
    required this.calories,
    required this.meals,
    required this.adherenceData,
  });
}

class Meal {
  final String name;
  final List<Food> foods;

  Meal({required this.name, required this.foods});
}

class Food {
  final String name;
  final String quantity;
  final int calories;

  Food({required this.name, required this.quantity, required this.calories});
}
