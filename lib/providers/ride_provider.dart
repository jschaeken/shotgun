import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RideProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Ride> _rides = [];
  Ride? _currentRide;

  List<Ride> get rides => _rides;
  Ride? get currentRide => _currentRide;

  RideProvider() {
    fetchRides();
  }

  // Fetch all rides from Firestore
  Future<void> fetchRides() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('rides').get();
      _rides = snapshot.docs.map((doc) => Ride.fromFirestore(doc)).toList();
      notifyListeners();
    } catch (e) {
      print(e.toString());
      // Handle error
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
  Future<void> joinRide(String rideId, String userId) async {
    try {
      DocumentReference rideRef = _firestore.collection('rides').doc(rideId);
      DocumentSnapshot rideSnapshot = await rideRef.get();

      if (rideSnapshot.exists) {
        Ride ride = Ride.fromFirestore(rideSnapshot);
        ride.passengers.add(userId);
        await rideRef.update({'passengers': ride.passengers});
        _currentRide = ride;
        notifyListeners();
      } else {
        // Handle ride not found
      }
    } catch (e) {
      print(e.toString());
      // Handle error
    }
  }

  // Fetch ride details by ID
  Future<void> fetchRideDetails(String rideId) async {
    try {
      DocumentReference rideRef = _firestore.collection('rides').doc(rideId);
      DocumentSnapshot rideSnapshot = await rideRef.get();

      if (rideSnapshot.exists) {
        _currentRide = Ride.fromFirestore(rideSnapshot);
        notifyListeners();
      } else {
        // Handle ride not found
      }
    } catch (e) {
      print(e.toString());
      // Handle error
    }
  }
}

// Ride model class
class Ride {
  String? id;
  String driverId;
  String destination;
  DateTime dateTime;
  List<String> passengers;

  Ride({
    this.id,
    required this.driverId,
    required this.destination,
    required this.dateTime,
    required this.passengers,
  });

  // Convert Ride object to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'driverId': driverId,
      'destination': destination,
      'dateTime': dateTime.toIso8601String(),
      'passengers': passengers,
    };
  }

  // Create Ride object from Firestore document
  factory Ride.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Ride(
      id: doc.id,
      driverId: data['driverId'],
      destination: data['destination'],
      dateTime: DateTime.parse(data['dateTime']),
      passengers: List<String>.from(data['passengers']),
    );
  }
}
