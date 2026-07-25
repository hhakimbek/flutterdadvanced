import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'lesson_4_1_painters.dart' show insetRect, outlinePaint;
import 'shape_showcase.dart';

/// lesson 4.2.jpg — romb, olti burchak va 3D quti.
class Lesson42Screen extends StatelessWidget {
  const Lesson42Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShapesShowcase(
      title: 'Lesson 4.2 — Romb, olti burchak, quti',
      items: [
        ShapeItem(label: 'Romb', painter: DiamondPainter()),
        ShapeItem(label: 'Olti burchak', painter: HexagonPainter()),
        ShapeItem(label: '3D quti', painter: Box3DPainter()),
      ],
    );
  }
}

class DiamondPainter extends CustomPainter {
  const DiamondPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = insetRect(size);

    final path = Path()
      ..moveTo(rect.center.dx, rect.top)
      ..lineTo(rect.right, rect.center.dy)
      ..lineTo(rect.center.dx, rect.bottom)
      ..lineTo(rect.left, rect.center.dy)
      ..close();

    canvas.drawPath(path, outlinePaint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HexagonPainter extends CustomPainter {
  const HexagonPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = insetRect(size);
    final radius = rect.width / 2;
    final path = Path();

    // Har 60 gradusda bitta burchak — tepasi va pasti tekis olti burchak.
    for (var i = 0; i < 6; i++) {
      final angle = i * math.pi / 3;
      final point = Offset(
        rect.center.dx + radius * math.cos(angle),
        rect.center.dy + radius * math.sin(angle),
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();

    canvas.drawPath(path, outlinePaint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Izometrik to'g'ri burchakli parallelepiped (rasmda — ko'k-yashil quti).
class Box3DPainter extends CustomPainter {
  const Box3DPainter();

  static const _front = Color(0xFF0B9A9A);
  static const _top = Color(0xFF13B3B3);
  static const _side = Color(0xFF0A8080);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = insetRect(size);

    // Chuqurlik — orqa yuz chapga va yuqoriga siljiydi.
    final dx = rect.width * 0.18;
    final dy = rect.height * 0.22;
    final offset = Offset(-dx, -dy);

    // Old yuz o'ng-past tomonda joylashadi.
    final front = Rect.fromLTRB(
      rect.left + dx,
      rect.top + dy + rect.height * 0.12,
      rect.right,
      rect.bottom - rect.height * 0.12,
    );

    final topFace = Path()
      ..moveTo(front.left, front.top)
      ..lineTo(front.left + offset.dx, front.top + offset.dy)
      ..lineTo(front.right + offset.dx, front.top + offset.dy)
      ..lineTo(front.right, front.top)
      ..close();

    final sideFace = Path()
      ..moveTo(front.left, front.top)
      ..lineTo(front.left + offset.dx, front.top + offset.dy)
      ..lineTo(front.left + offset.dx, front.bottom + offset.dy)
      ..lineTo(front.left, front.bottom)
      ..close();

    final frontFace = Path()..addRect(front);

    final fill = Paint()..style = PaintingStyle.fill;
    canvas.drawPath(sideFace, fill..color = _side);
    canvas.drawPath(topFace, fill..color = _top);
    canvas.drawPath(frontFace, fill..color = _front);

    final stroke = outlinePaint()..strokeWidth = 1.4;
    canvas.drawPath(sideFace, stroke);
    canvas.drawPath(topFace, stroke);
    canvas.drawPath(frontFace, stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
