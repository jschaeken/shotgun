import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shotgun_v2/providers/auth_provider.dart';
import 'package:shotgun_v2/providers/ride_provider.dart';
import 'package:shotgun_v2/screens/ride/create_ride_screen.dart';
import 'package:shotgun_v2/screens/ride/join_ride_screen.dart';
import 'package:shotgun_v2/screens/ride/ride_details_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RideProvider()),
      ],
      child: MaterialApp(
        title: 'Carpool App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/createRide': (context) => const CreateRideScreen(),
          '/joinRide': (context) => const JoinRideScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/rideDetails') {
            final args = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) {
                return RideDetailsScreen(rideId: args);
              },
            );
          }
          return null;
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rideProvider = Provider.of<RideProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ListView.builder(
        itemCount: rideProvider.rides.length,
        itemBuilder: (context, index) {
          final ride = rideProvider.rides[index];
          return ListTile(
            title: Text(ride.destination),
            subtitle: Text('Driver: ${ride.driverId}'),
            onTap: () {
              Navigator.pushNamed(context, '/rideDetails', arguments: ride.id);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/createRide');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
