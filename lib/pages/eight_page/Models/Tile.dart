import 'package:flutter/material.dart';

class Tile {
  String value;
  DismissDirection direction;
  Tile({required this.value, this.direction = DismissDirection.none});
}
