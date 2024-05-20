import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shotgun_v2/providers/auth_provider.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Gets the qr code image for a ride
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

  /// Uploads a profile image to Firebase Storage, returns the download URL
  Future<String?> uploadProfileImage(XFile file) async {
    try {
      final uid = _auth.currentUser?.uid;
      final ref = FirebaseStorage.instance
          .ref()
          .child('users/')
          .child(uid ?? 'unknown users/');
      final uploadTask = ref.putFile(File(file.path));
      final snapshot = uploadTask.snapshot;
      log('Uploading profile image: $snapshot');
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      log('Error uploading profile image: $e');
      return null;
    }
  }
}
