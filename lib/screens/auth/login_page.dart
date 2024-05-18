import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shotgun_v2/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final AuthProvider authProvider;
  bool iHaveAccount = false;
  late final listener;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.addListener(() {
      if (mounted) {
        _onErrorMessage(authProvider.errorMessage);
        _onLoading(authProvider.isLoading);
      }
    });
  }

  final PageController _pageController = PageController();
  String? name;
  String? email;
  String? password;
  int _currentPage = 0;

  bool isLoading = false;

  List<PageParams> pages = [
    PageParams(
      question: 'What is your name?',
      nextButtonText: 'Next',
      errorEmpty: 'Please enter your name',
    ),
    PageParams(
      question: 'What is your email?',
      nextButtonText: 'Next',
      errorEmpty: 'Please enter your email',
      previousButtonText: 'Back',
    ),
    PageParams(
      question: 'Choose a password',
      errorEmpty: 'Please enter a password',
      previousButtonText: 'Back',
      nextButtonText: 'Sign In',
      obscureText: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shotgun',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          Row(
            children: [
              iHaveAccount
                  ? TextButton(
                      onPressed: () {
                        setState(() {
                          iHaveAccount = false;
                        });
                      },
                      child: const Text('I have an account'),
                    )
                  : TextButton(
                      onPressed: () {
                        setState(() {
                          iHaveAccount = true;
                        });
                      },
                      child: const Text('Registering'),
                    ),
              Switch.adaptive(
                  value: iHaveAccount,
                  onChanged: (value) {
                    setState(() {
                      iHaveAccount = value;
                      if (_currentPage == 0 && iHaveAccount) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      } else if (_currentPage == 1 && !iHaveAccount) {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      }
                    });
                  }),
            ],
          )
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  ...pages.map((page) {
                    return Page(
                      question: page.question,
                      nextButtonText: page.nextButtonText,
                      previousButtonText: page.previousButtonText,
                      errorEmpty: page.errorEmpty,
                      obscureText: page.obscureText,
                      onNext: (value) {
                        _onNext(value);
                      },
                      onBack: (value) {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      },
                    );
                  }),
                ],
              ),
              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          )),
    );
  }

  void _onNext(String value) {
    log('Value: $value');
    if (_currentPage == 0) {
      setState(() {
        name = value;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else if (_currentPage == 1) {
      setState(() {
        email = value;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      setState(() {
        password = value;
      });
      if (!iHaveAccount) {
        authProvider.signUp(email!, password!, name!);
      } else {
        authProvider.signIn(email!, password!);
      }
    }
  }

  void _onErrorMessage(String? value) {
    if (value != null && value.isNotEmpty && mounted) {
      isLoading = false;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(authProvider.errorMessage!),
        ),
      );
    }
  }

  void _onLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }
}

class Page extends StatelessWidget {
  final Function(String value) onNext;
  final String question;
  final String? previousButtonText;
  final Function(String value)? onBack;
  final String nextButtonText;
  final String errorEmpty;
  final bool obscureText;

  Page({
    super.key,
    required this.question,
    required this.onNext,
    this.previousButtonText,
    this.onBack,
    required this.nextButtonText,
    this.obscureText = false,
    this.errorEmpty = 'Please enter a value',
  });

  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    assert(onBack != null || previousButtonText == null);
    focusNode.requestFocus();
    return Column(
      children: [
        TextFormField(
          focusNode: focusNode,
          decoration: InputDecoration(labelText: question),
          controller: controller,
          obscureText: obscureText,
          onFieldSubmitted: onNext,
          validator: (value) {
            if (value!.isEmpty) {
              return errorEmpty;
            }
            return null;
          },
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: previousButtonText == null
              ? MainAxisAlignment.end
              : MainAxisAlignment.spaceBetween,
          children: [
            if (previousButtonText != null)
              ElevatedButton(
                onPressed: () {
                  onBack!(controller.text);
                },
                child: Text(previousButtonText!),
              ),
            ElevatedButton(
              onPressed: () {
                onNext(controller.text);
              },
              child: Text(nextButtonText),
            ),
          ],
        ),
      ],
    );
  }
}

class PageParams {
  final String question;
  final String? previousButtonText;
  final String nextButtonText;
  final String errorEmpty;
  final bool obscureText;

  PageParams({
    required this.question,
    this.previousButtonText,
    required this.nextButtonText,
    this.obscureText = false,
    this.errorEmpty = 'Please enter a value',
  });
}
