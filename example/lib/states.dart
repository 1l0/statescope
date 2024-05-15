import 'package:flutter/material.dart';

class AuthState extends ChangeNotifier {
  var _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  set isLoggedIn(bool b) {
    _isLoggedIn = b;
    notifyListeners();
  }

  void login() {
    isLoggedIn = true;
  }

  void logout() {
    isLoggedIn = false;
  }
}

const _colors = [
  Colors.blue,
  Colors.red,
  Colors.green,
  Colors.purple,
  Colors.yellow,
];

class AppState extends ChangeNotifier {
  int _count = 0;
  int get count => _count;
  void incrementCounter() {
    _count++;
    _backgroundColor = _colors[count % 5];
    notifyListeners();
  }

  Color _backgroundColor = Colors.blue;
  Color get backgroundColor => _backgroundColor;

  Color get textColor =>
      _backgroundColor == Colors.yellow ? Colors.black87 : Colors.white;
}
