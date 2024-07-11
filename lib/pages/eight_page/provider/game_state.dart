import 'package:flutter/material.dart';
import 'package:slide_puzzle/pages/eight_page/Models/tile.dart';

class GameState with ChangeNotifier {
  List<List<Tile>> _tiles = [];
  int _userMovementCounter = 0;
  late AnimationController _gridAnimationController;

  GameState() {
    _initializePuzzle();
  }

  void _initializePuzzle() {
    // Inicializa el puzzle aquí
    _tiles = [
      [Tile(value: '1'), Tile(value: '2'), Tile(value: '3')],
      [Tile(value: '4'), Tile(value: '5'), Tile(value: '6')],
      [Tile(value: '7'), Tile(value: '8'), Tile(value: '')],
    ];
    shuffleTiles();
    updateTiles();
  }

  void shuffleTiles() {
    _tiles.shuffle();
    for (var element in _tiles) {
      element.shuffle();
    }
    notifyListeners();
  }

  void updateTiles() {
    for (int i = 0; i < _tiles.length; i++) {
      for (int j = 0; j < _tiles[i].length; j++) {
        //M[0,0]
        if (_tiles[i][j].value == '' && (i == 0 && j == 0)) {
          _tiles[i][j + 1].direction = DismissDirection.endToStart;
          _tiles[i + 1][j].direction = DismissDirection.up;
        }
        //M[0,1]
        else if (_tiles[i][j].value == '' && (i == 0 && j == 1)) {
          _tiles[i][j - 1].direction = DismissDirection.startToEnd;
          _tiles[i + 1][j].direction = DismissDirection.up;
          _tiles[i][j + 1].direction = DismissDirection.endToStart;
        }
        //M[0,2]
        else if (_tiles[i][j].value == '' && (i == 0 && j == 2)) {
          _tiles[i][j - 1].direction = DismissDirection.startToEnd;
          _tiles[i + 1][j].direction = DismissDirection.up;
        }
        //M[1,0]
        else if (_tiles[i][j].value == '' && (i == 1 && j == 0)) {
          _tiles[i + 1][j].direction = DismissDirection.up;
          _tiles[i][j + 1].direction = DismissDirection.endToStart;
          _tiles[i - 1][j].direction = DismissDirection.down;
        }
        //M[1,1]
        else if (_tiles[i][j].value == '' && (i == 1 && j == 1)) {
          _tiles[i][j - 1].direction = DismissDirection.startToEnd;
          _tiles[i + 1][j].direction = DismissDirection.up;
          _tiles[i][j + 1].direction = DismissDirection.endToStart;
          _tiles[i - 1][j].direction = DismissDirection.down;
        }
        //M[1,2]
        else if (_tiles[i][j].value == '' && (i == 1 && j == 2)) {
          _tiles[i][j - 1].direction = DismissDirection.startToEnd;
          _tiles[i + 1][j].direction = DismissDirection.up;
          _tiles[i - 1][j].direction = DismissDirection.down;
        }
        //M[2,0]
        else if (_tiles[i][j].value == '' && (i == 2 && j == 0)) {
          _tiles[i][j + 1].direction = DismissDirection.endToStart;
          _tiles[i - 1][j].direction = DismissDirection.down;
        }
        //M[2,1]
        else if (_tiles[i][j].value == '' && (i == 2 && j == 1)) {
          _tiles[i][j - 1].direction = DismissDirection.startToEnd;
          _tiles[i - 1][j].direction = DismissDirection.down;
          _tiles[i][j + 1].direction = DismissDirection.endToStart;
        }
        //M[2,2]
        else if (_tiles[i][j].value == '' && (i == 2 && j == 2)) {
          _tiles[i][j - 1].direction = DismissDirection.startToEnd;
          _tiles[i - 1][j].direction = DismissDirection.down;
        }
      }
    }
    for (var row in _tiles) {
      for (var tile in row) {
        tile.animationController?.reset();
      }
    }
    notifyListeners();
  }

//TODO: Fix this
  void swapDirections(DismissDirection direction, int x, int y) {
    switch (direction) {
      case DismissDirection.startToEnd:
        String tmp = _tiles[x][y].value;
        _tiles[x][y].value = _tiles[x][y + 1].value;
        _tiles[x][y + 1].value = tmp;

        break;
      case DismissDirection.endToStart:
        String tmp = _tiles[x][y].value;
        _tiles[x][y].value = _tiles[x][y - 1].value;
        _tiles[x][y - 1].value = tmp;

        break;
      case DismissDirection.up:
        String tmp = _tiles[x][y].value;
        _tiles[x][y].value = _tiles[x - 1][y].value;
        _tiles[x - 1][y].value = tmp;

        break;
      case DismissDirection.down:
        String tmp = _tiles[x][y].value;
        _tiles[x][y].value = _tiles[x + 1][y].value;
        _tiles[x + 1][y].value = tmp;

        break;
      default:
        break;
    }
  }

  void clearDirections() {
    for (int i = 0; i < _tiles.length; i++) {
      for (int j = 0; j < _tiles[i].length; j++) {
        _tiles[i][j].direction = DismissDirection.none;
      }
    }
    notifyListeners();
  }

  List<List<Tile>> get getTiles => _tiles;

  int get userMovementCounter => _userMovementCounter;

  void incrementUserMovementCounter() {
    _userMovementCounter++;
    notifyListeners();
  }

  set resetIncrementUserMovementCounter(int value) {
    _userMovementCounter = value;
  }

  set tiles(List<List<Tile>> value) {
    _tiles = value;
    notifyListeners();
  }

  //animations
  void initController(TickerProvider vsync) {
    _gridAnimationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1000),
    );
  }

  AnimationController get controller => _gridAnimationController;
  void startAnimation() {
    _gridAnimationController.forward();
    notifyListeners();
  }

  void resetAnimation() {
    _gridAnimationController.reset();
    notifyListeners();
  }

  void disposeController() {
    _gridAnimationController.dispose();
  }
}
