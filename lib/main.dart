import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shotgun/presentation/screens/auth.dart';
import 'package:shotgun/presentation/screens/create_account_screen.dart';
import 'package:shotgun/presentation/screens/initial_screen.dart';
import 'package:shotgun/presentation/screens/login_screen.dart';
import 'package:shotgun/presentation/screens/role_screen.dart';
import 'package:shotgun/presentation/state_managment/bloc/auth_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          actionIconTheme: null,
          useMaterial3: true,
        ),
        home: const Auth(),
        // Login, create account, and role selection screens
        routes: {
          '/initial': (context) => const InitialScreen(),
          '/login': (context) => const LoginScreen(),
          '/create_account': (context) => const CreateAccountScreen(),
        },
      ),
    );
  }
}
