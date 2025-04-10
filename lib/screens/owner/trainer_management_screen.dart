// lib/screens/owner/trainer_management_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app.dart';
import '../../models/user_model.dart';
import '../../utils/constants.dart';
import '../../utils/dummy_data.dart';
import '../../widgets/common/app_bar.dart';
import '../../widgets/common/bottom_navigation.dart';

class TrainerManagementScreen extends StatefulWidget {
  const TrainerManagementScreen({Key? key}) : super(key: key);

  @override
  State<TrainerManagementScreen> createState() =>
      _TrainerManagementScreenState();
}

class _TrainerManagementScreenState extends State<TrainerManagementScreen> {
  int _currentIndex = 2; // Index for the 'Trainers' tab
  String _searchQuery = '';

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/owner/dashboard');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/owner/members');
        break;
      case 2:
        // Already on trainers screen
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/owner/payments');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/owner/more');
        break;
    }
  }

  List<User> _getFilteredTrainers() {
    List<User> trainers =
        DummyData.users
            .where((user) => user.role == AppConstants.roleTrainer)
            .toList();

    if (_searchQuery.isNotEmpty) {
      trainers =
          trainers
              .where(
                (trainer) =>
                    trainer.name.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ||
                    trainer.email.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ),
              )
              .toList();
    }

    return trainers;
  }

  @override
  Widget build(BuildContext context) {
    final filteredTrainers = _getFilteredTrainers();
    final members =
        DummyData.users
            .where((user) => user.role == AppConstants.roleMember)
            .toList();

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Manage Trainers',
        showBackButton: false,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search trainers...',
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

          // Trainers list
          Expanded(
            child:
                filteredTrainers.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.person_outline,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No trainers found',
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredTrainers.length,
                      itemBuilder: (context, index) {
                        final trainer = filteredTrainers[index];
                        return _buildTrainerCard(trainer, members);
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTrainerDialog();
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

  Widget _buildTrainerCard(User trainer, List<User> members) {
    // Get assigned members
    final assignedMemberIds = trainer.assignedMemberIds ?? [];
    final assignedMembers =
        members
            .where((member) => assignedMemberIds.contains(member.id))
            .toList();

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
                    trainer.name.substring(0, 1),
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trainer.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        trainer.email,
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _showEditTrainerDialog(trainer),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Colors.grey),
            const SizedBox(height: 16),

            // Assigned Members
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Assigned Members (${assignedMembers.length})',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                      onPressed:
                          () => _showAssignMembersDialog(trainer, members),
                      child: const Text('Manage'),
                      style: TextButton.styleFrom(foregroundColor: Colors.blue),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                assignedMembers.isEmpty
                    ? Text(
                      'No members assigned',
                      style: TextStyle(color: Colors.grey[400]),
                    )
                    : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          assignedMembers.map((member) {
                            return Chip(
                              label: Text(member.name),
                              backgroundColor: const Color(0xFF2A2A2A),
                              labelStyle: const TextStyle(color: Colors.white),
                            );
                          }).toList(),
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTrainerDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Trainer'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    emailController.text.isNotEmpty &&
                    passwordController.text.isNotEmpty) {
                  // In a real app, this would add a new trainer to the database
                  // For the prototype, we'll just show a message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Adding new trainers not implemented in prototype',
                      ),
                    ),
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditTrainerDialog(User trainer) {
    final TextEditingController nameController = TextEditingController(
      text: trainer.name,
    );
    final TextEditingController emailController = TextEditingController(
      text: trainer.email,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Trainer'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    emailController.text.isNotEmpty) {
                  // In a real app, this would update the trainer in the database
                  // For the prototype, we'll just show a message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Editing trainers not implemented in prototype',
                      ),
                    ),
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showAssignMembersDialog(User trainer, List<User> allMembers) {
    final assignedMemberIds = List<String>.from(
      trainer.assignedMemberIds ?? [],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Assign Members to ${trainer.name}'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: allMembers.length,
              itemBuilder: (context, index) {
                final member = allMembers[index];
                final isAssigned = assignedMemberIds.contains(member.id);

                return CheckboxListTile(
                  title: Text(member.name),
                  subtitle: Text(member.email),
                  value: isAssigned,
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        assignedMemberIds.add(member.id);
                      } else {
                        assignedMemberIds.remove(member.id);
                      }
                    });
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // In a real app, this would update the trainer's assigned members in the database
                // For the prototype, we'll just show a message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Assigning members not implemented in prototype',
                    ),
                  ),
                );
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
