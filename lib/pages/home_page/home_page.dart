import 'package:flutter/material.dart';
import 'package:slide_puzzle/pages/general_custom_widgets/button_scale_animation_widget.dart';
import 'package:slide_puzzle/pages/home_page/custom_widgets/animated_logo_puzzle.dart';
import 'package:slide_puzzle/pages/general_custom_widgets/custom_button.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffffe259), Color(0xffffa751)],
              stops: [0, 1],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFFffdac6),
                      //border radius
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: const AnimatedPuzzleLogo(),
                  ),
                  Text(
                    'Slide Puzzle',
                    style: TextStyle(
                      fontSize: width * 0.13,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              ButtonScaleAnimationWidget(
                child: CustomButton(
                  width: width * 0.35,
                  height: height * 0.17,
                  icon: Icons.play_arrow,
                  iconColor: Colors.white,
                  bgColor: const Color(0xFFf9a825),
                  size: width * 0.20,
                  onPressed: () => Navigator.pushNamed(context, '/game'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomButton(
                    width: width * 0.2,
                    height: width * 0.2,
                    icon: Icons.settings,
                    iconColor: Colors.white,
                    bgColor: const Color(0xFFf9a825),
                    size: width * 0.1,
                    onPressed: () {},
                  ),
                  CustomButton(
                    width: width * 0.2,
                    height: width * 0.2,
                    icon: Icons.info,
                    iconColor: Colors.white,
                    bgColor: const Color(0xFFf9a825),
                    size: width * 0.1,
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
