import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'shape_showcase.dart';

/// lesson 4.1.jpg — doira, kvadrat, uchburchak.
class Lesson41Screen extends StatelessWidget {
  const Lesson41Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShapesShowcase(
      title: 'Lesson 4.1 — Oddiy shakllar',
      items: [
        ShapeItem(label: 'Doira', painter: CirclePainter()),
        ShapeItem(label: 'Kvadrat', painter: SquarePainter()),
        ShapeItem(label: 'Uchburchak', painter: TrianglePainter()),
      ],
    );
  }
}

/// Barcha chiziqli shakllar uchun umumiy qalam.
Paint outlinePaint() => Paint()
  ..color = Colors.black
  ..style = PaintingStyle.stroke
  ..strokeWidth = 1.6;

/// Shakl chiziladigan ichki maydon (chetlaridan bo'sh joy qoldiriladi).
Rect insetRect(Size size, {double factor = 0.72}) => Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width * factor,
      height: size.height * factor,
    );

class CirclePainter extends CustomPainter {
  const CirclePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = insetRect(size);
    final radius = math.min(rect.width, rect.height) / 2;
    canvas.drawCircle(rect.center, radius, outlinePaint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SquarePainter extends CustomPainter {
  const SquarePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = insetRect(size);
    final side = math.min(rect.width, rect.height);
    final square = Rect.fromCenter(
      center: rect.center,
      width: side,
      height: side,
    );

    final path = Path()
      ..moveTo(square.left, square.top)
      ..lineTo(square.right, square.top)
      ..lineTo(square.right, square.bottom)
      ..lineTo(square.left, square.bottom)
      ..close();

    canvas.drawPath(path, outlinePaint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TrianglePainter extends CustomPainter {
  const TrianglePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = insetRect(size);

    final path = Path()
      ..moveTo(rect.center.dx, rect.top + rect.height * 0.12)
      ..lineTo(rect.right, rect.bottom - rect.height * 0.12)
      ..lineTo(rect.left, rect.bottom - rect.height * 0.12)
      ..close();

    canvas.drawPath(path, outlinePaint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
