// lib/widgets/diet/meal_item.dart
import 'package:flutter/material.dart';
import '../../models/diet_model.dart';

class MealItem extends StatelessWidget {
  final Meal meal;
  final bool isCompleted;
  final Function(bool?)? onCheckChanged;

  const MealItem({
    Key? key,
    required this.meal,
    this.isCompleted = false,
    this.onCheckChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate total calories for this meal
    final totalCalories = meal.foods.fold<int>(
      0,
      (sum, food) => sum + food.calories,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Meal header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (onCheckChanged != null)
                  Checkbox(
                    value: isCompleted,
                    onChanged: onCheckChanged,
                    activeColor: Colors.green,
                    checkColor: Colors.black,
                    side: const BorderSide(color: Colors.grey),
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          decoration:
                              isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$totalCalories calories',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.expand_more, color: Colors.grey),
                  onPressed: () {
                    // This would toggle expansion in a real app
                  },
                ),
              ],
            ),
          ),

          // Food list
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: meal.foods.map((food) => _buildFoodItem(food)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodItem(Food food) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              food.name,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            food.quantity,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(width: 16),
          Text(
            '${food.calories} cal',
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
