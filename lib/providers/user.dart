import 'package:flutter/material.dart';

import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(
      String id, String email, String name, List<UserSettings> settings) {
    _user = User(id: id, login: email, name: name, settings: settings);
  }

  dynamic getSettingValue(Setting key) {
    return _user?.settings.firstWhere((setting) => setting.key == key).value ??
        null;
  }
}
