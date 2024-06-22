import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedPuzzleLogo extends StatefulWidget {
  const AnimatedPuzzleLogo({super.key});

  @override
  AnimatedPuzzleLogoState createState() => AnimatedPuzzleLogoState();
}

class AnimatedPuzzleLogoState extends State<AnimatedPuzzleLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: PuzzleLogoPainter(_animation.value),
          size: const Size(200, 200),
        );
      },
    );
  }
}

class PuzzleLogoPainter extends CustomPainter {
  final double animationValue;

  PuzzleLogoPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    const radius = Radius.circular(10);
    final squareSize = size.width / 2;
    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 30,
      fontWeight: FontWeight.bold,
    );

    List<Color> colors = [
      Colors.white, //white
      Colors.green, //green
      Colors.blue, //blue
      Colors.red, //red
    ];

    List<Offset> positions = [
      Offset(squareSize, 0), // blanco
      const Offset(0, 0), //
      Offset(0, squareSize), // Azul
      Offset(squareSize, squareSize), //rojo
    ];

    List<List<Offset>> phasePositions = [
      [
        positions[0], // Blanco
        positions[1], // Verde
        positions[2], // Azul
        positions[3] // Rojo
      ], // Estado inicial
      [
        positions[1], // Verde ahora está en la posición inicial de Blanco
        positions[0], // Blanco ahora está en la posición inicial de Verde
        positions[2], // Azul
        positions[3] // Rojo
      ], // Intercambio 1: Blanco y Verde
      [
        positions[2], // Azul ahora está en la posición inicial de Blanco
        positions[
            0], // Blanco, que fue intercambiado con Verde, ahora está en la posición inicial de Azul
        positions[
            1], // Verde, que fue intercambiado con Blanco, ahora está en la posición de Azul
        positions[3] // Rojo
      ], // Intercambio 2: Blanco y Azul
      [
        positions[3], // Rojo ahora está en la posición inicial de Blanco
        positions[
            0], // Blanco, que fue intercambiado con Verde y luego con Azul, ahora está en la posición inicial de Rojo
        positions[
            1], // Verde mantiene su posición después del primer intercambio
        positions[
            2] // Azul mantiene su posición después del segundo intercambio
      ] // Intercambio 3: Blanco y Rojo
    ];

    int phase = (animationValue * (phasePositions.length - 1)).floor();
    double phaseValue = (animationValue * (phasePositions.length - 1)) - phase;
    phaseValue = phaseValue.clamp(0.0, 1.0);

    List<Offset> animatedPositions = List.generate(4, (index) {
      return Offset.lerp(
          phasePositions[phase][index],
          phasePositions[math.min(phase + 1, phasePositions.length - 1)][index],
          phaseValue)!;
    });

    for (int i = 0; i < 4; i++) {
      paint.color = colors[i];
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(animatedPositions[i].dx, animatedPositions[i].dy,
              squareSize, squareSize),
          radius,
        ),
        paint,
      );

      // Dibuja el texto si el cuadrado no es blanco
      if (colors[i] != Colors.white) {
        final textSpan = TextSpan(
          text: '$i', // Los números van del 1 al 3, ajusta según tu lógica
          style: textStyle,
        );
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();

        final xCenter =
            animatedPositions[i].dx + (squareSize - textPainter.width) / 2;
        final yCenter =
            animatedPositions[i].dy + (squareSize - textPainter.height) / 2;
        final offset = Offset(xCenter, yCenter);
        textPainter.paint(canvas, offset);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
