import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shotgun/features/core/domain/entities/utils/constants.dart';
import 'package:shotgun/features/core/presentation/general_widgets.dart';
import 'package:shotgun/features/auth/presentation/state_managment/bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        // leading: IconButton(
        //   onPressed: () {
        //     _pushInitialScreen(context);
        //   },
        //   icon: const Icon(CupertinoIcons.back),
        // ),
        automaticallyImplyLeading: true,
      ),
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: Constants.padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Login with email and password text
            const SizedBox(
              width: double.infinity,
              child: Text(
                "L O G I N",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Column(
              children: [
                // Email input
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                  ),
                ),

                // Password input
                TextField(
                  obscureText: _obscureText,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      icon: Icon(
                        _obscureText
                            ? CupertinoIcons.eye
                            : CupertinoIcons.eye_slash,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Login button
            Button('Login', onPressed: _login)
          ],
        ),
      ),
    );
  }

  void _login() {
    context.read<AuthBloc>().add(
          LoginStartedEvent(
            _emailController.text,
            _passwordController.text,
          ),
        );
  }

  void _pushInitialScreen(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/initial');
  }
}
