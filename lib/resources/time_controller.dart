import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:projectmercury/resources/auth_methods.dart';
import 'package:projectmercury/resources/locator.dart';
import 'package:projectmercury/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerController with ChangeNotifier {
  late SharedPreferences prefs;
  final String uid = locator.get<AuthMethods>().currentUser.uid;

  int _totalTime = 0;
  Timer? _timer;

  String get totalTime => formatTime(Duration(seconds: _totalTime));

// start timer
  void start() async {
    // local storage on disk
    prefs = await SharedPreferences.getInstance();
    // load stored times
    _totalTime = getLocalTime('totalTime');
    // run every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _totalTime++;
      incrementLocalTime('totalTime');
      notifyListeners();
    });
  }

// get time stored on local disk
  int getLocalTime(String name) {
    return prefs.getInt(name + uid) ?? 0;
  }

// increment time stored on local disk
  void incrementLocalTime(String name) {
    prefs.setInt(name + uid, getLocalTime(name) + 1);
  }

// stop timer
  void cancel() {
    _timer?.cancel();
  }
}
