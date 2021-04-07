import 'package:flutter/material.dart';

class User with ChangeNotifier {
  String _nickname;
  int _id;

  String get nickname => _nickname;
  int get id => _id;

  set setNickname(String value) {
    _nickname = value;
    notifyListeners();
  }

  set setId(int new_id) {
    _id = new_id;
    notifyListeners();
  }
}
