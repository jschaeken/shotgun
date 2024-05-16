import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shotgun_v2/models/rider.dart';

class Passenger extends Rider {
  int? seatNumber;
  Passenger({
    required this.seatNumber,
    required super.userId,
    required super.name,
    required super.email,
    required super.imageUrl,
  });

  static Future<Passenger> fromRide(
      {required String userId, required int seatNumber}) async {
    // Doc only contains the seat number and the userId of the passenger
    // We need to fetch the user details from the users collection

    // Fetch the user details from the users collection
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    return Passenger(
      seatNumber: seatNumber,
      userId: userId,
      name: userDoc['name'],
      email: userDoc['email'],
      imageUrl: userDoc['imageUrl'],
    );
  }
}
