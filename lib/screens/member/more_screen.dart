// lib/screens/member/more_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app.dart';
import '../../utils/constants.dart';
import '../../widgets/common/app_bar.dart';
import '../../widgets/common/bottom_navigation.dart';
import '../../widgets/common/custom_button.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  int _currentIndex = 4; // Index for the 'More' tab

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/member/dashboard');
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
        // Already on more screen
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.currentUser!;

    return Scaffold(
      appBar: const CustomAppBar(
        title: AppConstants.moreTitle,
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile section
            _buildProfileSection(user.name),

            const SizedBox(height: 24),

            // Menu items
            _buildMenuItem(
              icon: Icons.person,
              title: 'Profile Settings',
              onTap: () {
                _showFeatureNotImplementedDialog('Profile Settings');
              },
            ),
            _buildMenuItem(
              icon: Icons.notifications,
              title: 'Notifications',
              onTap: () {
                _showFeatureNotImplementedDialog('Notifications');
              },
            ),
            _buildMenuItem(
              icon: Icons.payment,
              title: 'Payment Management',
              onTap: () {
                Navigator.pushNamed(context, '/member/payments');
              },
            ),
            _buildMenuItem(
              icon: Icons.chat,
              title: 'Chat with Trainer',
              onTap: () {
                _showFeatureNotImplementedDialog('Chat with Trainer');
              },
              showBadge: true,
            ),
            _buildMenuItem(
              icon: Icons.help,
              title: 'Help & Support',
              onTap: () {
                _showFeatureNotImplementedDialog('Help & Support');
              },
            ),
            _buildMenuItem(
              icon: Icons.info,
              title: 'About',
              onTap: () {
                _showAboutDialog();
              },
            ),

            const SizedBox(height: 32),

            // Logout button
            CustomButton(
              text: AppConstants.logoutText,
              onPressed: () {
                _showLogoutConfirmationDialog();
              },
              outline: true,
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

  Widget _buildProfileSection(String name) {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(Icons.person, size: 40, color: Colors.white),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Member',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool showBadge = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFF2A2A2A), width: 1),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const Spacer(),
            if (showBadge)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'New',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }

  void _showFeatureNotImplementedDialog(String feature) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$feature Not Available'),
          content: Text(
            'The $feature feature is not available in this prototype.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('About Gym App'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Version: 1.0.0 (Prototype)'),
              SizedBox(height: 16),
              Text(
                'This is a prototype gym management app designed to demonstrate UI/UX concepts and functionality.',
              ),
              SizedBox(height: 16),
              Text('© 2025 Gym App. All rights reserved.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _logout();
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _logout() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.clearUser();
    Navigator.pushReplacementNamed(context, '/login');
  }
}
