import 'dart:developer';

import 'package:flutter/material.dart';

enum Direction { up, down, left, right }

class AnimatedGridItem {
  late AnimationController controller;
  late Animation<Offset> animation;
  Direction direction;

  AnimatedGridItem(
      {required TickerProvider vsync, this.direction = Direction.right}) {
    controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: vsync,
    );
    _updateAnimation();
  }

  void _updateAnimation() {
    animation = Tween<Offset>(
      begin: Offset.zero,
      end: _getOffsetByDirection(direction),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  void changeDirection(Direction newDirection) {
    if (direction != newDirection) {
      direction = newDirection;
      _updateAnimation();
      log('Direction changeddd to $direction');
    }
  }

  static Offset _getOffsetByDirection(Direction direction) {
    switch (direction) {
      case Direction.up:
        return const Offset(0.0, -1.0);
      case Direction.down:
        return const Offset(0.0, 1.0);
      case Direction.left:
        return const Offset(-1.0, 0.0);
      case Direction.right:
        return const Offset(1.0, 0.0);
      default:
        return const Offset(1.0, 0.0); // Default to right if not specified
    }
  }

  void forward() {
    if (controller.status == AnimationStatus.completed) {
      controller.reset();
    }
    controller.forward();
  }
}
