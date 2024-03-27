import 'package:flutter/widgets.dart';

class SigninProvider with ChangeNotifier {
  int _selectedScreen = 0;

  int get selectedScreen {
    return _selectedScreen;
  }

  setSelectedScreen(int value) {
    _selectedScreen = value;
    notifyListeners();
  }

  getUserDetails() {}
}
