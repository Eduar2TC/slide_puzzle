import 'package:flutter/material.dart';

class ScaleAnimationWidget extends StatefulWidget {
  final Widget child;
  const ScaleAnimationWidget({super.key, required this.child});

  @override
  ScaleAnimationWidgetState createState() => ScaleAnimationWidgetState();
}

class ScaleAnimationWidgetState extends State<ScaleAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPanDown(details) {
    _controller.forward();
  }

  void _onPanCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: _onPanDown,
      onPanCancel: _onPanCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}
