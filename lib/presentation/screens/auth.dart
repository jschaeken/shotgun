import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shotgun/presentation/screens/initial_screen.dart';
import 'package:shotgun/presentation/screens/role_screen.dart';
import 'package:shotgun/presentation/state_managment/bloc/auth_bloc.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

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
            return const RoleScreen();
          case const (AuthFailure):
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: true,
              ),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }
}
