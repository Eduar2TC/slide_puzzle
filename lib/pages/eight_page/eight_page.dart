import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slide_puzzle/pages/eight_page/Models/tile.dart';
import 'package:slide_puzzle/pages/eight_page/Models/game_state.dart';
import 'package:slide_puzzle/pages/eight_page/custom_widgets/bottom_widgets.dart';
import 'package:slide_puzzle/pages/eight_page/custom_widgets/custom_dialog.dart';
import 'package:slide_puzzle/pages/eight_page/custom_widgets/tile_animation.dart';
import 'package:slide_puzzle/pages/eight_page/utils/handle_timer.dart';

class EightPage extends StatefulWidget {
  const EightPage({super.key});

  @override
  EightPageState createState() => EightPageState();
}

class EightPageState extends State<EightPage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late List<List<Tile>> _tiles;
  late Map<Tile, TileAnimation> _tileAnimations;

  HandleTimer handleTimer = HandleTimer();

  int userMovementCounter = 0;
  //icon play icon
  IconData iconPlay = Icons.play_arrow;
  IconData iconMute = Icons.volume_off;

  late AnimationController _gridAnimationController;

  late GameState _gameState;
  late HandleTimer _handleTimer;
  @override
  void initState() {
    //init state of games
    _gameState = Provider.of<GameState>(context, listen: false);
    _handleTimer = Provider.of<HandleTimer>(context, listen: false);
    _tiles = _gameState.getTiles;
    for (var row in _tiles) {
      for (var tile in row) {
        tile.animationController = AnimationController(
          duration: const Duration(milliseconds: 200),
          vsync: this,
        );
      }
    }
    //Solve conflict in init state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _gameState.shuffleTiles();
      _gameState.updateTiles();
      _handleTimer.setupTimer(() {
        setState(() {});
      });
      _handleTimer.startWatch();
    });

    WidgetsBinding.instance.addObserver(this);

    _tileAnimations = {};
    for (var row in _tiles) {
      for (var tile in row) {
        _tileAnimations[tile] = TileAnimation(this);
      }
    }
    //grid animation
    _gridAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _gridAnimationController.forward();

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state = $state');
    if (state == AppLifecycleState.paused) {
      _handleTimer.stopWatch();
      _showPauseDialog(context);
    } else if (state == AppLifecycleState.resumed) {}
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    for (var animation in _tileAnimations.values) {
      animation.dispose();
    }
    for (var row in _tiles) {
      for (var tile in row) {
        tile.animationController?.dispose();
      }
    }
    _gridAnimationController.dispose();
    _handleTimer.dispose();
    super.dispose();
  }

  Future<bool> confirmDismiss(
      DismissDirection direction, int x, int y, String item) async {
    //await _tiles[x][y].animationController?.forward(from: 0.0);
    setState(() {
      switch (direction) {
        case DismissDirection.startToEnd:
          String tmp = _tiles[x][y].value;
          _tiles[x][y].value = _tiles[x][y + 1].value;
          _tiles[x][y + 1].value = tmp;
          _tileAnimations[_tiles[x][y + 1]]?.animate(direction);
          break;
        case DismissDirection.endToStart:
          String tmp = _tiles[x][y].value;
          _tiles[x][y].value = _tiles[x][y - 1].value;
          _tiles[x][y - 1].value = tmp;
          _tileAnimations[_tiles[x][y - 1]]?.animate(direction);
          break;
        case DismissDirection.up:
          String tmp = _tiles[x][y].value;
          _tiles[x][y].value = _tiles[x - 1][y].value;
          _tiles[x - 1][y].value = tmp;
          _tileAnimations[_tiles[x - 1][y]]?.animate(direction);

          break;
        case DismissDirection.down:
          String tmp = _tiles[x][y].value;
          _tiles[x][y].value = _tiles[x + 1][y].value;
          _tiles[x + 1][y].value = tmp;
          _tileAnimations[_tiles[x + 1][y]]?.animate(direction);
          break;
        default:
          break;
      }

      _gameState.clearDirections();
      _gameState.updateTiles();
      _gameState.incrementUserMovementCounter();
    });

    return Future.value(false);
  }

  void _showPauseDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          title: 'Play',
          iconData: Icons.play_arrow,
          onPressed: () {
            _handleTimer.startWatch();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.only(top: 20),
          width: width,
          height: height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffffe259), Color(0xffffa751)],
              stops: [0, 1],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.spaceAround, //TODO: fix responsive
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.timer,
                          size: 30,
                          color: Color(0xFF264653),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          _handleTimer.returnTime(),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Color(0XFF264653),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.swipe,
                          size: 30,
                          color: Color(0xFF264653),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          _gameState.userMovementCounter.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Color(0XFF264653),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        const Icon(
                          Icons.emoji_events,
                          size: 30,
                          color: Color(0xFF264653),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        const Text(
                          '150',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0XFF264653),
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(5),
                width: width * 0.8,
                height: width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                  ),
                  itemCount: _tiles.length * _tiles[0].length,
                  itemBuilder: (context, index) {
                    int tilesLength = _tiles.length;
                    int x, y = 0;
                    x = (index / tilesLength).floor();
                    y = (index % tilesLength);
                    Tile currentTile = _tiles[x][y];
                    return itemGridBuilder(index, x, y, width, currentTile);
                  },
                ),
              ),
              const BottomWidgets(),
            ],
          ),
        ),
      ),
    );
  }

  AnimatedBuilder itemGridBuilder(
      int index, int x, int y, double width, Tile currentTile) {
    return AnimatedBuilder(
      animation: _gridAnimationController,
      builder: (context, child) {
        final delay = index *
            100; // Ajusta este valor para cambiar el retraso entre elementos
        final start = delay / 1000;
        var end = start +
            0.5; // Ajusta este valor para cambiar la duración de la animación de cada elemento
        end = end.clamp(0.0, 1.0);
        return FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(
              parent: _gridAnimationController,
              curve: Interval(start, end, curve: Curves.easeOut),
            ),
          ),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0, end: 1).animate(
              CurvedAnimation(
                parent: _gridAnimationController,
                curve: Interval(start, end, curve: Curves.easeOut),
              ),
            ),
            child: child,
          ),
          /*SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.5),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: _gridAnimationController,
                              curve:
                                  Interval(start, end, curve: Curves.easeOut),
                            ),
                          ),
                          child: child,
                        ),*/
        );
      },
      child: GestureDetector(
        onTap: () async {
          log('${_tiles[x][y].direction}');
          /*TODO: ONTAP GAME MODE */

          if (_tiles[x][y].direction != DismissDirection.none) {
            await _tiles[x][y]
                .animationController
                ?.forward(from: 0.0)
                .then((_) {
              confirmDismiss(_tiles[x][y].direction, x, y, _tiles[x][y].value);
              setState(() {
                _gameState.clearDirections();
                _gameState.updateTiles();
              });
            });
          }
        },
        child: AnimatedBuilder(
          animation:
              _tiles[x][y].animationController ?? kAlwaysCompleteAnimation,
          builder: (context, child) {
            double offset =
                (_tiles[x][y].animationController?.value ?? 0) * width * 0.268;
            Offset translation;
            switch (_tiles[x][y].direction) {
              case DismissDirection.startToEnd:
                translation = Offset(offset, 0);
                break;
              case DismissDirection.endToStart:
                translation = Offset(-offset, 0);
                break;
              case DismissDirection.up:
                translation = Offset(0, -offset);
                break;
              case DismissDirection.down:
                translation = Offset(0, offset);
                break;
              default:
                translation = Offset.zero;
            }
            return Transform.translate(
              offset: translation,
              child: child,
            );
          },
          child: Dismissible(
            key: Key(_tiles[x][y].value),
            direction: _tiles[x][y].direction,
            behavior: HitTestBehavior.translucent,
            movementDuration: const Duration(milliseconds: 200),
            dismissThresholds: const {
              DismissDirection.startToEnd: 0.0,
              DismissDirection.endToStart: 0.0,
              DismissDirection.up: 0.0,
              DismissDirection.down: 0.0,
            },
            onDismissed: (direction) {
              setState(() {
                log('onDismissed');
              });
            },
            confirmDismiss: (direction) async {
              return confirmDismiss(direction, x, y, _tiles[x][y].value);
            },
            onUpdate: (details) {
              log('onUpdate');
            },
            child: AnimatedBuilder(
              animation: _tileAnimations[currentTile]!.bounceAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: _tileAnimations[currentTile]!.bounceAnimation.value,
                  child: child,
                );
              },
              child: AnimatedBuilder(
                animation: _tileAnimations[currentTile]!.bounceController,
                builder: (context, child) {
                  return SlideTransition(
                    key: UniqueKey(),
                    position: _tileAnimations[currentTile]!.bounceAnimation,
                    child: child,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _tiles[x][y].value != ''
                          ? const Color(0xFF7678ed)
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
            ),
          ),
        ),
      ),
    );
  }
}
