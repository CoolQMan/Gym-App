// lib/models/progress_model.dart
class ProgressEntry {
  final String userId;
  final DateTime date;
  final double bodyWeight;
  final List<ExerciseProgress> exerciseProgress;

  ProgressEntry({
    required this.userId,
    required this.date,
    required this.bodyWeight,
    required this.exerciseProgress,
  });
}

class ExerciseProgress {
  final String exerciseName;
  final double weight;
  final int reps;

  ExerciseProgress({
    required this.exerciseName,
    required this.weight,
    required this.reps,
  });
}
