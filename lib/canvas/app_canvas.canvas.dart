import 'package:flutter/material.dart';

class AppCanvas extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // background
    Rect background = Rect.fromLTWH(0, 0, size.width, size.height);
    Paint backgroundPaint = Paint()..color = Colors.grey.shade300;
    canvas.drawRect(background, backgroundPaint);

    // grid
    Paint gridPaint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1;

    int horizontalCells = 18;
    int verticalCells = 36;

    double cellWidth = size.width / horizontalCells;
    double cellHeight = size.height / verticalCells;

    for (int i = 0; i <= horizontalCells; i++) {
      double x = i * cellWidth;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    for (int i = 0; i <= verticalCells; i++) {
      double y = i * cellHeight;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
