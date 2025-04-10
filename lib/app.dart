// lib/app.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/routes.dart';
import 'config/theme.dart';
import 'screens/auth/login_screen.dart';
import 'models/user_model.dart';

class UserProvider extends ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  void setUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }
}

class GymApp extends StatelessWidget {
  const GymApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        title: 'Gym App',
        theme: appTheme,
        routes: appRoutes,
        home: const LoginScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
