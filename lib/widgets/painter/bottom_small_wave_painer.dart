import 'package:flutter/material.dart';

class BottomSmallWavePainter extends CustomPainter {
  BottomSmallWavePainter({this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0 = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path path_0 = Path();
    path_0.moveTo(0, size.height * 0.71);
    path_0.quadraticBezierTo(size.width * 0.17, size.height * 0.66,
        size.width * 0.35, size.height * 0.69);
    path_0.cubicTo(size.width * 0.41, size.height * 0.70, size.width * 0.57,
        size.height * 0.71, size.width * 0.68, size.height * 0.70);
    path_0.cubicTo(size.width * 0.83, size.height * 0.68, size.width * 0.87,
        size.height * 0.67, size.width, size.height * 0.63);
    path_0.quadraticBezierTo(
        size.width, size.height * 0.72, size.width, size.height);
    path_0.lineTo(0, size.height);

    canvas.drawPath(path_0, paint_0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
