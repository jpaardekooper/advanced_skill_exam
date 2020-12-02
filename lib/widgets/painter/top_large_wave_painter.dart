import 'package:flutter/material.dart';

class TopLargeWavePainter extends CustomPainter {
  TopLargeWavePainter({this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0 = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;

    Path path_0 = Path();
    path_0.moveTo(size.width * 0.00, size.height * 0.00);
    path_0.quadraticBezierTo(size.width * 0.00, size.height * 0.19,
        size.width * 0.00, size.height * 0.25);
    path_0.cubicTo(size.width * 0.50, size.height * 0.26, size.width * 0.32,
        size.height * 0.42, size.width, size.height * 0.38);
    path_0.quadraticBezierTo(
        size.width, size.height * 0.28, size.width, size.height * 0.00);

    canvas.drawPath(path_0, paint_0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
