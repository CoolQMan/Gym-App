// lib/screens/member/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app.dart';
import '../../models/diet_model.dart';
import '../../models/payment_model.dart';
import '../../models/workout_model.dart';
import '../../utils/constants.dart';
import '../../utils/dummy_data.dart';
import '../../utils/runtime_storage.dart';
import '../../widgets/common/app_bar.dart';
import '../../widgets/common/bottom_navigation.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/progress/progress_chart.dart';

class MemberDashboardScreen extends StatefulWidget {
  const MemberDashboardScreen({Key? key}) : super(key: key);

  @override
  State<MemberDashboardScreen> createState() => _MemberDashboardScreenState();
}

class _MemberDashboardScreenState extends State<MemberDashboardScreen> {
  WorkoutPlan? currentWorkoutPlan;
  DietPlan? currentDietPlan;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refreshDashboard();
  }

  void _refreshDashboard() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.currentUser!;
    final userId = user.id;

    // Get current workout plan from RuntimeStorage
    final currentWorkoutPlanId = RuntimeStorage.getFollowedPlan(
      userId,
      'workout',
    );
    currentWorkoutPlan =
        currentWorkoutPlanId != null
            ? DummyData.workoutPlans.firstWhere(
              (plan) => plan.id == currentWorkoutPlanId,
              orElse: () => DummyData.workoutPlans.first,
            )
            : null;

    // Get current diet plan from RuntimeStorage
    final currentDietPlanId = RuntimeStorage.getFollowedPlan(userId, 'diet');
    currentDietPlan =
        currentDietPlanId != null
            ? DummyData.dietPlans.firstWhere(
              (plan) => plan.id == currentDietPlanId,
              orElse: () => DummyData.dietPlans.first,
            )
            : null;

    setState(() {}); // This will trigger a rebuild with the latest data
  }

  int _currentIndex = 0;

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;

    switch (index) {
      case 0:
        // Already on dashboard
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/member/progress');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/member/workouts');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/member/diets');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/member/more');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.currentUser!;
    final userId = user.id;

    // Get current workout plan
    WorkoutPlan? currentWorkoutPlan;
    final currentWorkoutPlanId = RuntimeStorage.getFollowedPlan(
      userId,
      'workout',
    );
    if (currentWorkoutPlanId != null) {
      currentWorkoutPlan = DummyData.workoutPlans.firstWhere(
        (plan) => plan.id == currentWorkoutPlanId,
        orElse: () => DummyData.workoutPlans.first,
      );
    }

    DietPlan? currentDietPlan;
    final currentDietPlanId = RuntimeStorage.getFollowedPlan(userId, 'diet');
    if (currentDietPlanId != null) {
      currentDietPlan = DummyData.dietPlans.firstWhere(
        (plan) => plan.id == currentDietPlanId,
        orElse: () => DummyData.dietPlans.first,
      );
    }

    // Get payment status
    final payments =
        DummyData.payments
            .where((payment) => payment.userId == user.id)
            .toList();
    final hasDuePayment = payments.any((payment) => payment.status == 'Due');

    return Scaffold(
      appBar: const CustomAppBar(
        title: AppConstants.dashboardTitle,
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi ${user.name}',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Current Workout Plan
            _buildSectionCard(
              context: context,
              title: 'Current Workout Plan',
              content:
                  currentWorkoutPlan != null
                      ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentWorkoutPlan.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            currentWorkoutPlan.description,
                            style: TextStyle(color: Colors.grey[300]),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.timer,
                                color: Colors.grey,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                currentWorkoutPlan.duration,
                                style: TextStyle(color: Colors.grey[300]),
                              ),
                              const SizedBox(width: 16),
                              const Icon(
                                Icons.fitness_center,
                                color: Colors.grey,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${currentWorkoutPlan.exerciseCount} exercises',
                                style: TextStyle(color: Colors.grey[300]),
                              ),
                            ],
                          ),
                        ],
                      )
                      : const Text(
                        'No workout plan selected',
                        style: TextStyle(color: Colors.grey),
                      ),
              onTap: () {
                if (currentWorkoutPlan != null) {
                  Navigator.pushNamed(
                    context,
                    '/member/workout/details',
                    arguments: currentWorkoutPlan,
                  );
                } else {
                  Navigator.pushNamed(context, '/member/workouts');
                }
              },
            ),

            const SizedBox(height: 16),

            // Current Diet Plan
            _buildSectionCard(
              context: context,
              title: 'Current Diet Plan',
              content:
                  currentDietPlan != null
                      ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentDietPlan.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            currentDietPlan.description,
                            style: TextStyle(color: Colors.grey[300]),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.restaurant,
                                color: Colors.grey,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${currentDietPlan.mealCount} meals',
                                style: TextStyle(color: Colors.grey[300]),
                              ),
                              const SizedBox(width: 16),
                              const Icon(
                                Icons.local_fire_department,
                                color: Colors.grey,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${currentDietPlan.calories} calories',
                                style: TextStyle(color: Colors.grey[300]),
                              ),
                            ],
                          ),
                        ],
                      )
                      : const Text(
                        'No diet plan selected',
                        style: TextStyle(color: Colors.grey),
                      ),
              onTap: () {
                if (currentDietPlan != null) {
                  Navigator.pushNamed(
                    context,
                    '/member/diet/details',
                    arguments: currentDietPlan,
                  );
                } else {
                  Navigator.pushNamed(context, '/member/diets');
                }
              },
            ),

            const SizedBox(height: 16),

            // Progress Tracker
            _buildSectionCard(
              context: context,
              title: 'Progress Tracker',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Current Weight',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${DummyData.progressData.last.bodyWeight} lbs',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Weight Lost',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${DummyData.progressData.first.bodyWeight - DummyData.progressData.last.bodyWeight} lbs',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ProgressChart(
                            progressData: DummyData.progressData,
                            lineColor: Colors.blue,
                            showLabels: false,
                            showGrid: false,
                            showDots: true,
                            title: '',
                            height: 84,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(context, '/member/progress');
              },
            ),

            const SizedBox(height: 16),

            // Payment Status
            _buildSectionCard(
              context: context,
              title: 'Payment Status',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        hasDuePayment ? Icons.warning : Icons.check_circle,
                        color: hasDuePayment ? Colors.orange : Colors.green,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        hasDuePayment
                            ? 'Payment Due'
                            : 'All Payments Completed',
                        style: TextStyle(
                          color: hasDuePayment ? Colors.orange : Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  if (hasDuePayment) ...[
                    const SizedBox(height: 16),
                    CustomButton(
                      text: AppConstants.payNowText,
                      onPressed: () {
                        Navigator.pushNamed(context, '/member/payments');
                      },
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                    ),
                  ],
                ],
              ),
              onTap: () {
                Navigator.pushNamed(context, '/member/payments');
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: MemberBottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required String title,
    required Widget content,
    required VoidCallback onTap,
  }) {
    return Card(
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 16,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              content,
            ],
          ),
        ),
      ),
    );
  }
}
