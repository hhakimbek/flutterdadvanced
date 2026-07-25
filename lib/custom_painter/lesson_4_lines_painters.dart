import 'package:flutter/material.dart';

import 'lesson_4_1_painters.dart' show insetRect, outlinePaint;
import 'shape_showcase.dart';

/// lesson 4 (2).jpg — chiziq, plyus va X.
class Lesson4LinesScreen extends StatelessWidget {
  const Lesson4LinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShapesShowcase(
      title: 'Lesson 4 — Chiziqlar',
      items: [
        ShapeItem(label: 'Chiziq', painter: LinePainter()),
        ShapeItem(label: 'Plyus', painter: PlusPainter()),
        ShapeItem(label: 'X belgisi', painter: CrossPainter()),
      ],
    );
  }
}

class LinePainter extends CustomPainter {
  const LinePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = insetRect(size);
    canvas.drawLine(
      Offset(rect.left, rect.center.dy),
      Offset(rect.right, rect.center.dy),
      outlinePaint(),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PlusPainter extends CustomPainter {
  const PlusPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = insetRect(size);
    final paint = outlinePaint();

    canvas.drawLine(
      Offset(rect.left, rect.center.dy),
      Offset(rect.right, rect.center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(rect.center.dx, rect.top),
      Offset(rect.center.dx, rect.bottom),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CrossPainter extends CustomPainter {
  const CrossPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = insetRect(size, factor: 0.6);
    final paint = outlinePaint();

    canvas.drawLine(rect.topLeft, rect.bottomRight, paint);
    canvas.drawLine(rect.topRight, rect.bottomLeft, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
