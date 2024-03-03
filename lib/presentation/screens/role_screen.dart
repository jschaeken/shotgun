import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shotgun/domain/models/utils/constants.dart';
import 'package:shotgun/presentation/screens/seat_book_screen.dart';

class RoleScreen extends StatefulWidget {
  const RoleScreen({super.key});

  @override
  State<RoleScreen> createState() => _RoleScreenState();
}

class _RoleScreenState extends State<RoleScreen> {
  bool tripIsLoading = false;

  @override
  Widget build(BuildContext context) {
    final time = DateTime.now();
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // App Title
            Padding(
              padding: Constants.padding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Good ${time.hour < 12 ? 'Morning' : time.hour < 18 ? 'Afternoon' : 'Evening'},\nJacques!',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  tripIsLoading
                      ? const SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(),
                        ).animate().fadeIn()
                      : const CircleAvatar(
                          minRadius: 50,
                          backgroundImage: AssetImage('assets/images/me.jpg'),
                        ).animate().fadeIn(),
                ],
              ),
            ),

            // Logo or Loading

            Center(
              child: Column(
                children: [
                  // Create a trip
                  ElevatedButton(
                      onPressed: () {}, child: const Text('Create a trip')),
                  const SizedBox(
                    height: 30,
                  ),
                  // Join a trip
                  ElevatedButton(
                      onPressed: () async {
                        String? code = await joinTripDialog();
                        if (code != null) {
                          joinTrip(code);
                        }
                      },
                      child: const Text('Join a trip'))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> joinTripDialog() async {
    FocusNode focusNode = FocusNode();
    TextEditingController controller = TextEditingController();
    focusNode.requestFocus();
    return showDialog(
        context: (context),
        builder: (_) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  'Enter Trip Code',
                  style: Theme.of(context).textTheme.labelLarge,
                ),

                // TextInput
                TextField(
                  decoration: const InputDecoration(
                    hintText: '12345',
                  ),
                  controller: controller,
                  focusNode: focusNode,
                  onSubmitted: (value) => Navigator.pop(
                    context,
                    controller.text,
                  ),
                )
              ],
            ),
          );
        });
  }

  Future<void> joinTrip(String code) async {
    //TODO: Join trip in backend
    loadingTrip(true);
    await Future.delayed(const Duration(seconds: 1));
    const String tripId = 'tripId';
    loadingTrip(false);

    if (mounted) {
      navToSeatBooking(tripId);
    }
  }

  void navToSeatBooking(String tripId) {
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(builder: (_) => SeatBookScreen(tripId: tripId)),
    );
  }

  void loadingTrip(bool value) {
    setState(() {
      tripIsLoading = value;
    });
  }
}
