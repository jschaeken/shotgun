import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shotgun_v2/models/driver.dart';
import 'package:shotgun_v2/models/passenger.dart';

class RideProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Ride> _rides = [];
  Ride? _currentRide;

  List<Ride> get rides => _rides;
  Ride? get currentRide => _currentRide;

  RideProvider() {
    // Fetch rides on initialization
    fetchRides();
  }

  // Fetch all rides from Firestore
  Future<void> fetchRides() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('rides').get();
      _rides = snapshot.docs.map((doc) => Ride.fromFirestore(doc)).toList();
      notifyListeners();
    } catch (e, s) {
      if (kDebugMode) {
        print(e.toString());
        print(s.toString());
      }
    }
  }

  // Create a new ride
  Future<void> createRide(Ride ride) async {
    try {
      DocumentReference docRef =
          await _firestore.collection('rides').add(ride.toMap());
      ride.id = docRef.id;
      _rides.add(ride);
      notifyListeners();
    } catch (e) {
      print(e.toString());
      // Handle error
    }
  }

  // Join an existing ride
  Future<String?> joinRide(String rideId, String userId, int seatNumber) async {
    try {
      DocumentReference rideRef = _firestore.collection('rides').doc(rideId);
      DocumentSnapshot rideSnapshot = await rideRef.get();

      if (rideSnapshot.exists) {
        await rideRef.set({
          'passengers': FieldValue.arrayUnion([
            {userId, seatNumber}
          ])
        }, SetOptions(merge: true));
        Ride ride = Ride.fromFirestore(rideSnapshot);
        _currentRide = ride;
        notifyListeners();
      } else {
        return 'Ride not found';
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      return 'Error joining ride';
    }
    return null;
  }

  // Fetch ride details by ID
  Future<void> fetchRideDetails(String rideId) async {
    try {
      DocumentReference rideRef = _firestore.collection('rides').doc(rideId);
      DocumentSnapshot rideSnapshot = await rideRef.get();

      if (rideSnapshot.exists) {
        _currentRide =
            Ride.fromFirestore(rideSnapshot, getPassengerDetails: true);
        log('currentRide.passengerMaps.length: ${_currentRide!.passengerMaps.length}');
        notifyListeners();
      } else {
        // Handle ride not found
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      // Handle error
    }
  }
}

// Ride model class
class Ride {
  String? id;
  String driverId;
  int availableSeats;
  Future<Driver?> driver;
  String destination;
  DateTime dateTime;
  List<Map<String, dynamic>> passengerMaps;
  List<Future<Passenger>> passengers;
  int seatsTaken = 0;

  Ride({
    required this.id,
    required this.driverId,
    this.availableSeats = 5,
    required this.driver,
    required this.destination,
    required this.dateTime,
    required this.passengerMaps,
    this.passengers = const [],
  }) {
    seatsTaken = passengerMaps.length;
  }

  Ride.upload({
    required this.driverId,
    required this.destination,
    required this.dateTime,
    required this.availableSeats,
    required this.passengerMaps,
    this.passengers = const [],
  }) : driver = Future.value(null);

  // Convert Ride object to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'driverId': driverId,
      'destination': destination,
      'dateTime': dateTime.toIso8601String(),
      'passengerMaps': passengerMaps,
      'passengers': passengers,
    };
  }

  // Create Ride object from Firestore document
  factory Ride.fromFirestore(DocumentSnapshot doc,
      {bool getPassengerDetails = false}) {
    Map data = doc.data() as Map<String, dynamic>;
    final passengerMaps =
        List<Map<String, dynamic>>.from(data['passengers'] ?? []);
    final passengers = <Future<Passenger>>[];
    if (getPassengerDetails) {
      passengers.addAll(passengerMaps
          .map((map) => Passenger.fromRide(
              userId: map['userId'], seatNumber: map['seatNumber']))
          .toList());
    }
    final driver =
        Driver.fromUserId(userId: data['driverId'], availableSeats: 0);
    return Ride(
      id: doc.id,
      driverId: data['driverId'],
      driver: driver,
      availableSeats: data['availableSeats'] ?? 5,
      destination: data['destination'],
      dateTime: DateTime.parse(data['dateTime']),
      passengerMaps: passengerMaps,
      passengers: passengers,
    );
  }
}
