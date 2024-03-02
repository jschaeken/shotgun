import 'package:flutter/material.dart';
import 'package:shotgun/presentation/screens/role_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          // logim tittle

          Flexible(
            flex: 1,
            child: Container(
              color: Colors.red,
              child: const Center(
                child: Text(
                  "Please login to continue",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    color: Color.fromARGB(255, 28, 92, 144),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          // const Spacer(
          //   flex: 3,
          // ),

          // login button
          Flexible(
            flex: 2,
            child: Container(
              color: Colors.purple,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RoleScreen()),
                    );
                  },
                  child: const Text("Login"),
                ),
              ),
            ),
          ),

          // sign up button
        ],
      ),
    );
  }
}
