import 'package:flutter/material.dart';

class BottomLargeWavePainter extends CustomPainter {
  BottomLargeWavePainter({this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0 = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path path_0 = Path();
    path_0.moveTo(0, size.height * 0.28);
    path_0.quadraticBezierTo(size.width * 0.26, size.height * 0.27,
        size.width * 0.40, size.height * 0.44);
    path_0.quadraticBezierTo(
        size.width * 0.56, size.height * 0.63, size.width, size.height * 0.57);
    path_0.lineTo(size.width, size.height);
    path_0.lineTo(0, size.height);

    canvas.drawPath(path_0, paint_0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
