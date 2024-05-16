import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shotgun_v2/firebase_options.dart';
import 'package:shotgun_v2/models/driver.dart';
import 'package:shotgun_v2/providers/auth_provider.dart';
import 'package:shotgun_v2/providers/ride_provider.dart';
import 'package:shotgun_v2/screens/auth/auth_main.dart';
import 'package:shotgun_v2/screens/ride/create_ride_screen.dart';
import 'package:shotgun_v2/screens/ride/join_ride_screen.dart';
import 'package:shotgun_v2/screens/ride/ride_details_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
        title: 'Shotgun',
        theme: ThemeData(primarySwatch: Colors.amber),
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthMainPage(),
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
