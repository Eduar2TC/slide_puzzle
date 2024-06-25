import 'package:flutter/material.dart';

class PuzzleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    double squareSize = size.width / 2;
    const radius = Radius.circular(10);

    List<Color> colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.white, // Cuadrado blanco
    ];

    // Estilo del texto
    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 30,
      fontWeight: FontWeight.bold,
    );

    // Dibujar cada cuadrado con esquinas redondeadas y números
    for (int i = 0; i < 4; i++) {
      paint.color = colors[i];
      double left = (i % 2) * squareSize;
      double top = (i ~/ 2) * squareSize;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(left, top, squareSize, squareSize),
          radius,
        ),
        paint,
      );

      // No dibujar número en el cuadrado blanco
      if (colors[i] != Colors.white) {
        final textPainter = TextPainter(
          text: TextSpan(text: '${i + 1}', style: textStyle),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        final x = left + (squareSize - textPainter.width) / 2;
        final y = top + (squareSize - textPainter.height) / 2;
        textPainter.paint(canvas, Offset(x, y));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
