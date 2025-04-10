// lib/screens/trainer/workout_plans_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app.dart';
import '../../models/workout_model.dart';
import '../../utils/constants.dart';
import '../../utils/dummy_data.dart';
import '../../utils/runtime_storage.dart';
import '../../widgets/common/app_bar.dart';
import '../../widgets/common/bottom_navigation.dart';
import '../../widgets/workout/workout_card.dart';

class TrainerWorkoutPlansScreen extends StatefulWidget {
  const TrainerWorkoutPlansScreen({Key? key}) : super(key: key);

  @override
  State<TrainerWorkoutPlansScreen> createState() =>
      _TrainerWorkoutPlansScreenState();
}

class _TrainerWorkoutPlansScreenState extends State<TrainerWorkoutPlansScreen> {
  int _currentIndex = 2; // Index for the 'Workout' tab
  List<WorkoutPlan> _workoutPlans = [];
  String _filter = 'All';

  @override
  void initState() {
    super.initState();
    _workoutPlans = RuntimeStorage.getWorkoutPlans();
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
        // Already on workout plans
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/trainer/diets');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/trainer/more');
        break;
    }
  }

  void _filterWorkouts(String filter) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.currentUser!;

    setState(() {
      _filter = filter;
      switch (filter) {
        case 'My Plans':
          _workoutPlans =
              RuntimeStorage.getWorkoutPlans()
                  .where((plan) => plan.createdBy == user.id)
                  .toList();
          break;
        case 'All':
        default:
          _workoutPlans = RuntimeStorage.getWorkoutPlans();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Workout Plans',
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
              'Create and manage workout plans for your clients',
              style: TextStyle(color: Colors.grey[400]),
            ),
          ),
          Expanded(
            child:
                _workoutPlans.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.fitness_center,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No workout plans found',
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              _showCreateWorkoutPlanDialog();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Create New Plan'),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _workoutPlans.length,
                      itemBuilder: (context, index) {
                        final workoutPlan = _workoutPlans[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: WorkoutCard(
                            workoutPlan: workoutPlan,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/member/workout/details',
                                arguments: workoutPlan,
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
          _showCreateWorkoutPlanDialog();
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
          title: const Text('Filter Workouts'),
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
                    _filterWorkouts(value!);
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
                    _filterWorkouts(value!);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCreateWorkoutPlanDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final List<WorkoutSession> sessions = [];

    void addSession() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          final TextEditingController dayController = TextEditingController();
          final List<Exercise> exercises = [];

          void addExercise() {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                final TextEditingController exerciseNameController =
                    TextEditingController();
                final TextEditingController setsController =
                    TextEditingController();
                final TextEditingController repsController =
                    TextEditingController();
                final TextEditingController weightController =
                    TextEditingController();

                return AlertDialog(
                  title: const Text('Add Exercise'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: exerciseNameController,
                        decoration: const InputDecoration(
                          labelText: 'Exercise Name',
                        ),
                      ),
                      TextField(
                        controller: setsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Sets'),
                      ),
                      TextField(
                        controller: repsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Reps'),
                      ),
                      TextField(
                        controller: weightController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Weight (lbs)',
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
                        exercises.add(
                          Exercise(
                            name: exerciseNameController.text,
                            sets: int.tryParse(setsController.text) ?? 3,
                            reps: int.tryParse(repsController.text) ?? 10,
                            weight: double.tryParse(weightController.text) ?? 0,
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
            title: const Text('Add Workout Session'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: dayController,
                  decoration: const InputDecoration(
                    labelText: 'Day (e.g., Monday, Tuesday)',
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Exercises:'),
                ...exercises.map(
                  (e) => ListTile(
                    title: Text(e.name),
                    subtitle: Text(
                      '${e.sets} sets × ${e.reps} reps @ ${e.weight} lbs',
                    ),
                  ),
                ),
                TextButton(
                  onPressed: addExercise,
                  child: const Text('+ Add Exercise'),
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
                  sessions.add(
                    WorkoutSession(
                      day: dayController.text,
                      exercises: exercises,
                    ),
                  );
                  Navigator.of(context).pop();
                },
                child: const Text('Save Session'),
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
          title: const Text('Create Workout Plan'),
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
                const SizedBox(height: 16),
                const Text('Sessions:'),
                ...sessions.map(
                  (s) => ListTile(
                    title: Text(s.day),
                    subtitle: Text('${s.exercises.length} exercises'),
                  ),
                ),
                TextButton(
                  onPressed: addSession,
                  child: const Text('+ Add Session'),
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
                if (nameController.text.isNotEmpty && sessions.isNotEmpty) {
                  final userProvider = Provider.of<UserProvider>(
                    context,
                    listen: false,
                  );
                  final user = userProvider.currentUser!;

                  final newPlan = WorkoutPlan(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameController.text,
                    description: descriptionController.text,
                    createdBy: user.id,
                    duration: '${sessions.length} weeks',
                    exerciseCount: sessions.fold(
                      0,
                      (sum, s) => sum + s.exercises.length,
                    ),
                    sessions: sessions,
                    adherenceData: {},
                  );

                  // Add to runtime storage
                  RuntimeStorage.addWorkoutPlan(newPlan);

                  Navigator.of(context).pop();
                  setState(() {
                    _workoutPlans = RuntimeStorage.getWorkoutPlans();
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
