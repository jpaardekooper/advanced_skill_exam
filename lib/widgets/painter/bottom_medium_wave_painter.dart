import 'package:flutter/material.dart';

class BottomWaveMediumPainter extends CustomPainter {
  BottomWaveMediumPainter({this.color});
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0 = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;

    Path path_0 = Path();
    path_0.moveTo(0, size.height * 0.69);
    path_0.quadraticBezierTo(size.width * 0.07, size.height * 0.69,
        size.width * 0.13, size.height * 0.71);
    path_0.cubicTo(size.width * 0.60, size.height * 0.79, size.width * 0.68,
        size.height * 0.60, size.width, size.height * 0.59);
    path_0.quadraticBezierTo(
        size.width, size.height * 0.69, size.width, size.height);
    path_0.lineTo(size.width * 0.00, size.height);

    canvas.drawPath(path_0, paint_0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
