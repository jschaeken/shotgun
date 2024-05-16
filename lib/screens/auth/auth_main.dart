import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shotgun_v2/main.dart';
import 'package:shotgun_v2/providers/auth_provider.dart';
import 'package:shotgun_v2/screens/auth/login_page.dart';
import 'package:shotgun_v2/screens/home/home_screen.dart';

class AuthMainPage extends StatelessWidget {
  const AuthMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to the AuthProvider
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // If the user is not logged in, show the AuthPage
        if (authProvider.user == null) {
          return const LoginScreen();
        }
        // If the user is logged in, show the HomeScreen
        return const HomeScreen();
      },
    );
  }
}
