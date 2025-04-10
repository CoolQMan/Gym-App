// lib/widgets/common/bottom_navigation.dart
import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class MemberBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MemberBottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.black,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: AppConstants.homeLabel,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.show_chart),
          label: AppConstants.progressLabel,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center),
          label: AppConstants.workoutLabel,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant_menu),
          label: AppConstants.dietLabel,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.more_horiz),
          label: AppConstants.moreLabel,
        ),
      ],
    );
  }
}

class TrainerBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const TrainerBottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.black,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: AppConstants.homeLabel,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: AppConstants.membersLabel,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center),
          label: AppConstants.workoutLabel,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant_menu),
          label: AppConstants.dietLabel,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: AppConstants.settingsLabel,
        ),
      ],
    );
  }
}

class OwnerBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const OwnerBottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.black,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: AppConstants.homeLabel,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: AppConstants.membersLabel,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: AppConstants.trainersLabel,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.payment),
          label: AppConstants.paymentsTitle,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: AppConstants.settingsLabel,
        ),
      ],
    );
  }
}
