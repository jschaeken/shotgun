import 'package:flutter/material.dart';

abstract class Activity {
  String name;
  dynamic type;
  IconData icon;
  Color color;
  Alignment position;

  Activity({
    required this.name,
    required this.type,
    required this.icon,
    required this.color,
    required this.position,
  });
}
