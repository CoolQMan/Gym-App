// lib/config/routes.dart
import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/member/dashboard_screen.dart';
import '../screens/member/workout/workout_list_screen.dart';
import '../screens/member/workout/workout_details_screen.dart';
import '../screens/member/diet/diet_list_screen.dart';
import '../screens/member/diet/diet_details_screen.dart';
import '../screens/member/progress_screen.dart';
import '../screens/member/payment_screen.dart';
import '../screens/member/more_screen.dart';
import '../screens/owner/more_screen.dart';
import '../screens/owner/payment_management_screen.dart';
import '../screens/owner/trainer_management_screen.dart';
import '../screens/trainer/dashboard_screen.dart';
import '../screens/trainer/diet_plans_screen.dart';
import '../screens/trainer/members_screen.dart';
import '../screens/owner/dashboard_screen.dart';
import '../screens/owner/members_screen.dart';
import '../screens/trainer/more_screen.dart';
import '../screens/trainer/workout_plans_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/login': (context) => const LoginScreen(),
  '/member/dashboard': (context) => const MemberDashboardScreen(),
  '/member/workouts': (context) => const WorkoutListScreen(),
  '/member/workout/details': (context) => const WorkoutDetailsScreen(),
  '/member/diets': (context) => const DietListScreen(),
  '/member/diet/details': (context) => const DietDetailsScreen(),
  '/member/progress': (context) => const ProgressScreen(),
  '/member/payments': (context) => const PaymentScreen(),
  '/member/more': (context) => const MoreScreen(),
  '/trainer/dashboard': (context) => const TrainerDashboardScreen(),
  '/trainer/members': (context) => const TrainerMembersScreen(),
  '/trainer/workouts': (context) => const TrainerWorkoutPlansScreen(),
  '/trainer/diets': (context) => const TrainerDietPlansScreen(),
  '/trainer/more': (context) => const TrainerMoreScreen(),
  '/owner/dashboard': (context) => const OwnerDashboardScreen(),
  '/owner/members': (context) => const OwnerMembersScreen(),
  '/owner/trainers': (context) => const TrainerManagementScreen(),
  '/owner/payments': (context) => const PaymentManagementScreen(),
  '/owner/more': (context) => const OwnerMoreScreen(),
};
