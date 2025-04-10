// lib/screens/member/diet/diet_details_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app.dart';
import '../../../models/diet_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/dummy_data.dart';
import '../../../utils/runtime_storage.dart';
import '../../../widgets/common/app_bar.dart';
import '../../../widgets/common/custom_button.dart';
import '../../../widgets/diet/meal_item.dart';

class DietDetailsScreen extends StatefulWidget {
  const DietDetailsScreen({Key? key}) : super(key: key);

  @override
  State<DietDetailsScreen> createState() => _DietDetailsScreenState();
}

class _DietDetailsScreenState extends State<DietDetailsScreen> {
  late DietPlan dietPlan;
  bool isFollowing = false;
  Map<String, bool> completedMeals = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get diet plan from arguments
    dietPlan = ModalRoute.of(context)!.settings.arguments as DietPlan;

    // Check if user is following this plan
    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.currentUser;

    if (currentUser != null) {
      final userId = currentUser.id;
      final followedPlanId = RuntimeStorage.getFollowedPlan(userId, 'diet');
      isFollowing = followedPlanId == dietPlan.id;
    }
  }

  void _toggleFollowDiet() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = userProvider.currentUser;

    if (currentUser != null) {
      final userId = currentUser.id;
      final currentPlanId = RuntimeStorage.getFollowedPlan(userId, 'diet');

      if (isFollowing) {
        // Unfollow current plan
        setState(() {
          isFollowing = false;
        });
        RuntimeStorage.unfollowPlan(userId, 'diet');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You have unfollowed ${dietPlan.name}')),
        );
      } else {
        // Check if already following a different plan
        if (currentPlanId != null && currentPlanId != dietPlan.id) {
          _showFollowConfirmationDialog(userId, currentPlanId);
        } else {
          // Follow this plan
          setState(() {
            isFollowing = true;
          });
          RuntimeStorage.setFollowedPlan(userId, 'diet', dietPlan.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('You are now following ${dietPlan.name}')),
          );
        }
      }
    }
  }

  void _showFollowConfirmationDialog(String userId, String currentPlanId) {
    final currentPlan = DummyData.dietPlans.firstWhere(
      (plan) => plan.id == currentPlanId,
      orElse: () => DummyData.dietPlans.first,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Follow New Diet?'),
          content: Text(
            'You are currently following "${currentPlan.name}". '
            'If you follow "${dietPlan.name}", you will be unfollowed from your current diet plan.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  isFollowing = true;
                });
                RuntimeStorage.unfollowPlan(userId, 'diet');
                RuntimeStorage.setFollowedPlan(userId, 'diet', dietPlan.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('You are now following ${dietPlan.name}'),
                  ),
                );
              },
              child: const Text('Proceed'),
            ),
          ],
        );
      },
    );
  }

  void _editDietPlan() {
    final TextEditingController nameController = TextEditingController(
      text: dietPlan.name,
    );
    final TextEditingController descriptionController = TextEditingController(
      text: dietPlan.description,
    );
    final TextEditingController targetController = TextEditingController(
      text: dietPlan.target,
    );
    final TextEditingController caloriesController = TextEditingController(
      text: dietPlan.calories.toString(),
    );
    final List<Meal> meals = List.from(dietPlan.meals);

    void editMeal(Meal meal) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          final TextEditingController mealNameController =
              TextEditingController(text: meal.name);
          final List<Food> foods = List.from(meal.foods);

          void addFood() {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                final TextEditingController foodNameController =
                    TextEditingController();
                final TextEditingController quantityController =
                    TextEditingController();
                final TextEditingController caloriesController =
                    TextEditingController();

                return AlertDialog(
                  title: const Text('Add Food'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: foodNameController,
                        decoration: const InputDecoration(
                          labelText: 'Food Name',
                        ),
                      ),
                      TextField(
                        controller: quantityController,
                        decoration: const InputDecoration(
                          labelText: 'Quantity (e.g., 1 cup)',
                        ),
                      ),
                      TextField(
                        controller: caloriesController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Calories',
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        foods.add(
                          Food(
                            name: foodNameController.text,
                            quantity: quantityController.text,
                            calories:
                                int.tryParse(caloriesController.text) ?? 0,
                          ),
                        );
                        Navigator.of(context).pop();
                      },
                      child: const Text('Add'),
                    ),
                  ],
                );
              },
            );
          }

          void editFood(Food food, int index) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                final TextEditingController foodNameController =
                    TextEditingController(text: food.name);
                final TextEditingController quantityController =
                    TextEditingController(text: food.quantity);
                final TextEditingController caloriesController =
                    TextEditingController(text: food.calories.toString());

                return AlertDialog(
                  title: const Text('Edit Food'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: foodNameController,
                        decoration: const InputDecoration(
                          labelText: 'Food Name',
                        ),
                      ),
                      TextField(
                        controller: quantityController,
                        decoration: const InputDecoration(
                          labelText: 'Quantity (e.g., 1 cup)',
                        ),
                      ),
                      TextField(
                        controller: caloriesController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Calories',
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        foods[index] = Food(
                          name: foodNameController.text,
                          quantity: quantityController.text,
                          calories:
                              int.tryParse(caloriesController.text) ??
                              food.calories,
                        );
                        Navigator.of(context).pop();
                      },
                      child: const Text('Save'),
                    ),
                  ],
                );
              },
            );
          }

          return AlertDialog(
            title: const Text('Edit Meal'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: mealNameController,
                    decoration: const InputDecoration(
                      labelText: 'Meal Name (e.g., Breakfast)',
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Foods:'),
                  ...foods.asMap().entries.map((entry) {
                    final index = entry.key;
                    final food = entry.value;
                    return ListTile(
                      title: Text(food.name),
                      subtitle: Text(
                        '${food.quantity} - ${food.calories} calories',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => editFood(food, index),
                      ),
                    );
                  }),
                  TextButton(
                    onPressed: addFood,
                    child: const Text('+ Add Food'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  final updatedMeal = Meal(
                    name: mealNameController.text,
                    foods: foods,
                  );
                  Navigator.of(context).pop(updatedMeal);
                },
                child: const Text('Save Meal'),
              ),
            ],
          );
        },
      ).then((updatedMeal) {
        if (updatedMeal != null) {
          setState(() {
            final index = meals.indexOf(meal);
            meals[index] = updatedMeal;
          });
        }
      });
    }

    void addMeal() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          final TextEditingController mealNameController =
              TextEditingController();
          final List<Food> foods = [];

          void addFood() {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                final TextEditingController foodNameController =
                    TextEditingController();
                final TextEditingController quantityController =
                    TextEditingController();
                final TextEditingController caloriesController =
                    TextEditingController();

                return AlertDialog(
                  title: const Text('Add Food'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: foodNameController,
                        decoration: const InputDecoration(
                          labelText: 'Food Name',
                        ),
                      ),
                      TextField(
                        controller: quantityController,
                        decoration: const InputDecoration(
                          labelText: 'Quantity (e.g., 1 cup)',
                        ),
                      ),
                      TextField(
                        controller: caloriesController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Calories',
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        foods.add(
                          Food(
                            name: foodNameController.text,
                            quantity: quantityController.text,
                            calories:
                                int.tryParse(caloriesController.text) ?? 0,
                          ),
                        );
                        Navigator.of(context).pop();
                      },
                      child: const Text('Add'),
                    ),
                  ],
                );
              },
            );
          }

          return AlertDialog(
            title: const Text('Add Meal'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: mealNameController,
                    decoration: const InputDecoration(
                      labelText: 'Meal Name (e.g., Breakfast)',
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Foods:'),
                  ...foods.map(
                    (f) => ListTile(
                      title: Text(f.name),
                      subtitle: Text('${f.quantity} - ${f.calories} calories'),
                    ),
                  ),
                  TextButton(
                    onPressed: addFood,
                    child: const Text('+ Add Food'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  meals.add(Meal(name: mealNameController.text, foods: foods));
                  Navigator.of(context).pop();
                },
                child: const Text('Save Meal'),
              ),
            ],
          );
        },
      );
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Diet Plan'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Plan Name'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                TextField(
                  controller: targetController,
                  decoration: const InputDecoration(
                    labelText: 'Target (e.g., Weight Loss)',
                  ),
                ),
                TextField(
                  controller: caloriesController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Total Calories',
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Meals:'),
                ...meals.map(
                  (m) => ListTile(
                    title: Text(m.name),
                    subtitle: Text('${m.foods.length} foods'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => editMeal(m),
                    ),
                  ),
                ),
                TextButton(onPressed: addMeal, child: const Text('+ Add Meal')),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && meals.isNotEmpty) {
                  final updatedPlan = DietPlan(
                    id: dietPlan.id,
                    name: nameController.text,
                    description: descriptionController.text,
                    createdBy: dietPlan.createdBy,
                    target: targetController.text,
                    duration: '${meals.length} weeks',
                    mealCount: meals.length,
                    calories:
                        int.tryParse(caloriesController.text) ??
                        dietPlan.calories,
                    meals: meals,
                    adherenceData: dietPlan.adherenceData,
                  );

                  // Update in runtime storage
                  RuntimeStorage.updateDietPlan(updatedPlan);

                  Navigator.of(
                    context,
                  ).pop(true); // Return true to indicate changes
                  setState(() {
                    dietPlan = updatedPlan; // Update local state
                  });
                }
              },
              child: const Text('Save Changes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppConstants.dietDetailsTitle,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _editDietPlan();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image
            Container(
              height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/diet_placeholder.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Diet Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dietPlan.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dietPlan.description,
                    style: TextStyle(color: Colors.grey[300]),
                  ),
                  const SizedBox(height: 16),

                  // Target Badge
                  _buildTargetBadge(dietPlan.target),

                  const SizedBox(height: 24),

                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        icon: Icons.timer,
                        label: 'Duration',
                        value: dietPlan.duration,
                      ),
                      _buildStatItem(
                        icon: Icons.restaurant_menu,
                        label: 'Meals',
                        value: dietPlan.mealCount.toString(),
                      ),
                      _buildStatItem(
                        icon: Icons.local_fire_department,
                        label: 'Calories',
                        value: dietPlan.calories.toString(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 16),

                  // Daily Meals
                  const Text(
                    'Daily Meals',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Meals
                  ...dietPlan.meals.map((meal) {
                    final mealKey = meal.name;
                    return MealItem(
                      meal: meal,
                      isCompleted: completedMeals[mealKey] ?? false,
                      onCheckChanged: (bool? value) {
                        setState(() {
                          completedMeals[mealKey] = value ?? false;
                        });
                      },
                    );
                  }),

                  const SizedBox(height: 24),

                  // Calendar (Placeholder)
                  if (dietPlan.adherenceData.isNotEmpty) ...[
                    const Text(
                      'Adherence Calendar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildAdherenceCalendar(),
                    const SizedBox(height: 16),
                    _buildCalendarLegend(),
                    const SizedBox(height: 24),
                  ],

                  // Follow/Unfollow Button
                  CustomButton(
                    text: isFollowing ? 'Unfollow Diet' : 'Follow Diet',
                    onPressed: _toggleFollowDiet,
                    backgroundColor: isFollowing ? Colors.red : Colors.green,
                    textColor: Colors.white,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildTargetBadge(String target) {
    Color badgeColor;
    switch (target.toLowerCase()) {
      case 'weight loss':
        badgeColor = Colors.red;
        break;
      case 'muscle gain':
        badgeColor = Colors.blue;
        break;
      case 'maintenance':
        badgeColor = Colors.green;
        break;
      default:
        badgeColor = Colors.purple;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: badgeColor.withOpacity(0.5), width: 1),
      ),
      child: Text(
        target,
        style: TextStyle(
          color: badgeColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildAdherenceCalendar() {
    // Simple calendar representation
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 1,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: 14, // 2 weeks for prototype
        itemBuilder: (context, index) {
          // Generate date string for the last 14 days
          final date = DateTime.now().subtract(Duration(days: 14 - index));
          final dateStr =
              '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

          // Get adherence status
          String? status = dietPlan.adherenceData[dateStr];

          Color cellColor;
          switch (status) {
            case 'full':
              cellColor = Colors.green;
              break;
            case 'partial':
              cellColor = Colors.yellow;
              break;
            case 'missed':
              cellColor = Colors.red;
              break;
            default:
              cellColor = Colors.grey.withOpacity(0.3);
          }

          return Container(
            decoration: BoxDecoration(
              color: cellColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                date.day.toString(),
                style: TextStyle(
                  color: status == 'partial' ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCalendarLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(Colors.green, 'Fully Followed'),
        const SizedBox(width: 16),
        _buildLegendItem(Colors.yellow, 'Partially Followed'),
        const SizedBox(width: 16),
        _buildLegendItem(Colors.red, 'Missed Day'),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
      ],
    );
  }
}
