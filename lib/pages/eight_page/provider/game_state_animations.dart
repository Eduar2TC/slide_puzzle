import 'package:flutter/material.dart';

class GameStateGridAnimation with ChangeNotifier {
  late AnimationController _gridAnimationController;
  AnimationController get gridAnimationController => _gridAnimationController;

  void initializeAnimations(TickerProvider vsync) {
    _gridAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: vsync,
    );
  }

  void startGridAnimation() {
    _gridAnimationController.forward();
    notifyListeners();
  }

  void resetGridAnimation() {
    _gridAnimationController.reset();
    notifyListeners();
  }

  void disposeAnimations() {
    _gridAnimationController.dispose();
  }
}
