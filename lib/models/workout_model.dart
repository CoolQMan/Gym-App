// lib/models/workout_model.dart
class WorkoutPlan {
  final String id;
  final String name;
  final String description;
  final String createdBy;
  final String duration;
  final int exerciseCount;
  final List<WorkoutSession> sessions;
  final Map<String, String> adherenceData; // date -> full/partial/missed

  WorkoutPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.createdBy,
    required this.duration,
    required this.exerciseCount,
    required this.sessions,
    required this.adherenceData,
  });
}

class WorkoutSession {
  final String day;
  final List<Exercise> exercises;

  WorkoutSession({required this.day, required this.exercises});
}

class Exercise {
  final String name;
  final int sets;
  final int reps;
  final double weight;

  Exercise({
    required this.name,
    required this.sets,
    required this.reps,
    required this.weight,
  });
}
