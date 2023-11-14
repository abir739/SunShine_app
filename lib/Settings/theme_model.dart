import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  primaryColor: Colors.blue,
  hintColor: Colors.orange,
  // Define other theme properties as needed.
);

final darkTheme = ThemeData(
  primaryColor: Colors.indigo,
  hintColor: Colors.amber,
  // Define other theme properties as needed.
);


class ThemeModel extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
