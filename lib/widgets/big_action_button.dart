import 'package:flutter/material.dart';

class BigActionButton extends StatelessWidget {
  const BigActionButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed();
      },
      style: ElevatedButton.styleFrom(fixedSize: const Size(200, 50)),
      child: Text(text),
    );
  }
}
