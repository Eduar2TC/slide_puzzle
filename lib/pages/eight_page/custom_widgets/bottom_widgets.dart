import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slide_puzzle/pages/eight_page/Models/game_state.dart';
import 'package:slide_puzzle/pages/eight_page/custom_widgets/custom_dialog.dart';
import 'package:slide_puzzle/pages/eight_page/utils/handle_timer.dart';
import 'package:slide_puzzle/pages/general_custom_widgets/custom_button.dart';
import 'package:slide_puzzle/pages/general_custom_widgets/scale_animation_widget.dart';

class BottomWidgets extends StatelessWidget {
  const BottomWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    IconData iconMute = Icons.volume_up;

    return Consumer2<HandleTimer, GameState>(
        builder: (context, handleTimer, gameState, child) {
      return Row(
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
                //spend user press to shuffle tiles
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDialog(
                      title: 'Restart',
                      iconData: Icons.refresh,
                      onPressed: () {
                        handleTimer.stopWatch();
                        handleTimer.resetWatch();
                        handleTimer.startWatch();
                        gameState.shuffleTiles();
                        gameState.updateTiles();
                        gameState.resetIncrementUserMovementCounter = 0;
                      },
                    );
                  },
                );
              },
            ),
          ),
          //play button
          ScaleAnimationWidget(
            child: CustomButton(
              key: const Key('play'),
              width: width * 0.1,
              height: width * 0.1,
              icon: Icons.pause,
              iconColor: Colors.white,
              bgColor: const Color(0xFFf9a825),
              size: width * 0.1,
              onPressed: () {
                handleTimer.stopWatch();
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDialog(
                      title: 'Paused',
                      iconData: Icons.play_arrow,
                      onPressed: () {
                        handleTimer.startWatch();
                      },
                    );
                  },
                );
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
      );
    });
  }
}
