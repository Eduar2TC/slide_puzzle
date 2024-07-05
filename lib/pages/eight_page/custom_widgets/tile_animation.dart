import 'package:flutter/material.dart';

class TileAnimation {
  late AnimationController bounceController;
  late Animation<Offset> bounceAnimation;

  TileAnimation(TickerProvider vsync) {
    bounceController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 200),
    );

    bounceAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: bounceController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void animate(DismissDirection direction) {
    Offset end;
    switch (direction) {
      case DismissDirection.startToEnd:
        end = const Offset(-0.03, 0);
        break;
      case DismissDirection.endToStart:
        end = const Offset(0.03, 0);
        break;
      case DismissDirection.up:
        end = const Offset(0, 0.03);
        break;
      case DismissDirection.down:
        end = const Offset(0, -0.03);
        break;
      default:
        end = Offset.zero;
    }

    bounceAnimation = Tween(begin: Offset.zero, end: end).animate(
      CurvedAnimation(
        parent: bounceController,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );
    bounceController.forward().then((_) => bounceController.reverse(from: 1.0));
  }

  void dispose() {
    bounceController.dispose();
  }
}
