// lib/screens/trainer/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app.dart';
import '../../models/user_model.dart';
import '../../utils/constants.dart';
import '../../utils/dummy_data.dart';
import '../../widgets/common/app_bar.dart';
import '../../widgets/common/bottom_navigation.dart';

class TrainerDashboardScreen extends StatefulWidget {
  const TrainerDashboardScreen({Key? key}) : super(key: key);

  @override
  State<TrainerDashboardScreen> createState() => _TrainerDashboardScreenState();
}

class _TrainerDashboardScreenState extends State<TrainerDashboardScreen> {
  int _currentIndex = 0; // Index for the 'Home' tab

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;

    switch (index) {
      case 0:
        // Already on dashboard
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/trainer/members');
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
        title: 'Trainer Dashboard',
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

            // Assigned Members Section
            _buildSectionCard(
              context: context,
              title: 'Assigned Members',
              content:
                  assignedMembers.isEmpty
                      ? const Text(
                        'No members assigned yet',
                        style: TextStyle(color: Colors.grey),
                      )
                      : Column(
                        children:
                            assignedMembers.map((member) {
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: CircleAvatar(
                                  backgroundColor: Colors.grey[800],
                                  child: Text(
                                    member.name.substring(0, 1),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                title: Text(
                                  member.name,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  'Member',
                                  style: TextStyle(color: Colors.grey[400]),
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey,
                                  size: 16,
                                ),
                                onTap: () {
                                  // Navigate to member details
                                },
                              );
                            }).toList(),
                      ),
              onTap: () {
                Navigator.pushNamed(context, '/trainer/members');
              },
            ),

            const SizedBox(height: 16),

            // Workout Plans Section
            _buildSectionCard(
              context: context,
              title: 'Workout Plans',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${DummyData.workoutPlans.where((plan) => plan.createdBy == user.id).length} plans created by you',
                    style: TextStyle(color: Colors.grey[300]),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/trainer/workouts');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.all(8),
                    ),
                    child: const Text('Create New Plan'),
                  ),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(context, '/trainer/workouts');
              },
            ),

            const SizedBox(height: 16),

            // Diet Plans Section
            _buildSectionCard(
              context: context,
              title: 'Diet Plans',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${DummyData.dietPlans.where((plan) => plan.createdBy == user.id).length} plans created by you',
                    style: TextStyle(color: Colors.grey[300]),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/trainer/diets');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.all(8),
                    ),
                    child: const Text('Create New Plan'),
                  ),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(context, '/trainer/diets');
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: TrainerBottomNavigation(
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
