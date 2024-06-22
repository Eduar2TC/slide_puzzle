import 'package:flutter/material.dart';

class ButtonScaleAnimationWidget extends StatefulWidget {
  final Widget child;
  const ButtonScaleAnimationWidget({super.key, required this.child});

  @override
  ButtonScaleAnimationWidgetState createState() =>
      ButtonScaleAnimationWidgetState();
}

class ButtonScaleAnimationWidgetState extends State<ButtonScaleAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late CurvedAnimation _curvedAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutBack,
    );
    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.8).animate(_curvedAnimation);
    startAnimation();
    //animation with tween
  }

  void startAnimation() {
    _controller.forward();
    _controller.addListener(
      () {
        if (_controller.status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (_controller.status == AnimationStatus.dismissed) {
          Future.delayed(const Duration(milliseconds: 1500), () {
            _controller.forward();
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: widget.child,
    );
  }
}
