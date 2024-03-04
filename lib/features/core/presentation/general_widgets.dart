import 'package:flutter/material.dart';
import 'package:shotgun/features/core/domain/entities/utils/constants.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const Button(
    this.text, {
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed();
      },
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(
          Size(Constants.buttonLength, 50),
        ),
      ),
      child: Text(text),
    );
  }
}
