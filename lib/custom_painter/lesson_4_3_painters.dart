import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'lesson_4_1_painters.dart' show insetRect;
import 'shape_showcase.dart';

/// lesson 4.3.jpg — silindr, kub va Android roboti.
class Lesson43Screen extends StatelessWidget {
  const Lesson43Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShapesShowcase(
      title: 'Lesson 4.3 — Silindr, kub, Android',
      items: [
        ShapeItem(label: 'Silindr', painter: CylinderPainter()),
        ShapeItem(label: 'Kub', painter: CubePainter()),
        ShapeItem(
          label: 'Android',
          painter: AndroidPainter(),
          size: Size(170, 190),
        ),
      ],
    );
  }
}

/// Binafsha silindr: tanasi + tepadagi ellips.
class CylinderPainter extends CustomPainter {
  const CylinderPainter();

  static const _body = Color(0xFF7E4FC0);
  static const _cap = Color(0xFF8B5CD1);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = insetRect(size, factor: 0.6);
    final ellipseHeight = rect.width * 0.34;

    final topEllipse = Rect.fromCenter(
      center: Offset(rect.center.dx, rect.top + ellipseHeight / 2),
      width: rect.width,
      height: ellipseHeight,
    );
    final bottomEllipse = Rect.fromCenter(
      center: Offset(rect.center.dx, rect.bottom - ellipseHeight / 2),
      width: rect.width,
      height: ellipseHeight,
    );

    // Tana: chap chiziq -> pastki yarim ellips -> o'ng chiziq -> tepa yarim ellips.
    final body = Path()
      ..moveTo(rect.left, topEllipse.center.dy)
      ..lineTo(rect.left, bottomEllipse.center.dy)
      ..arcTo(bottomEllipse, math.pi, -math.pi, false)
      ..lineTo(rect.right, topEllipse.center.dy)
      ..arcTo(topEllipse, 0, math.pi, false)
      ..close();

    canvas.drawPath(body, Paint()..color = _body);
    canvas.drawOval(topEllipse, Paint()..color = _cap);
    canvas.drawOval(
      topEllipse,
      Paint()
        ..color = Colors.white70
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Izometrik yashil kub: tepa, chap va o'ng yuzlari.
class CubePainter extends CustomPainter {
  const CubePainter();

  static const _top = Color(0xFF00C400);
  static const _left = Color(0xFF00A800);
  static const _right = Color(0xFF008F00);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = insetRect(size, factor: 0.68);

    final radiusX = rect.width / 2;
    final capHeight = rect.height * 0.21; // tepa yuzning yarim balandligi
    final sideHeight = rect.height * 0.48; // yon qirraning balandligi
    final cx = rect.center.dx;
    final top = rect.top;

    final t = Offset(cx, top); // eng tepa nuqta
    final r = Offset(cx + radiusX, top + capHeight); // o'ng tepa
    final l = Offset(cx - radiusX, top + capHeight); // chap tepa
    final m = Offset(cx, top + capHeight * 2); // markaziy nuqta
    final br = Offset(cx + radiusX, top + capHeight + sideHeight);
    final bl = Offset(cx - radiusX, top + capHeight + sideHeight);
    final b = Offset(cx, top + capHeight * 2 + sideHeight);

    Path quad(Offset a, Offset b, Offset c, Offset d) => Path()
      ..moveTo(a.dx, a.dy)
      ..lineTo(b.dx, b.dy)
      ..lineTo(c.dx, c.dy)
      ..lineTo(d.dx, d.dy)
      ..close();

    final topFace = quad(t, r, m, l);
    final leftFace = quad(l, m, b, bl);
    final rightFace = quad(r, br, b, m);

    final fill = Paint()..style = PaintingStyle.fill;
    canvas.drawPath(topFace, fill..color = _top);
    canvas.drawPath(leftFace, fill..color = _left);
    canvas.drawPath(rightFace, fill..color = _right);

    final stroke = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    canvas.drawPath(topFace, stroke);
    canvas.drawPath(leftFace, stroke);
    canvas.drawPath(rightFace, stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Android roboti: antennalar, bosh, tana, qo'llar va oyoqlar.
class AndroidPainter extends CustomPainter {
  const AndroidPainter();

  static const _green = Color(0xFF6DA82C);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = insetRect(size, factor: 0.9);
    final w = rect.width;
    final h = rect.height;
    final cx = rect.center.dx;

    final green = Paint()..color = _green;

    final bodyWidth = w * 0.52;
    final headRadius = bodyWidth / 2;
    final headBottom = rect.top + h * 0.12 + headRadius;
    final headCenter = Offset(cx, headBottom);

    // Antennalar — bosh markazidan tashqariga chiquvchi chiziqlar.
    final antenna = Paint()
      ..color = _green
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.035
      ..strokeCap = StrokeCap.round;
    for (final sign in [-1.0, 1.0]) {
      final angle = sign * 0.55; // vertikaldan ~31 gradus
      final dir = Offset(math.sin(angle), -math.cos(angle));
      canvas.drawLine(
        headCenter + dir * (headRadius * 0.90),
        headCenter + dir * (headRadius * 1.40),
        antenna,
      );
    }

    // Bosh — yarim doira (yuqori yarmi).
    final headRect = Rect.fromCircle(center: headCenter, radius: headRadius);
    canvas.drawArc(headRect, math.pi, math.pi, true, green);

    // Ko'zlar.
    final eye = Paint()..color = Colors.white;
    final eyeRadius = headRadius * 0.11;
    final eyeY = headBottom - headRadius * 0.52;
    canvas.drawCircle(Offset(cx - headRadius * 0.42, eyeY), eyeRadius, eye);
    canvas.drawCircle(Offset(cx + headRadius * 0.42, eyeY), eyeRadius, eye);

    // Tana — pastki burchaklari biroz yumaloq.
    final bodyTop = headBottom + h * 0.025;
    final bodyBottom = rect.top + h * 0.78;
    final body = RRect.fromRectAndCorners(
      Rect.fromLTRB(cx - bodyWidth / 2, bodyTop, cx + bodyWidth / 2, bodyBottom),
      bottomLeft: Radius.circular(w * 0.06),
      bottomRight: Radius.circular(w * 0.06),
    );
    canvas.drawRRect(body, green);

    // Qo'llar.
    final armWidth = w * 0.13;
    final armTop = bodyTop + h * 0.01;
    final armBottom = bodyTop + (bodyBottom - bodyTop) * 0.68;
    for (final sign in [-1.0, 1.0]) {
      final left = cx + sign * (bodyWidth / 2 + w * 0.03) -
          (sign > 0 ? 0 : armWidth);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(left, armTop, left + armWidth, armBottom),
          Radius.circular(armWidth / 2),
        ),
        green,
      );
    }

    // Oyoqlar.
    final legWidth = w * 0.13;
    final legTop = bodyBottom - h * 0.03;
    final legBottom = rect.top + h * 0.97;
    for (final sign in [-1.0, 1.0]) {
      final center = cx + sign * bodyWidth * 0.26;
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTRB(
            center - legWidth / 2,
            legTop,
            center + legWidth / 2,
            legBottom,
          ),
          bottomLeft: Radius.circular(legWidth / 2),
          bottomRight: Radius.circular(legWidth / 2),
        ),
        green,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
