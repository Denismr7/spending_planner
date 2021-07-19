import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  List<UserSettings> get userSettings =>
      _user?.settings == null ? [] : _user!.settings;

  void setUser(
      String id, String email, String name, List<UserSettings> settings) {
    _user = User(id: id, login: email, name: name, settings: settings);
  }

  dynamic getSettingValue(Setting key) {
    return _user?.settings.firstWhere((setting) => setting.key == key).value ??
        null;
  }

  double getSettingValueAsDouble(Setting key) {
    return double.parse(getSettingValue(key));
  }

  Future<void> updateSettingValue(Map<Setting, dynamic> newSettings) async {
    try {
      var user = auth.FirebaseAuth.instance;
      if (user.currentUser == null) {
        print('SPLAN.UserProvider(): current user null');
        return;
      }

      Map<String, Object> mappedSettings = {};
      // Remove empty values
      newSettings.keys.forEach((key) {
        var value = newSettings[key];
        if (value == null) {
          newSettings.remove(key);
        }

        mappedSettings[key.valueAsString().toLowerCase()] = value;
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.currentUser!.uid)
          .update(mappedSettings);

      newSettings.keys.forEach((key) {
        var settingIndex =
            _user?.settings.indexWhere((element) => element.key == key);
        if (settingIndex == null || settingIndex.isNaN) {
          print('SPLAN.UserProvider(): Setting $key not found');
          return;
        }

        print('Updated setting with key $key, value ${newSettings[key]}');
        var newValue = newSettings[key];
        var updatedSetting = UserSettings(key, newValue);
        _user?.settings[settingIndex] = updatedSetting;
      });
      notifyListeners();
    } catch (e) {
      print('SPLAN.UserProvider() Error $e');
      throw e;
    }
  }
}
