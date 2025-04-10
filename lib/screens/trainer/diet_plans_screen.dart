// lib/screens/trainer/diet_plans_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app.dart';
import '../../models/diet_model.dart';
import '../../utils/constants.dart';
import '../../utils/dummy_data.dart';
import '../../utils/runtime_storage.dart';
import '../../widgets/common/app_bar.dart';
import '../../widgets/common/bottom_navigation.dart';
import '../../widgets/diet/diet_card.dart';

class TrainerDietPlansScreen extends StatefulWidget {
  const TrainerDietPlansScreen({Key? key}) : super(key: key);

  @override
  State<TrainerDietPlansScreen> createState() => _TrainerDietPlansScreenState();
}

class _TrainerDietPlansScreenState extends State<TrainerDietPlansScreen> {
  int _currentIndex = 3; // Index for the 'Diet' tab
  List<DietPlan> _dietPlans = [];
  String _filter = 'All';

  @override
  void initState() {
    super.initState();
    _dietPlans = RuntimeStorage.getDietPlans();
  }

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/trainer/dashboard');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/trainer/members');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/trainer/workouts');
        break;
      case 3:
        // Already on diet plans
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/trainer/more');
        break;
    }
  }

  void _filterDiets(String filter) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.currentUser!;

    setState(() {
      _filter = filter;
      switch (filter) {
        case 'My Plans':
          _dietPlans =
              RuntimeStorage.getDietPlans()
                  .where((plan) => plan.createdBy == user.id)
                  .toList();
          break;
        case 'All':
        default:
          _dietPlans = RuntimeStorage.getDietPlans();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Diet Plans',
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog();
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Create and manage diet plans for your clients',
              style: TextStyle(color: Colors.grey[400]),
            ),
          ),
          Expanded(
            child:
                _dietPlans.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.restaurant_menu,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No diet plans found',
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              _showCreateDietPlanDialog();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Create New Plan'),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateDietPlanDialog();
        },
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: TrainerBottomNavigation(
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
            ],
          ),
        );
      },
    );
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
                  final userProvider = Provider.of<UserProvider>(
                    context,
                    listen: false,
                  );
                  final user = userProvider.currentUser!;

                  final newPlan = DietPlan(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameController.text,
                    description: descriptionController.text,
                    createdBy: user.id,
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
                  setState(() {
                    _dietPlans = RuntimeStorage.getDietPlans();
                  });
                }
              },
              child: const Text('Create Plan'),
            ),
          ],
        );
      },
    );
  }
}
