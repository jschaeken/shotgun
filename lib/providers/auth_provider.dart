import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class Auth with ChangeNotifier {
  final FirebaseAuth _firebaseauth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  User? _user;

  User? get user => _user;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Auth() {
    _firebaseauth.authStateChanges().listen(_onAuthStateChanged);
    _firebaseauth.userChanges().listen(_onAuthStateChanged);
  }

  Future<void> signIn(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _firebaseauth.signInWithEmailAndPassword(
          email: email, password: password);
      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void signUp(String email, String password, String name) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _firebaseauth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        await _firebaseauth.currentUser!.updateDisplayName(name);
        await _firestore.collection('users').doc(value.user!.uid).set({
          'email': email,
          'name': name,
        });
      });

      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _firebaseauth.signOut();
  }

  void _onAuthStateChanged(User? user) async {
    if (user == _user) {
      return;
    }
    _user = user;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> editUserName(String name) async {
    await _user!.updateDisplayName(name);
    return;
  }

  Future<void> editUserPhoto(XFile file) async {
    try {
      final ref = _storage.ref().child('users/').child(_user!.uid);
      final uploadTask = ref.putFile(File(file.path));
      final snapshot = uploadTask.snapshot;

      final url = await snapshot.ref.getDownloadURL();
      await _user!.updatePhotoURL(url);
      await _firestore.collection('users').doc(_user!.uid).update({
        'imageUrl': url,
      });
    } on FirebaseException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      await Future.delayed(const Duration(seconds: 5));
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      await Future.delayed(const Duration(seconds: 5));
      _errorMessage = null;
    }
  }
}
