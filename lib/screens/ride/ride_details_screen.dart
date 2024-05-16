import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shotgun_v2/models/passenger.dart';
import 'package:shotgun_v2/providers/ride_provider.dart';
import 'package:shotgun_v2/utils/dateTime.dart';

class RideDetailsScreen extends StatelessWidget {
  final String rideId;

  const RideDetailsScreen({super.key, required this.rideId});

  @override
  Widget build(BuildContext context) {
    final rideProvider = Provider.of<RideProvider>(context, listen: false);

    return FutureBuilder(
      future: rideProvider.fetchRideDetails(rideId),
      builder: (context, rideSnapshot) {
        if (rideSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Ride Details'),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (rideSnapshot.hasError) {
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
              log('ride.passengers.length: ${ride.passengers.length}');

              return Scaffold(
                appBar: AppBar(
                  title: const Text('Ride Details'),
                ),
                body: Padding(
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
                      Text(
                        ride.driverId,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const Text('Passengers\n',
                          style: TextStyle(fontSize: 20)),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: ride.passengers.length,
                        itemBuilder: (context, index) {
                          log('Passenger index: $index');
                          return FutureBuilder<Passenger>(
                            future: ride.passengers[index],
                            builder: (context, snapshot) {
                              log('Passenger FutureBuilder snapshot: $snapshot');
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return const Text(
                                    'Error fetching passenger details');
                              } else {
                                final passenger = snapshot.data;
                                return Card(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      foregroundImage:
                                          passenger?.imageUrl != null
                                              ? NetworkImage(
                                                  passenger?.imageUrl ?? '')
                                              : null,
                                      child: Text(passenger?.name[0] ?? ''),
                                    ),
                                    title: Text(
                                        '${passenger?.name} - ${passenger?.email}',
                                        style: const TextStyle(fontSize: 16)),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
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

class BodySpace extends StatelessWidget {
  const BodySpace({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 10);
  }
}
