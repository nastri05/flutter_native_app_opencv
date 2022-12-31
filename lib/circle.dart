import 'package:flutter/material.dart';

class Circle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, size.width * 3 / 8, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
