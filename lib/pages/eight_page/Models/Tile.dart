import 'package:flutter/material.dart';

class Tile {
  String value;
  String? image;
  DismissDirection direction;
  AnimationController? animationController;

  Tile({
    required this.value,
    this.direction = DismissDirection.none,
    this.animationController,
    this.image,
  });
}
