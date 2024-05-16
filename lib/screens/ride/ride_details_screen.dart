import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shotgun_v2/providers/ride_provider.dart';

class RideDetailsScreen extends StatelessWidget {
  final String rideId;

  const RideDetailsScreen({super.key, required this.rideId});

  @override
  Widget build(BuildContext context) {
    final rideProvider = Provider.of<RideProvider>(context);

    return FutureBuilder(
      future: rideProvider.fetchRideDetails(rideId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Ride Details'),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Ride Details'),
            ),
            body: const Center(
              child: Text('Error fetching ride details'),
            ),
          );
        } else {
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
                ),
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Destination: ${ride.destination}',
                          style: const TextStyle(fontSize: 20)),
                      const SizedBox(height: 10),
                      Text('Date and Time: ${ride.dateTime}',
                          style: const TextStyle(fontSize: 20)),
                      const SizedBox(height: 10),
                      Text('Driver: ${ride.driverId}',
                          style: const TextStyle(fontSize: 20)),
                      const SizedBox(height: 10),
                      const Text('Passengers:', style: TextStyle(fontSize: 20)),
                      for (String passenger in ride.passengers)
                        Text(passenger, style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
