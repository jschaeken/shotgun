import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            // Vynl Music Player
            Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 204, 0, 0),
                    Color.fromARGB(255, 0, 255, 221),
                  ],
                ),
                borderRadius: BorderRadius.circular(150),
              ),
            ).animate(
              onPlay: (controller) {
                controller.repeat();
              },
            ).rotate(
              end: 1,
              duration: const Duration(seconds: 5),
            )

            // Music Controls

            // Music Queue

            // Music Search
          ],
        ),
      ),
    );
  }
}
