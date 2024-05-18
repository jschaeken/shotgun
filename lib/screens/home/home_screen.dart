import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shotgun_v2/models/driver.dart';
import 'package:shotgun_v2/providers/auth_provider.dart';
import 'package:shotgun_v2/providers/ride_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rideProvider = Provider.of<RideProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.directions_car),
        title: const Text('My Rides',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _signOut(context);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await rideProvider.fetchRides();
        },
        child: ListView.builder(
          itemCount: rideProvider.rides.length,
          itemBuilder: (context, index) {
            final ride = rideProvider.rides[index];
            return Dismissible(
              key: ValueKey(ride.id),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20.0),
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (direction) {
                // Delete the ride
                rideProvider.deleteRide(ride.id);
              },
              child: ListTile(
                title: Text(ride.destination),
                subtitle: FutureBuilder(
                    future: ride.driver,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting ||
                          snapshot.connectionState == ConnectionState.none) {
                        return const Text('');
                      }
                      if (snapshot.data == null) {
                        return const Text('Unknown Driver');
                      }
                      final driver = snapshot.data as Driver;
                      return Text('Driver: ${driver.name}');
                    }),
                trailing: Text(
                    '${ride.seatsTaken}/${ride.availableSeats} seats taken',
                    style: Theme.of(context).textTheme.titleMedium),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/rideDetails',
                    arguments: ride.id,
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Choose an option'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/createRide');
                      },
                      child: const Text('Create a Ride'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/joinRide');
                      },
                      child: const Text('Join a Ride'),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  _signOut(BuildContext context) async {
    // Sign out the user after confirming
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await Provider.of<AuthProvider>(context, listen: false)
                    .signOut();
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }
}
