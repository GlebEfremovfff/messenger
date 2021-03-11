import 'package:flutter/material.dart';

class User with ChangeNotifier {
  String _nickname = "Nickname";

  String get nickname => _nickname;

  set setNickname(String value) {
    _nickname = value;
    notifyListeners();
  }
}
