// lib/screens/owner/members_screen.dart
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

class OwnerMembersScreen extends StatefulWidget {
  const OwnerMembersScreen({Key? key}) : super(key: key);

  @override
  State<OwnerMembersScreen> createState() => _OwnerMembersScreenState();
}

class _OwnerMembersScreenState extends State<OwnerMembersScreen> {
  int _currentIndex = 1; // Index for the 'Members' tab
  String _searchQuery = '';
  String _filterOption = 'All';

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/owner/dashboard');
        break;
      case 1:
        // Already on Members screen
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/owner/trainers');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/owner/payments');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/owner/more');
        break;
    }
  }

  List<User> _getFilteredMembers() {
    List<User> members =
        DummyData.users
            .where((user) => user.role == AppConstants.roleMember)
            .toList();

    if (_searchQuery.isNotEmpty) {
      members =
          members
              .where(
                (member) =>
                    member.name.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ||
                    member.email.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ),
              )
              .toList();
    }

    if (_filterOption == 'Assigned') {
      members =
          members.where((member) => member.assignedTrainerId != null).toList();
    } else if (_filterOption == 'Unassigned') {
      members =
          members.where((member) => member.assignedTrainerId == null).toList();
    }

    return members;
  }

  @override
  Widget build(BuildContext context) {
    final filteredMembers = _getFilteredMembers();
    final trainers =
        DummyData.users
            .where((user) => user.role == AppConstants.roleTrainer)
            .toList();

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Manage Members',
        showBackButton: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search members...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFF2A2A2A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: _filterOption,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                    underline: const SizedBox(),
                    dropdownColor: const Color(0xFF2A2A2A),
                    items: const [
                      DropdownMenuItem(value: 'All', child: Text('All')),
                      DropdownMenuItem(
                        value: 'Assigned',
                        child: Text('Assigned'),
                      ),
                      DropdownMenuItem(
                        value: 'Unassigned',
                        child: Text('Unassigned'),
                      ),
                    ],
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _filterOption = newValue;
                        });
                      }
                    },
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child:
                filteredMembers.isEmpty
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
                            'No members found',
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredMembers.length,
                      itemBuilder: (context, index) {
                        final member = filteredMembers[index];
                        return _buildMemberCard(member, trainers);
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Adding new members not implemented in prototype'),
            ),
          );
        },
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: OwnerBottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }

  Widget _buildMemberCard(User member, List<User> trainers) {
    User? assignedTrainer;
    if (member.assignedTrainerId != null) {
      assignedTrainer = trainers.firstWhere(
        (trainer) => trainer.id == member.assignedTrainerId,
        orElse: () => null as User,
      );
    }

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

    final payments =
        DummyData.payments
            .where((payment) => payment.userId == member.id)
            .toList();
    final hasDuePayment = payments.any((payment) => payment.status == 'Due');

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
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Colors.grey),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Assigned Trainer',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      assignedTrainer?.name ?? 'Not assigned',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => _showAssignTrainerDialog(member, trainers),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(8),
                  ),
                  child: const Text('Assign Trainer'),
                ),
              ],
            ),
            const SizedBox(height: 16),

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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Payment Status',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hasDuePayment ? 'Payment Due' : 'Paid',
                      style: TextStyle(
                        color: hasDuePayment ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Payment management not implemented in prototype',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(8),
                  ),
                  child: const Text('Manage Payments'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAssignTrainerDialog(User member, List<User> trainers) {
    String? selectedTrainerId = member.assignedTrainerId;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Assign Trainer to ${member.name}'),
          content: DropdownButton<String>(
            value: selectedTrainerId,
            hint: const Text('Select a trainer'),
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text('Unassign'),
              ),
              ...trainers.map((trainer) {
                return DropdownMenuItem<String>(
                  value: trainer.id,
                  child: Text(trainer.name),
                );
              }).toList(),
            ],
            onChanged: (String? newValue) {
              setState(() {
                selectedTrainerId = newValue;
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Update the member's assigned trainer
                setState(() {
                  member.assignedTrainerId = selectedTrainerId;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Assign'),
            ),
          ],
        );
      },
    );
  }
}
