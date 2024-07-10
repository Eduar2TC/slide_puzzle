import 'dart:async';

import 'package:flutter/material.dart';

class HandleTimer with ChangeNotifier {
  Timer? _timer;
  Stopwatch? _stopwatch;
  HandleTimer() {
    _stopwatch = Stopwatch();
  }

  void setupTimer(void Function() callback) {
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      callback();
    });
  }

  void stopWatch() {
    if (_stopwatch!.isRunning) {
      _stopwatch!.stop();
    }
  }

  void startWatch() {
    stopWatch();
    _stopwatch!.start();
    notifyListeners();
  }

  void resetWatch() {
    _stopwatch!.reset();
    notifyListeners();
  }

  void dispose() {
    _timer!.cancel();
  }

  String returnTime() {
    final int milliseconds = _stopwatch!.elapsedMilliseconds;
    final int hundreds = (milliseconds / 10).truncate();
    final int seconds = (hundreds / 100).truncate();
    final int minutes = (seconds / 60).truncate();
    String twoDigitMinutes = minutes.remainder(60).toString().padLeft(2, '0');
    String twoDigitSeconds = seconds.remainder(60).toString().padLeft(2, '0');
    String twoDigitHundreds =
        hundreds.remainder(100).toString().padLeft(2, '0');

    return '$twoDigitMinutes:$twoDigitSeconds:$twoDigitHundreds';
  }
}
