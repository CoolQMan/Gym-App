// lib/screens/owner/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app.dart';
import '../../models/user_model.dart';
import '../../utils/constants.dart';
import '../../utils/dummy_data.dart';
import '../../widgets/common/app_bar.dart';
import '../../widgets/common/bottom_navigation.dart';

class OwnerDashboardScreen extends StatefulWidget {
  const OwnerDashboardScreen({Key? key}) : super(key: key);

  @override
  State<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends State<OwnerDashboardScreen> {
  int _currentIndex = 0; // Index for the 'Home' tab

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;

    switch (index) {
      case 0:
        //Already in Dashboard screen
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/owner/members');
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

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.currentUser!;

    // Get all members
    final members =
        DummyData.users
            .where((user) => user.role == AppConstants.roleMember)
            .toList();

    // Get all trainers
    final trainers =
        DummyData.users
            .where((user) => user.role == AppConstants.roleTrainer)
            .toList();

    // Get payment data
    final payments = DummyData.payments;
    final paidPayments =
        payments.where((payment) => payment.status == 'Paid').toList();
    final duePayments =
        payments.where((payment) => payment.status == 'Due').toList();

    // Calculate total revenue
    final totalRevenue = paidPayments.fold<double>(
      0,
      (sum, payment) => sum + payment.amount,
    );

    // Calculate pending revenue
    final pendingRevenue = duePayments.fold<double>(
      0,
      (sum, payment) => sum + payment.amount,
    );

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Owner Dashboard',
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

            // Stats Overview
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.people,
                    title: 'Members',
                    value: members.length.toString(),
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.person,
                    title: 'Trainers',
                    value: trainers.length.toString(),
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.attach_money,
                    title: 'Revenue',
                    value: '\$${totalRevenue.toStringAsFixed(2)}',
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.pending,
                    title: 'Pending',
                    value: '\$${pendingRevenue.toStringAsFixed(2)}',
                    color: Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Members Section
            _buildSectionCard(
              context: context,
              title: 'Members',
              content: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: ${members.length}',
                        style: TextStyle(color: Colors.grey[300]),
                      ),
                      Text(
                        'Active: ${members.length}',
                        style: TextStyle(color: Colors.grey[300]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/owner/members');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.all(8),
                    ),
                    child: const Text('Manage Members'),
                  ),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(context, '/owner/members');
              },
            ),

            const SizedBox(height: 16),

            // Trainers Section
            _buildSectionCard(
              context: context,
              title: 'Trainers',
              content: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: ${trainers.length}',
                        style: TextStyle(color: Colors.grey[300]),
                      ),
                      Text(
                        'Active: ${trainers.length}',
                        style: TextStyle(color: Colors.grey[300]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Show not implemented message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Trainer management not implemented in prototype',
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.all(8),
                    ),
                    child: const Text('Manage Trainers'),
                  ),
                ],
              ),
              onTap: () {
                // Show not implemented message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Trainer management not implemented in prototype',
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Payments Section
            _buildSectionCard(
              context: context,
              title: 'Payments',
              content: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Received: \$${totalRevenue.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.grey[300]),
                      ),
                      Text(
                        'Pending: \$${pendingRevenue.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.grey[300]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Show not implemented message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Payment management not implemented in prototype',
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.all(8),
                    ),
                    child: const Text('Manage Payments'),
                  ),
                ],
              ),
              onTap: () {
                // Show not implemented message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Payment management not implemented in prototype',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: OwnerBottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(color: Colors.grey[400])),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ],
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
