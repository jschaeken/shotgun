import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NavProvider with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    if (index == _currentIndex) return;

    _currentIndex = index;
    HapticFeedback.mediumImpact();
    notifyListeners();
  }
}
