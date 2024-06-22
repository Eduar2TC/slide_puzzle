import 'package:flutter/material.dart';


class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.width,
    required this.height,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.size,
    this.onPressed,
  });

  final double width;
  final double height;
  final IconData icon;
  final Color iconColor;
  final double size;
  final Color bgColor;
  //callback function
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.black12,
        borderRadius: BorderRadius.circular(40),
        border: const Border(
          top: BorderSide(color: Colors.white, width: 2),
          bottom: BorderSide(color: Colors.white, width: 6),
          left: BorderSide(color: Colors.white, width: 4),
          right: BorderSide(color: Colors.white, width: 4),
        ),
      ),
      child: TextButton(
        onPressed: () {
          if (onPressed != null) {
            onPressed!();
          }
        },
        style: ButtonStyle(
          minimumSize: WidgetStateProperty.all<Size>(
            Size(width, height),
          ),
          padding: WidgetStateProperty.all<EdgeInsets>(
            const EdgeInsets.all(20),
          ),
          backgroundColor: WidgetStateColor.resolveWith(
            (states) => bgColor,
          ),
          overlayColor: WidgetStateColor.resolveWith(
            (states) => const Color(0xFF353535).withOpacity(0.5),
          ),
          shape: WidgetStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        ),
        child: Icon(
          icon,
          size: size,
          color: iconColor,
        ),
      ),
    );
  }
}
