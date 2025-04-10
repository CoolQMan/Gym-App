// lib/models/user_model.dart
class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String password;
  late final String? assignedTrainerId;
  final List<String>? assignedMemberIds;
  final String? currentWorkoutPlanId;
  final String? currentDietPlanId;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.password,
    this.assignedTrainerId,
    this.assignedMemberIds,
    this.currentWorkoutPlanId,
    this.currentDietPlanId,
  });
}
