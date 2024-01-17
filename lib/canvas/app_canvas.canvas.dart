import 'text_painter.canvas.dart';
import 'package:flutter/material.dart';

class AppCanvas extends CustomPainter {
  final List<TextObject> textObjects;

  const AppCanvas({required this.textObjects});

  @override
  void paint(Canvas canvas, Size size) {
    // draws background for canvas
    _drawBg(canvas, size);

    // draws 18*36 grid
    _drawGridLines(canvas, size);

    // draw texts
    for (TextObject tObj in textObjects) {
      tObj.render(canvas);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  ///
  /// Draws a bg for the [AppCanvas]
  ///
  void _drawBg(Canvas canvas, Size size) {
    Rect background = Rect.fromLTWH(0, 0, size.width, size.height);
    Paint backgroundPaint = Paint()..color = Colors.grey.shade300;
    canvas.drawRect(background, backgroundPaint);
  }

  ///
  /// Draws 18 * 36 (width * height) grid lines for canvas
  ///
  void _drawGridLines(Canvas canvas, Size size) {
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
}
