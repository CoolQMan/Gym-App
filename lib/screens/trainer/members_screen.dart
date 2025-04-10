// lib/screens/trainer/members_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app.dart';
import '../../models/diet_model.dart';
import '../../models/user_model.dart';
import '../../models/workout_model.dart';
import '../../utils/constants.dart';
import '../../utils/dummy_data.dart';
import '../../widgets/common/app_bar.dart';
import '../../widgets/common/bottom_navigation.dart';

class TrainerMembersScreen extends StatefulWidget {
  const TrainerMembersScreen({Key? key}) : super(key: key);

  @override
  State<TrainerMembersScreen> createState() => _TrainerMembersScreenState();
}

class _TrainerMembersScreenState extends State<TrainerMembersScreen> {
  int _currentIndex = 1; // Index for the 'Members' tab

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/trainer/dashboard');
        break;
      case 1:
        // Already on members screen
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/trainer/workouts');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/trainer/diets');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/trainer/more');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.currentUser!;

    // Get assigned members
    final assignedMemberIds = user.assignedMemberIds ?? [];
    final assignedMembers =
        DummyData.users
            .where((member) => assignedMemberIds.contains(member.id))
            .toList();

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Manage Members',
        showBackButton: false,
      ),
      body:
          assignedMembers.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.people_outline,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No members assigned yet',
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Members are assigned by the gym owner',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: assignedMembers.length,
                itemBuilder: (context, index) {
                  final member = assignedMembers[index];
                  return _buildMemberCard(member);
                },
              ),
      bottomNavigationBar: TrainerBottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }

  Widget _buildMemberCard(User member) {
    // Get member's current workout and diet plans
    WorkoutPlan? currentWorkoutPlan;
    if (member.currentWorkoutPlanId != null) {
      try {
        currentWorkoutPlan = DummyData.workoutPlans.firstWhere(
          (plan) => plan.id == member.currentWorkoutPlanId,
        );
      } catch (e) {
        currentWorkoutPlan = null;
      }
    }

    DietPlan? currentDietPlan;
    if (member.currentDietPlanId != null) {
      try {
        currentDietPlan = DummyData.dietPlans.firstWhere(
          (plan) => plan.id == member.currentDietPlanId,
        );
      } catch (e) {
        currentDietPlan = null;
      }
    }

    // Get member's progress data
    final progressData =
        DummyData.progressData
            .where((entry) => entry.userId == member.id)
            .toList();

    final hasProgressData = progressData.isNotEmpty;
    final currentWeight = hasProgressData ? progressData.last.bodyWeight : null;
    final weightChange =
        hasProgressData && progressData.length > 1
            ? progressData.last.bodyWeight - progressData.first.bodyWeight
            : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[800],
                  radius: 24,
                  child: Text(
                    member.name.substring(0, 1),
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        member.email,
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.message, color: Colors.blue),
                  onPressed: () {
                    // Show message functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Message functionality not implemented in prototype',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Colors.grey),
            const SizedBox(height: 16),

            // Progress Section
            if (hasProgressData) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Current Weight',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$currentWeight lbs',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  if (weightChange != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Weight Change',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${weightChange.toStringAsFixed(1)} lbs',
                          style: TextStyle(
                            color: weightChange < 0 ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Plans Section
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Current Workout',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentWorkoutPlan?.name ?? 'No plan',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Current Diet',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentDietPlan?.name ?? 'No plan',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.fitness_center, size: 16),
                  label: const Text('Assign Workout'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/trainer/workouts');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.all(8),
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.restaurant_menu, size: 16),
                  label: const Text('Assign Diet'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/trainer/diets');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.all(8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
