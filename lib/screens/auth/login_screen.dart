// lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app.dart';
import '../../models/user_model.dart';
import '../../utils/constants.dart';
import '../../utils/dummy_data.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Simulate network delay
      Future.delayed(const Duration(seconds: 1), () {
        final email = _emailController.text.trim();
        final password = _passwordController.text;

        // Find user with matching credentials
        final user = DummyData.users.firstWhere(
          (user) => user.email == email && user.password == password,
          orElse:
              () => User(id: '', name: '', email: '', role: '', password: ''),
        );

        if (user.id.isNotEmpty) {
          // Login successful
          Provider.of<UserProvider>(context, listen: false).setUser(user);

          // Navigate based on user role
          switch (user.role) {
            case AppConstants.roleMember:
              Navigator.pushReplacementNamed(context, '/member/dashboard');
              break;
            case AppConstants.roleTrainer:
              Navigator.pushReplacementNamed(context, '/trainer/dashboard');
              break;
            case AppConstants.roleOwner:
              Navigator.pushReplacementNamed(context, '/owner/dashboard');
              break;
          }
        } else {
          // Login failed
          setState(() {
            _isLoading = false;
            _errorMessage = AppConstants.invalidCredentials;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 80),
                Text(
                  'Welcome to Fitness Hub',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),
                CustomTextField(
                  controller: _emailController,
                  hintText: AppConstants.emailHint,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email, color: Colors.grey),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppConstants.emailRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _passwordController,
                  hintText: AppConstants.passwordHint,
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppConstants.passwordRequired;
                    }
                    return null;
                  },
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 32),
                CustomButton(
                  text: AppConstants.loginButtonText,
                  onPressed: _login,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    // For prototype, just show a message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Sign up functionality not available in prototype',
                        ),
                      ),
                    );
                  },
                  child: Text(
                    AppConstants.signUpButtonText,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 32),
                const Divider(color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'Demo Accounts:',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Member: member@example.com / password\nTrainer: trainer@example.com / password\nOwner: owner@example.com / password',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
