import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shotgun_v2/models/rider.dart';

class Driver extends Rider {
  int? availableSeats;
  Driver({
    required this.availableSeats,
    required super.userId,
    required super.name,
    required super.email,
    required super.imageUrl,
  });

  static Future<Driver?> fromUserId(
      {required String userId, required int availableSeats}) async {
    // Doc only contains the available seats and the userId of the driver
    // We need to fetch the user details from the users collection

    // Fetch the user details from the users collection
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (!userDoc.exists) {
      return null;
    }

    return Driver(
      availableSeats: availableSeats,
      userId: userId,
      name: userDoc['name'],
      email: userDoc['email'],
      imageUrl: userDoc['imageUrl'],
    );
  }
}
