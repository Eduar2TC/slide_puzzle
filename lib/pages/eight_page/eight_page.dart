import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:slide_puzzle/pages/eight_page/Models/Tile.dart';
import 'package:slide_puzzle/pages/eight_page/utils/handle_timer.dart';
import 'package:slide_puzzle/pages/general_custom_widgets/button_scale_animation_widget.dart';
import 'package:slide_puzzle/pages/general_custom_widgets/custom_button.dart';
import 'package:slide_puzzle/pages/general_custom_widgets/scale_animation_widget.dart';

class EightPage extends StatefulWidget {
  const EightPage({super.key});

  @override
  EightPageState createState() => EightPageState();
}

class EightPageState extends State<EightPage> with WidgetsBindingObserver {
  late List<List<Tile>> _tiles;

  HandleTimer handleTimer = HandleTimer();

  int userMovementCounter = 0;
  //icon play icon
  IconData iconPlay = Icons.play_arrow;
  IconData iconMute = Icons.volume_off;

  @override
  void initState() {
    _tiles = [
      [Tile(value: '1'), Tile(value: '2'), Tile(value: '3')],
      [Tile(value: '4'), Tile(value: '5'), Tile(value: '6')],
      [Tile(value: '7'), Tile(value: '8'), Tile(value: '')],
    ];
    _tiles.shuffle();
    updateTiles();

    handleTimer.setupTimer(() {
      setState(() {});
    });
    handleTimer.startWatch();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state = $state');
    if (state == AppLifecycleState.paused) {
      handleTimer.stopWatch();
      _showPauseDialog(context);
    } else if (state == AppLifecycleState.resumed) {}
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

  void _showPauseDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            width: 300,
            height: 200,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFf9a825),
                  Color(0xFFf07b3f),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  child: Text(
                    'Pause',
                  ),
                ),
                Center(
                  child: ButtonScaleAnimationWidget(
                    child: CustomButton(
                      width: 100,
                      height: 100,
                      icon: Icons.play_arrow,
                      iconColor: Colors.white,
                      bgColor: const Color(0xFFf9a825),
                      size: 50,
                      onPressed: () {
                        iconPlay = Icons.play_arrow;
                        handleTimer.startWatch();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
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
                          handleTimer.returnTime(),
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
                          userMovementCounter.toString(),
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
                  ),
                  itemCount: _tiles.length * _tiles[0].length,
                  itemBuilder: (context, index) {
                    int tilesLength = _tiles.length;
                    int x, y = 0;
                    x = (index / tilesLength).floor();
                    y = (index % tilesLength);
                    return GestureDetector(
                      onTap: () {
                        log('${_tiles[x][y].direction}');
                        /*TODO: ONTAP GAME MODE */
                        /*
                        confirmDismiss(
                            _tiles[x][y].direction, x, y, _tiles[x][y].value);
                             setState(() {
                          clearDirections();
                          updateTiles();
                        });
                            */
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
                        confirmDismiss: (direction) async =>
                            confirmDismiss(direction, x, y, _tiles[x][y].value)
                                .then((value) {
                          setState(() {
                            clearDirections();
                            updateTiles();
                            userMovementCounter++;
                          });
                        }),
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
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ScaleAnimationWidget(
                    child: CustomButton(
                      key: const Key('shuffle'),
                      width: width * 0.1,
                      height: width * 0.1,
                      icon: Icons.refresh,
                      iconColor: Colors.white,
                      bgColor: const Color(0xFFf9a825),
                      size: width * 0.1,
                      onPressed: () {
                        setState(() {
                          handleTimer.resetWatch();
                          _tiles.shuffle(); //sufle tiles vertically
                          _tiles.forEach((element) {
                            element.shuffle(); //sufle tiles horizontally
                          });
                          updateTiles();
                        });
                      },
                    ),
                  ),
                  //play button
                  ScaleAnimationWidget(
                    child: CustomButton(
                      key: const Key('play'),
                      width: width * 0.1,
                      height: width * 0.1,
                      icon: iconPlay,
                      iconColor: Colors.white,
                      bgColor: const Color(0xFFf9a825),
                      size: width * 0.1,
                      onPressed: () {
                        _showPauseDialog(context);
                        iconPlay == Icons.play_arrow
                            ? {
                                iconPlay = Icons.pause,
                                handleTimer.stopWatch(),
                              }
                            : null;
                      },
                    ),
                  ),
                  //mute button
                  ScaleAnimationWidget(
                    child: CustomButton(
                      key: const Key('mute'),
                      width: width * 0.1,
                      height: width * 0.1,
                      icon: iconMute,
                      iconColor: Colors.white,
                      bgColor: const Color(0xFFf9a825),
                      size: width * 0.1,
                      onPressed: () {
                        iconMute == Icons.volume_off
                            ? iconMute = Icons.volume_up
                            : iconMute = Icons.volume_off;
                        log('mute');
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
