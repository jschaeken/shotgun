import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shotgun/features/auth/data/datasources/remote_datasource.dart';
import 'package:shotgun/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:shotgun/features/auth/domain/repositories/auth_repo.dart';
import 'package:shotgun/features/auth/presentation/screens/auth.dart';
import 'package:shotgun/features/auth/presentation/screens/create_account_screen.dart';
import 'package:shotgun/features/auth/presentation/screens/initial_screen.dart';
import 'package:shotgun/features/auth/presentation/screens/login_screen.dart';
import 'package:shotgun/features/auth/presentation/state_managment/bloc/auth_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AuthRepository authRepository = AuthRepositoryImpl(
    remoteDataSource: AuthRemoteDataSourceImpl(),
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(
        authRepository: authRepository,
      ),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          actionIconTheme: null,
          useMaterial3: true,
        ),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        home: const Auth(),
        routes: {
          '/initial': (context) => const InitialScreen(),
          '/login': (context) => const LoginScreen(),
          '/create_account': (context) => const CreateAccountScreen(),
        },
      ),
    );
  }
}
