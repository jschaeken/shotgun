import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shotgun_v2/models/driver.dart';
import 'package:shotgun_v2/models/passenger.dart';

class RideProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  List<Ride> _rides = [];
  Ride? _currentRide;
  String? _errorMessage;

  List<Ride> get rides => _rides;
  Ride? get currentRide => _currentRide;

  String? get errorMessage => _errorMessage;

  RideProvider() {
    // Fetch rides on initialization
    fetchRides();
  }

  // Fetch all rides from Firestore
  Future<void> fetchRides() async {
    try {
      final currentUid = _firebaseAuth.currentUser!.uid;
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(currentUid)
          .collection('rides')
          .get();
      _rides = snapshot.docs.map((doc) => Ride.fromFirestore(doc)).toList();
      _errorMessage = null;
      notifyListeners();
    } catch (e, s) {
      if (kDebugMode) {
        print(e.toString());
        print(s.toString());
        _errorMessage = e.toString();
      }
    }
  }

  // Create a new ride
  Future<void> createRide(Ride ride) async {
    try {
      final currentUid = _firebaseAuth.currentUser!.uid;
      DocumentReference docRef = await _firestore
          .collection('users')
          .doc(currentUid)
          .collection('rides')
          .add(ride.toMap());
      ride.id = docRef.id;
      _rides.add(ride);
      _currentRide = ride;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      print(e.toString());
      _errorMessage = e.toString();
    }
  }

  // Join an existing ride
  Future<void> joinRide(String rideId, String userId, int seatNumber) async {
    try {
      final currentUid = _firebaseAuth.currentUser!.uid;
      DocumentReference rideRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('rides')
          .doc(rideId);
      DocumentSnapshot rideSnapshot = await rideRef.get();
      runZonedGuarded(() async {
        if (rideSnapshot.exists && rideSnapshot.data() != null) {
          final Map<String, dynamic> rideData =
              rideSnapshot.data() as Map<String, dynamic>;
          await rideRef.update(
            {
              'passengers': [
                ...rideData['passengers'],
                {
                  'userId': currentUid,
                  'seatNumber': seatNumber,
                },
              ],
            },
          );
          Ride ride = Ride.fromFirestore(rideSnapshot);
          _currentRide = ride;
          _errorMessage = null;
        } else {
          _errorMessage = 'Ride not found';
        }
      }, (e, s) {
        debugPrint(e.toString());
        debugPrintStack(stackTrace: s);
        _errorMessage = e.toString();
      });
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      _errorMessage = e.toString();
    }
    // notifyListeners();
  }

  // Fetch ride details by ID
  // Stream ride details by ID
  void streamRideDetails(String rideId) {
    try {
      final currentUid = _firebaseAuth.currentUser!.uid;
      DocumentReference rideRef = _firestore
          .collection('users')
          .doc(currentUid)
          .collection('rides')
          .doc(rideId);
      rideRef.snapshots().listen((rideSnapshot) {
        if (rideSnapshot.exists) {
          _currentRide =
              Ride.fromFirestore(rideSnapshot, getPassengerDetails: true);
          log('currentRide.passengerMaps.length: ${_currentRide!.passengerMaps.length}');
          _errorMessage = null;
        } else {
          _errorMessage = 'Ride not found';
        }
      });
      notifyListeners();
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void deleteRide(String? id) {
    try {
      final currentUid = _firebaseAuth.currentUser!.uid;
      _firestore
          .collection('users')
          .doc(currentUid)
          .collection('rides')
          .doc(id)
          .delete();
      _rides.removeWhere((ride) => ride.id == id);
      _currentRide = null;
    } catch (e) {
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  void addPassenger(String email) async {
    try {
      if (_currentRide == null) return;
      // Get userId by email
      QuerySnapshot userSnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      if (userSnapshot.docs.isEmpty) {
        _errorMessage = 'User not found';
        notifyListeners();
        return;
      }
      String userId = userSnapshot.docs.first.id;

      DocumentReference rideRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('rides')
          .doc(_currentRide!.id!);
      DocumentSnapshot rideSnapshot = await rideRef.get();
      if (rideSnapshot.exists) {
        final Map<String, dynamic> rideData =
            rideSnapshot.data() as Map<String, dynamic>;
        await rideRef.set(
          {
            'passengers': [
              ...rideData['passengers'],
              {
                'userId': userId,
                'seatNumber': _currentRide!.seatsTaken + 1,
              },
            ],
          },
          SetOptions(merge: true),
        );
        log('currentRide: ${_currentRide?.toMap()}');
        _errorMessage = null;
      } else {
        _errorMessage = 'Ride not found';

        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();

      notifyListeners();
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
  List<Future<Passenger?>> passengers;
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

  Ride.empty()
      : driverId = '',
        availableSeats = 5,
        driver = Future.value(null),
        destination = '',
        dateTime = DateTime.now(),
        passengerMaps = [],
        passengers = [];

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
    final passengers = <Future<Passenger?>>[];
    if (getPassengerDetails) {
      for (var passengerMap in passengerMaps) {
        if (passengerMap.isEmpty) continue;
        if (passengerMap['userId'] == null) continue;
        if (passengerMap['seatNumber'] == null) continue;
        final passenger = Passenger.fromRide(
            userId: passengerMap['userId'],
            seatNumber: passengerMap['seatNumber']);
        passengers.add(passenger);
      }
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
