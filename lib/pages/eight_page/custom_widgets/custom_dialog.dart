import 'package:flutter/material.dart';
import 'package:slide_puzzle/pages/general_custom_widgets/button_scale_animation_widget.dart';
import 'package:slide_puzzle/pages/general_custom_widgets/custom_button.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final IconData iconData;

  final VoidCallback onPressed;
  const CustomDialog({
    super.key,
    required this.title,
    required this.iconData,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
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
            Text(
              title,
              style: const TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Center(
              child: ButtonScaleAnimationWidget(
                child: CustomButton(
                  width: 100,
                  height: 100,
                  icon: iconData,
                  iconColor: Colors.white,
                  bgColor: const Color(0xFFf9a825),
                  size: 50,
                  onPressed: () {
                    onPressed();
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
