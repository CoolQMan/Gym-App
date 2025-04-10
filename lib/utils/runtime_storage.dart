// lib/utils/runtime_storage.dart
import '../models/workout_model.dart';
import '../models/diet_model.dart';
import '../models/progress_model.dart';
import '../models/payment_model.dart';
import 'dummy_data.dart';

class RuntimeStorage {
  // Static lists to store runtime data
  static final List<WorkoutPlan> _workoutPlans = List.from(
    DummyData.workoutPlans,
  );
  static final List<DietPlan> _dietPlans = List.from(DummyData.dietPlans);
  static final List<ProgressEntry> _progressData = List.from(
    DummyData.progressData,
  );
  static final List<String> _trackedExercises = ['Bench Press', 'Squats'];
  static final List<Payment> _payments = List.from(DummyData.payments);

  // Methods for following plans
  static final Map<String, Map<String, String>> _followedPlans = {};

  static void setFollowedPlan(String userId, String planType, String planId) {
    if (!_followedPlans.containsKey(userId)) {
      _followedPlans[userId] = {};
    }
    _followedPlans[userId]![planType] = planId;
  }

  static String? getFollowedPlan(String userId, String planType) {
    return _followedPlans[userId]?[planType];
  }

  static void unfollowPlan(String userId, String planType) {
    if (_followedPlans.containsKey(userId) &&
        _followedPlans[userId]!.containsKey(planType)) {
      _followedPlans[userId]!.remove(planType);
    }
  }

  // Methods for Workout Plans
  static List<WorkoutPlan> getWorkoutPlans() {
    return _workoutPlans;
  }

  static void addWorkoutPlan(WorkoutPlan plan) {
    _workoutPlans.add(plan);
  }

  static void updateWorkoutPlan(WorkoutPlan updatedPlan) {
    final index = _workoutPlans.indexWhere((plan) => plan.id == updatedPlan.id);
    if (index >= 0) {
      _workoutPlans[index] = updatedPlan;
    }
  }

  // Methods for Diet Plans
  static List<DietPlan> getDietPlans() {
    return _dietPlans;
  }

  static void addDietPlan(DietPlan plan) {
    _dietPlans.add(plan);
  }

  static void updateDietPlan(DietPlan updatedPlan) {
    final index = _dietPlans.indexWhere((plan) => plan.id == updatedPlan.id);
    if (index >= 0) {
      _dietPlans[index] = updatedPlan;
    }
  }

  // Methods for Progress Data
  static List<ProgressEntry> getProgressData() {
    return _progressData;
  }

  static void addProgressEntry(ProgressEntry entry) {
    _progressData.add(entry);
  }

  // Methods for Tracked Exercises
  static List<String> getTrackedExercises() {
    return _trackedExercises;
  }

  static void addTrackedExercise(String exerciseName) {
    if (!_trackedExercises.contains(exerciseName)) {
      _trackedExercises.add(exerciseName);
    }
  }

  static void removeTrackedExercise(String exerciseName) {
    _trackedExercises.remove(exerciseName);
  }

  // Methods for Payments
  static List<Payment> getPayments() {
    return _payments;
  }

  static void addPayment(Payment payment) {
    _payments.add(payment);
  }

  static void updatePaymentStatus(String paymentId, String status) {
    final index = _payments.indexWhere((payment) => payment.id == paymentId);
    if (index >= 0) {
      final payment = _payments[index];
      _payments[index] = Payment(
        id: payment.id,
        userId: payment.userId,
        amount: payment.amount,
        description: payment.description,
        date: payment.date,
        status: status,
      );
    }
  }
}
