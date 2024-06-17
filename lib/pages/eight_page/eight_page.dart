import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:slide_puzzle/pages/eight_page/custom_widgets/Tile.dart';

class EightPage extends StatefulWidget {
  const EightPage({super.key});

  @override
  EightPageState createState() => EightPageState();
}

class EightPageState extends State<EightPage> {
  late List<List<Tile>> _tiles;
  @override
  void initState() {
    _tiles = [
      [Tile(value: '1'), Tile(value: '2'), Tile(value: '3')],
      [Tile(value: '4'), Tile(value: '5'), Tile(value: '6')],
      [Tile(value: '7'), Tile(value: '8'), Tile(value: '')],
    ];
    _tiles.shuffle();
    updateTiles();
    super.initState();
  }

  void clearDirections() {
    for (int i = 0; i < _tiles.length; i++) {
      for (int j = 0; j < _tiles[i].length; j++) {
        _tiles[i][j].direction = DismissDirection.none;
      }
    }
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
  }

  Future<bool> confirmDismiss(DismissDirection direction, x, y, item) async {
    switch (direction) {
      case DismissDirection.startToEnd:
        setState(() {
          String tmp = item;
          _tiles[x][y].value = _tiles[x][y + 1].value;
          _tiles[x][y + 1].value = tmp;
        });
        return Future.value(true);
      case DismissDirection.endToStart:
        setState(() {
          String tmp = item;
          _tiles[x][y].value = _tiles[x][y - 1].value;
          _tiles[x][y - 1].value = tmp;
        });
        return Future.value(true);
      case DismissDirection.up:
        setState(() {
          String tmp = item;
          _tiles[x][y].value = _tiles[x - 1][y].value;
          _tiles[x - 1][y].value = tmp;
        });
        return Future.value(true);
      case DismissDirection.down:
        setState(() {
          String tmp = item;
          _tiles[x][y].value = _tiles[x + 1][y].value;
          _tiles[x + 1][y].value = tmp;
        });
        return Future.value(true);
      default:
        return Future.value(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Container(
          width: width / 1.5,
          height: width / 1.5,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: _tiles.length * _tiles[0].length,
            itemBuilder: (context, index) {
              int tilesLength = _tiles.length;
              int x, y = 0;
              x = (index / tilesLength).floor();
              y = (index % tilesLength);
              return GestureDetector(
                onTap: () => log('${_tiles[x][y].direction}'),
                child: Dismissible(
                  key: Key(_tiles[x][y].value),
                  direction: _tiles[x][y].direction,
                  movementDuration: const Duration(milliseconds: 200),
                  dismissThresholds: const {
                    DismissDirection.startToEnd: 0.4,
                    DismissDirection.endToStart: 0.4,
                    DismissDirection.up: 0.4,
                    DismissDirection.down: 0.4,
                  },
                  onDismissed: (direction) {
                    setState(() {
                      log('onDismissed');
                    });
                  },
                  confirmDismiss: (direction) async =>
                      confirmDismiss(direction, x, y, _tiles[x][y].value)
                          .then((value) {
                    setState(() {
                      clearDirections();
                      updateTiles();
                    });
                  }),
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _tiles[x][y].value != ''
                            ? Colors.blue
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          _tiles[x][y].value,
                          style: const TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
