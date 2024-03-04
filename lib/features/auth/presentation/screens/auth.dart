import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shotgun/features/auth/presentation/screens/initial_screen.dart';
import 'package:shotgun/features/auth/presentation/screens/role_screen.dart';
import 'package:shotgun/features/auth/presentation/state_managment/bloc/auth_bloc.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(GetAuthStatusEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        log('Auth state: ${state.runtimeType}');
        switch (state.runtimeType) {
          case const (AuthUnauthenticated):
            return const InitialScreen();
          case const (AuthInitial):
            return const InitialScreen();
          case const (AuthLoading):
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case const (AuthSuccess):
            return RoleScreen(
              user: (state as AuthSuccess).user,
            );
          case const (AuthFailure):
            final resState = state as AuthFailure;
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: double.infinity,
                  ),
                  Text('An error occurred: ${resState.failure.message}'),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(GetAuthStatusEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }
}
