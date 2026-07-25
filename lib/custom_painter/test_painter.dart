import 'dart:math';

import 'package:flutter/material.dart';

class TestPainter extends StatefulWidget {
  const TestPainter({super.key});


  @override
  State<StatefulWidget> createState() => _TestPainterState();
}

class _TestPainterState extends State<TestPainter> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("SALOM"),),
      body: Center(
        child: CustomPaint(
          painter: CirclePainter(),
          // size: Size(200, 200),
          child: Container(),
        ),
      )
    );
  }


}

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.deepPurple..style = PaintingStyle.stroke..strokeWidth = 3;

    final path = Path();
    path.moveTo(50, 50);
    path.lineTo(300, 50);
    path.lineTo(300, 300);
    path.lineTo(50, 300);
    // path.lineTo(300, 100);
    path.close();
    canvas.drawPath(path,paint);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }

}