// lib/widgets/workout/exercise_item.dart
import 'package:flutter/material.dart';
import '../../models/workout_model.dart';

class ExerciseItem extends StatelessWidget {
  final Exercise exercise;
  final bool isCompleted;
  final Function(bool?)? onCheckChanged;

  const ExerciseItem({
    Key? key,
    required this.exercise,
    this.isCompleted = false,
    this.onCheckChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
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
                    exercise.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      decoration:
                          isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    runSpacing: 4,
                    children: [
                      _buildInfoChip(
                        icon: Icons.repeat,
                        label: '${exercise.sets} sets',
                      ),
                      const SizedBox(width: 8),
                      _buildInfoChip(
                        icon: Icons.fitness_center,
                        label: '${exercise.reps} reps',
                      ),
                      const SizedBox(width: 8),
                      if (exercise.weight > 0)
                        _buildInfoChip(
                          icon: Icons.monitor_weight,
                          label: '${exercise.weight} lbs',
                        ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.info_outline, color: Colors.grey),
              onPressed: () {
                _showExerciseInfoDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  void _showExerciseInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(exercise.name),
          backgroundColor: const Color(0xFF2A2A2A),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'How to perform:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _getExerciseInstructions(exercise.name),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text(
                'Target muscles:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _getTargetMuscles(exercise.name),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  String _getExerciseInstructions(String exerciseName) {
    // In a real app, this would come from a database
    switch (exerciseName.toLowerCase()) {
      case 'bench press':
        return 'Lie on a flat bench with your feet on the ground. Grip the barbell with hands slightly wider than shoulder-width. Lower the bar to your chest, then press back up to starting position.';
      case 'squats':
        return 'Stand with feet shoulder-width apart. Bend your knees and lower your hips as if sitting in a chair. Keep your back straight and knees over toes. Return to standing position.';
      case 'deadlift':
        return 'Stand with feet hip-width apart, barbell over mid-foot. Bend at hips and knees to grip the bar. Keep your back flat, then stand up by driving through your heels.';
      default:
        return 'Perform the exercise with proper form, focusing on controlled movements and proper breathing technique.';
    }
  }

  String _getTargetMuscles(String exerciseName) {
    // In a real app, this would come from a database
    switch (exerciseName.toLowerCase()) {
      case 'bench press':
        return 'Chest, Shoulders, Triceps';
      case 'squats':
        return 'Quadriceps, Hamstrings, Glutes, Lower Back';
      case 'deadlift':
        return 'Lower Back, Hamstrings, Glutes, Traps';
      case 'bicep curls':
        return 'Biceps, Forearms';
      case 'shoulder press':
        return 'Shoulders, Triceps';
      case 'lat pulldown':
        return 'Lats, Biceps, Rhomboids';
      default:
        return 'Multiple muscle groups';
    }
  }
}
