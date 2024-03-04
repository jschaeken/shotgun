import 'package:flutter/material.dart';
import 'package:shotgun/features/core/presentation/general_widgets.dart';
import 'package:shotgun/features/auth/presentation/screens/create_account_screen.dart';
import 'package:shotgun/features/auth/presentation/screens/login_screen.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // void navToLogin() {
    //   Navigator.pushNamed(context, 'initial/login');
    // }

    // void navToCreateAccount() {
    //   Navigator.pushNamed(context, 'initial/create_account');
    // }

    return Navigator(
      initialRoute: 'initial',
      onGenerateRoute: (settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case 'initial/login':
            builder = (_) => const LoginScreen();
          case 'initial/create_account':
            builder = (_) => const CreateAccountScreen();
          default:
            builder = (context) => InitialScreenWidget(
                  navToLogin: () =>
                      Navigator.pushNamed(context, 'initial/login'),
                  navToCreateAccount: () =>
                      Navigator.pushNamed(context, 'initial/create_account'),
                );
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}

class InitialScreenWidget extends StatelessWidget {
  final VoidCallback navToLogin;
  final VoidCallback navToCreateAccount;

  const InitialScreenWidget({
    super.key,
    required this.navToLogin,
    required this.navToCreateAccount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          // logim title

          Flexible(
            flex: 1,
            child: Center(
              child: Text(
                "S H O T G U N",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ),

          //

          // login button
          Flexible(
            flex: 2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Button(
                    'Create an account',
                    onPressed: navToCreateAccount,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Button(
                    "Login",
                    onPressed: navToLogin,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
