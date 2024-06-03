import 'package:shotgun_v2/models/rider.dart';

class Friend extends Rider {
  Friend({
    required super.userId,
    required super.name,
    required super.email,
    required super.imageUrl,
  });

  factory Friend.fromMap(Map<String, dynamic> map, String userId) {
    return Friend(
      userId: userId,
      name: map.containsKey('name') ? map['name'] : null,
      email: map.containsKey('email') ? map['email'] : null,
      imageUrl: map.containsKey('imageUrl') ? map['imageUrl'] : null,
    );
  }
}

class PendingFriend extends Rider {
  PendingFriend({
    required super.userId,
    required super.name,
    required super.email,
    required super.imageUrl,
  });

  factory PendingFriend.fromMap(Map<String, dynamic> map, String userId) {
    return PendingFriend(
      userId: userId,
      name: map.containsKey('name') ? map['name'] : null,
      email: map.containsKey('email') ? map['email'] : null,
      imageUrl: map.containsKey('imageUrl') ? map['imageUrl'] : null,
    );
  }
}
