// lib/screens/member/diet/diet_list_screen.dart
import 'package:flutter/material.dart';
import '../../../models/diet_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/dummy_data.dart';
import '../../../utils/runtime_storage.dart';
import '../../../widgets/common/app_bar.dart';
import '../../../widgets/common/bottom_navigation.dart';
import '../../../widgets/diet/diet_card.dart';

class DietListScreen extends StatefulWidget {
  const DietListScreen({Key? key}) : super(key: key);

  @override
  State<DietListScreen> createState() => _DietListScreenState();
}

class _DietListScreenState extends State<DietListScreen> {
  int _currentIndex = 3; // Index for the 'Diet' tab
  List<DietPlan> _dietPlans = [];
  String _filter = 'All';

  @override
  void initState() {
    super.initState();
    _dietPlans = DummyData.dietPlans;
  }

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/member/dashboard');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/member/progress');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/member/workouts');
        break;
      case 3:
        // Already on diet list
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/member/more');
        break;
    }
  }

  void _filterDiets(String filter) {
    setState(() {
      _filter = filter;
      switch (filter) {
        case 'My Plans':
          _dietPlans =
              DummyData.dietPlans
                  .where((plan) => plan.createdBy == '1')
                  .toList();
          break;
        case 'Trainer Plans':
          _dietPlans =
              DummyData.dietPlans
                  .where((plan) => plan.createdBy == '3')
                  .toList();
          break;
        default:
          _dietPlans = DummyData.dietPlans;
      }
    });
  }

  void _showCreateDietPlanDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController targetController = TextEditingController();
    final TextEditingController caloriesController = TextEditingController();
    final List<Meal> meals = [];

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
          title: const Text('Create Diet Plan'),
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
                  final newPlan = DietPlan(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameController.text,
                    description: descriptionController.text,
                    createdBy: '1', // Current user ID
                    target: targetController.text,
                    duration: '${meals.length} weeks',
                    mealCount: meals.length,
                    calories: int.tryParse(caloriesController.text) ?? 0,
                    meals: meals,
                    adherenceData: {},
                  );

                  // Add to runtime storage
                  RuntimeStorage.addDietPlan(newPlan);

                  Navigator.of(context).pop();
                  setState(() {}); // Refresh UI
                }
              },
              child: const Text('Create Plan'),
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
        title: AppConstants.dietsTitle,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog();
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _dietPlans.length,
        itemBuilder: (context, index) {
          final dietPlan = _dietPlans[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: DietCard(
              dietPlan: dietPlan,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/member/diet/details',
                  arguments: dietPlan,
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateDietPlanDialog();
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      bottomNavigationBar: MemberBottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter Diet Plans'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('All Plans'),
                leading: Radio<String>(
                  value: 'All',
                  groupValue: _filter,
                  onChanged: (String? value) {
                    Navigator.pop(context);
                    _filterDiets(value!);
                  },
                ),
              ),
              ListTile(
                title: const Text('My Plans'),
                leading: Radio<String>(
                  value: 'My Plans',
                  groupValue: _filter,
                  onChanged: (String? value) {
                    Navigator.pop(context);
                    _filterDiets(value!);
                  },
                ),
              ),
              ListTile(
                title: const Text('Trainer Plans'),
                leading: Radio<String>(
                  value: 'Trainer Plans',
                  groupValue: _filter,
                  onChanged: (String? value) {
                    Navigator.pop(context);
                    _filterDiets(value!);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
