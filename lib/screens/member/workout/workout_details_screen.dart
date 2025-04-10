// lib/screens/member/workout/workout_details_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app.dart';
import '../../../models/workout_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/dummy_data.dart';
import '../../../utils/runtime_storage.dart';
import '../../../widgets/common/app_bar.dart';
import '../../../widgets/common/custom_button.dart';
import '../../../widgets/workout/exercise_item.dart';

class WorkoutDetailsScreen extends StatefulWidget {
  const WorkoutDetailsScreen({Key? key}) : super(key: key);

  @override
  State<WorkoutDetailsScreen> createState() => _WorkoutDetailsScreenState();
}

class _WorkoutDetailsScreenState extends State<WorkoutDetailsScreen> {
  late WorkoutPlan workoutPlan;
  bool isFollowing = false;
  Map<String, bool> completedExercises = {};

  @override
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get workout/diet plan from arguments
    workoutPlan = ModalRoute.of(context)!.settings.arguments as WorkoutPlan;

    // Check if user is following this plan
    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.currentUser;

    if (currentUser != null) {
      final userId = currentUser.id;
      final followedPlanId = RuntimeStorage.getFollowedPlan(userId, 'workout');
      isFollowing = followedPlanId == workoutPlan.id;
    }
  }

  void _toggleFollowPlan() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = userProvider.currentUser;

    if (currentUser != null) {
      final userId = currentUser.id;
      final currentPlanId = RuntimeStorage.getFollowedPlan(userId, 'workout');

      if (isFollowing) {
        // Unfollow current plan
        setState(() {
          isFollowing = false;
        });
        RuntimeStorage.unfollowPlan(userId, 'workout');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You have unfollowed ${workoutPlan.name}')),
        );
      } else {
        // Check if already following a different plan
        if (currentPlanId != null && currentPlanId != workoutPlan.id) {
          _showFollowConfirmationDialog(userId, currentPlanId);
        } else {
          // Follow this plan
          setState(() {
            isFollowing = true;
          });
          RuntimeStorage.setFollowedPlan(userId, 'workout', workoutPlan.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('You are now following ${workoutPlan.name}'),
            ),
          );
        }
      }
    }
  }

  void _showFollowConfirmationDialog(String userId, String currentPlanId) {
    final currentPlan = DummyData.workoutPlans.firstWhere(
      (plan) => plan.id == currentPlanId,
      orElse: () => DummyData.workoutPlans.first,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Follow New Plan?'),
          content: Text(
            'You are currently following "${currentPlan.name}". '
            'If you follow "${workoutPlan.name}", you will be unfollowed from your current plan.',
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
                RuntimeStorage.unfollowPlan(userId, 'workout');
                RuntimeStorage.setFollowedPlan(
                  userId,
                  'workout',
                  workoutPlan.id,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('You are now following ${workoutPlan.name}'),
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

  void _editWorkoutPlan() {
    final TextEditingController nameController = TextEditingController(
      text: workoutPlan.name,
    );
    final TextEditingController descriptionController = TextEditingController(
      text: workoutPlan.description,
    );
    final List<WorkoutSession> sessions = List.from(workoutPlan.sessions);

    void editSession(WorkoutSession session) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          final TextEditingController dayController = TextEditingController(
            text: session.day,
          );
          final List<Exercise> exercises = List.from(session.exercises);

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

          void editExercise(Exercise exercise, int index) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                final TextEditingController exerciseNameController =
                    TextEditingController(text: exercise.name);
                final TextEditingController setsController =
                    TextEditingController(text: exercise.sets.toString());
                final TextEditingController repsController =
                    TextEditingController(text: exercise.reps.toString());
                final TextEditingController weightController =
                    TextEditingController(text: exercise.weight.toString());

                return AlertDialog(
                  title: const Text('Edit Exercise'),
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
                        exercises[index] = Exercise(
                          name: exerciseNameController.text,
                          sets:
                              int.tryParse(setsController.text) ??
                              exercise.sets,
                          reps:
                              int.tryParse(repsController.text) ??
                              exercise.reps,
                          weight:
                              double.tryParse(weightController.text) ??
                              exercise.weight,
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
            title: const Text('Edit Workout Session'),
            content: SingleChildScrollView(
              child: Column(
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
                  ...exercises.asMap().entries.map((entry) {
                    final index = entry.key;
                    final e = entry.value;
                    return ListTile(
                      title: Text(e.name),
                      subtitle: Text(
                        '${e.sets} sets × ${e.reps} reps @ ${e.weight} lbs',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => editExercise(e, index),
                      ),
                    );
                  }),
                  TextButton(
                    onPressed: addExercise,
                    child: const Text('+ Add Exercise'),
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
                  final updatedSession = WorkoutSession(
                    day: dayController.text,
                    exercises: exercises,
                  );
                  Navigator.of(context).pop(updatedSession);
                },
                child: const Text('Save Session'),
              ),
            ],
          );
        },
      ).then((updatedSession) {
        if (updatedSession != null) {
          setState(() {
            final index = sessions.indexOf(session);
            sessions[index] = updatedSession;
          });
        }
      });
    }

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
          title: const Text('Edit Workout Plan'),
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
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => editSession(s),
                    ),
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
                  final updatedPlan = WorkoutPlan(
                    id: workoutPlan.id,
                    name: nameController.text,
                    description: descriptionController.text,
                    createdBy: workoutPlan.createdBy,
                    duration: '${sessions.length} weeks',
                    exerciseCount: sessions.fold(
                      0,
                      (sum, s) => sum + s.exercises.length,
                    ),
                    sessions: sessions,
                    adherenceData: workoutPlan.adherenceData,
                  );

                  // Update in runtime storage
                  RuntimeStorage.updateWorkoutPlan(updatedPlan);

                  Navigator.of(
                    context,
                  ).pop(true); // Return true to indicate changes
                  setState(() {
                    workoutPlan = updatedPlan; // Update local state
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
        title: AppConstants.workoutDetailsTitle,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _editWorkoutPlan();
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
                  image: AssetImage('assets/images/workout_placeholder.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Workout Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workoutPlan.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    workoutPlan.description,
                    style: TextStyle(color: Colors.grey[300]),
                  ),
                  const SizedBox(height: 16),

                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        icon: Icons.timer,
                        label: 'Duration',
                        value: workoutPlan.duration,
                      ),
                      _buildStatItem(
                        icon: Icons.fitness_center,
                        label: 'Exercises',
                        value: workoutPlan.exerciseCount.toString(),
                      ),
                      _buildStatItem(
                        icon: Icons.calendar_today,
                        label: 'Sessions',
                        value: workoutPlan.sessions.length.toString(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 16),

                  // Weekly Schedule
                  const Text(
                    'Weekly Schedule',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Sessions
                  ...workoutPlan.sessions.map(
                    (session) => _buildSessionCard(session),
                  ),

                  const SizedBox(height: 24),

                  // Calendar (Placeholder)
                  if (workoutPlan.adherenceData.isNotEmpty) ...[
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
                    text:
                        isFollowing
                            ? AppConstants.unfollowPlanText
                            : AppConstants.followPlanText,
                    onPressed: _toggleFollowPlan,
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

  Widget _buildSessionCard(WorkoutSession session) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              session.day,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            ...session.exercises.map((exercise) {
              final exerciseKey = '${session.day}-${exercise.name}';
              return ExerciseItem(
                exercise: exercise,
                isCompleted: completedExercises[exerciseKey] ?? false,
                onCheckChanged: (bool? value) {
                  setState(() {
                    completedExercises[exerciseKey] = value ?? false;
                  });
                },
              );
            }),
          ],
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
          String? status = workoutPlan.adherenceData[dateStr];

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
