import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shotgun_v2/models/friend.dart';

class FriendProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<PendingFriend> _pendingFiendsIncoming = [];
  List<PendingFriend> get friendRequests => _pendingFiendsIncoming;

  final List<Friend> _friends = [];
  List<Friend> get friends => _friends;

  final List<Friend> _searchResults = [];
  List<Friend> get searchResults => _searchResults;
  void clearSearchResults() {
    _searchResults.clear();
    notifyListeners();
  }

  Future<void> getFriends() async {
    final user = _auth.currentUser;
    if (user == null) {
      return;
    }

    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    if (!userDoc.exists || userDoc.data() == null) {
      return;
    }
    _friends.clear();
    debugPrint('userDoc: ${userDoc.data()}');
    List<dynamic>? friendIds = userDoc.data()!['friendIds'];
    debugPrint('friendIds: $friendIds');
    friendIds ??= [];
    for (final friendId in friendIds) {
      final friend = await _firestore.collection('users').doc(friendId).get();
      if (!friend.exists || friend.data() == null) {
        continue;
      }
      _friends.add(Friend.fromMap(friend.data()!, friend.id));
    }
    notifyListeners();
  }

  Future<void> streamFriendRequests() async {
    final user = _auth.currentUser;
    if (user == null) {
      return;
    }

    final userDoc = _firestore.collection('users').doc(user.uid).snapshots();
    userDoc.listen((event) {
      final data = event.data();
      if (data == null) {
        return;
      }
      final incoming = data['incoming'] as List<dynamic>;
      if (incoming.length == _pendingFiendsIncoming.length) {
        return;
      }
      // Add new incoming friend requests
      for (final friendId in incoming) {
        if (_pendingFiendsIncoming
            .any((element) => element.userId == friendId)) {
          continue;
        }
        _firestore.collection('users').doc(friendId).get().then((friend) {
          if (!friend.exists || friend.data() == null) {
            return;
          }
          _pendingFiendsIncoming
              .add(PendingFriend.fromMap(friend.data()!, friend.id));
          notifyListeners();
        });
      }
      // Remove friend requests that are not in the incoming list
      _pendingFiendsIncoming
          .removeWhere((element) => !incoming.contains(element.userId));

      notifyListeners();
    });
  }

  // Search for a friend by name
  Future<void> searchForFriend(String name) async {
    final user = _auth.currentUser;
    if (user == null) {
      return;
    }

    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    if (!userDoc.exists || userDoc.data() == null) {
      return;
    }

    final query = await _firestore
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: name)
        .where('name', isLessThan: '${name}z')
        .get();
    _searchResults.clear();
    for (final friend in query.docs) {
      if (friend.id == user.uid) {
        continue;
      }
      _searchResults.add(Friend.fromMap(friend.data(), friend.id));
    }
    debugPrint('searchResults: $_searchResults');
    notifyListeners();
  }

  Future<void> addFriendByEmail(String email) async {
    final user = _auth.currentUser;
    if (user == null) {
      return;
    }

    final query = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    if (query.docs.isEmpty) {
      return;
    }

    final friend = query.docs.first;
    final friendId = friend.id;
    _firestore.collection('users').doc(user.uid).update({
      'outgoing': FieldValue.arrayUnion([friendId])
    });
  }

  Future<void> addFriendByUserId(String friendId) async {
    _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      'outgoing': FieldValue.arrayUnion([friendId])
    });
  }

  Future<void> removeFriend(String friendId) async {}

  Future<void> acceptFriendRequest(String friendId) async {
    // TODO: Implement this server-side
  }

  Future<void> declineFriendRequest(String friendId) async {
    _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      'incoming': FieldValue.arrayRemove([friendId])
    });
  }
}
