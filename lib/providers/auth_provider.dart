import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth with ChangeNotifier {
  final FirebaseAuth _firebaseauth = FirebaseAuth.instance;
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

  Future<void> signOut() async {
    await _firebaseauth.signOut();
  }

  void _onAuthStateChanged(User? user) {
    if (user == _user) {
      return;
    }
    _user = user;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  void signUp(String email, String password, String name) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _firebaseauth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _firebaseauth.currentUser!.updateDisplayName(name);
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

  Future<void> editUserName(String name) async {
    await _user!.updateDisplayName(name);
    return;
  }
}
