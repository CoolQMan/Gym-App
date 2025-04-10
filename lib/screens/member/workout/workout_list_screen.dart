// lib/screens/member/workout/workout_list_screen.dart
import 'package:flutter/material.dart';
import '../../../models/workout_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/dummy_data.dart';
import '../../../utils/runtime_storage.dart';
import '../../../widgets/common/app_bar.dart';
import '../../../widgets/common/bottom_navigation.dart';
import '../../../widgets/workout/workout_card.dart';

class WorkoutListScreen extends StatefulWidget {
  const WorkoutListScreen({Key? key}) : super(key: key);

  @override
  State<WorkoutListScreen> createState() => _WorkoutListScreenState();
}

class _WorkoutListScreenState extends State<WorkoutListScreen> {
  int _currentIndex = 2; // Index for the 'Workout' tab
  List<WorkoutPlan> _workoutPlans = [];
  String _filter = 'All';

  @override
  void initState() {
    super.initState();
    _workoutPlans = DummyData.workoutPlans;
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
        // Already on workout list
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/member/diets');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/member/more');
        break;
    }
  }

  void _filterWorkouts(String filter) {
    setState(() {
      _filter = filter;
      switch (filter) {
        case 'My Plans':
          _workoutPlans =
              DummyData.workoutPlans
                  .where((plan) => plan.createdBy == '1')
                  .toList();
          break;
        case 'Trainer Plans':
          _workoutPlans =
              DummyData.workoutPlans
                  .where((plan) => plan.createdBy == '3')
                  .toList();
          break;
        default:
          _workoutPlans = DummyData.workoutPlans;
      }
    });
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
                  final newPlan = WorkoutPlan(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameController.text,
                    description: descriptionController.text,
                    createdBy: '1', // Current user ID
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
        title: AppConstants.workoutsTitle,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateWorkoutPlanDialog();
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
              ListTile(
                title: const Text('Trainer Plans'),
                leading: Radio<String>(
                  value: 'Trainer Plans',
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
}
