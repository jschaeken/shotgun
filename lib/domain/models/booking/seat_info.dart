import 'package:flutter/rendering.dart';
import 'package:shotgun/domain/models/auth/user.dart';

class SeatInfo {
  SeatInfo({
    required this.position,
    required this.available,
    required this.number,
    this.user,
  });

  Alignment position;
  bool available;
  int number;
  User? user;
}
