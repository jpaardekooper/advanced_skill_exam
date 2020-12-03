import 'package:flutter/material.dart';

class TopSmallWavePainter extends CustomPainter {
  TopSmallWavePainter({this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0 = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path path_0 = Path();
    path_0.moveTo(0, size.height * 0.07);
    path_0.quadraticBezierTo(size.width * 0.10, size.height * 0.11,
        size.width * 0.20, size.height * 0.23);
    path_0.cubicTo(size.width * 0.31, size.height * 0.35, size.width * 0.85,
        size.height * 0.31, size.width, size.height * 0.23);
    path_0.quadraticBezierTo(size.width, size.height * 0.17, size.width, 0);
    path_0.lineTo(0, 0);

    canvas.drawPath(path_0, paint_0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
