import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shotgun_v2/providers/auth_provider.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> getQrCode(String rideId) async {
    final uid = _auth.currentUser!.uid;
    final doc = await _firestore
        .collection('users')
        .doc(uid)
        .collection('rides')
        .doc(rideId)
        .get();
    if (doc.exists) {
      return doc.data()!['qrCodeUrl'] as String?;
    }
    return null;
  }
}
