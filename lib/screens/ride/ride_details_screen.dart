import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shotgun_v2/models/driver.dart';
import 'package:shotgun_v2/models/passenger.dart';
import 'package:shotgun_v2/providers/ride_provider.dart';
import 'package:shotgun_v2/utils/dateTime.dart';

class RideDetailsScreen extends StatelessWidget {
  final String rideId;

  const RideDetailsScreen({super.key, required this.rideId});

  @override
  Widget build(BuildContext context) {
    final rideProvider = Provider.of<RideProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      rideProvider.streamRideDetails(rideId);
    });

    return Consumer<RideProvider>(
      builder: (context, provider, child) {
        final ride = provider.currentRide;
        if (ride == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Ride Details'),
            ),
            body: const Center(
              child: Text('Ride not found'),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Ride Details'),
            actions: [
              // QR Share Button
              IconButton(
                icon: const Icon(Icons.qr_code),
                onPressed: () {
                  _showQRDialog(context);
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Destination'),
                  Text(
                    ride.destination,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const BodySpace(),
                  const Text('Date & Time'),
                  Text(
                    dateTimeToHumanReadable(ride.dateTime),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const BodySpace(),
                  const Text('Driver'),
                  FutureBuilder<Driver?>(
                    future: ride.driver,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text('Error loading driver');
                      } else {
                        final driver = snapshot.data;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              driver?.name ?? 'Unknown Driver',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            CircleAvatar(
                              foregroundImage: driver?.imageUrl != null
                                  ? NetworkImage(driver?.imageUrl ?? '')
                                  : null,
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  const BodySpace(),
                  const Text('Passengers'),
                  const BodySpace(),
                  ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(0),
                    itemCount: ride.passengers.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return PassengerCard(
                        futurePassenger: ride.passengers[index],
                      );
                    },
                  ),
                  if (ride.availableSeats > 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _addPassengerDialog(context, rideProvider);
                            },
                            child: const Text('Invite Passengers'),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _addPassengerDialog(BuildContext context, RideProvider rideProvider) {
    final emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Passenger'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter passenger email'),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Add passenger
                rideProvider.addPassenger(emailController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  _showQRDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('QR Code'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Scan this QR code to join the ride'),
              SizedBox(height: 10),
              // Image(
              //   image: AssetImage('assets/images/qr_code.png'),
              // ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class PassengerCard extends StatelessWidget {
  final Future<Passenger?> futurePassenger;

  const PassengerCard({
    super.key,
    required this.futurePassenger,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Passenger?>(
      future: futurePassenger,
      builder: (context, snapshot) {
        log('Passenger FutureBuilder snapshot: $snapshot');
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const SizedBox.shrink();
        } else {
          final passenger = snapshot.data;
          if (passenger == null) {
            return const SizedBox.shrink();
          }
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                foregroundImage: passenger.imageUrl != null
                    ? NetworkImage(passenger.imageUrl ?? '')
                    : null,
              ),
              title: Text(
                passenger.name ?? "Unknown Passenger",
              ),
              subtitle: Text(
                "Seat: ${passenger.seatNumber.toString()}",
              ),
            ),
          );
        }
      },
    );
  }
}

class BodySpace extends StatelessWidget {
  const BodySpace({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 10);
  }
}
