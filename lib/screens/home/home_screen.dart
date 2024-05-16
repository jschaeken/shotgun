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
        title: const Text('Dashboard',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          //Log out button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              //Log out
              Provider.of<AuthProvider>(context, listen: false).signOut();
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
            return ListTile(
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
              trailing: Text('${ride.availableSeats} seats taken'),
              onTap: () {
                Navigator.pushNamed(context, '/rideDetails',
                    arguments: ride.id);
              },
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
                        Navigator.pushNamed(context, '/createRide');
                      },
                      child: const Text('Create a Ride'),
                    ),
                    ElevatedButton(
                      onPressed: () {
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
}
