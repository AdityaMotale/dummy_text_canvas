import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextObject {
  String content;
  Offset position;
  String fontFamily;
  double fontSize;
  Color color;

  bool isSelected = false;

  TextObject({
    required this.content,
    required this.fontFamily,
    required this.fontSize,
    required this.color,
    this.position = const Offset(100, 250),
  });

  void render(Canvas canvas) {
    TextSpan span = TextSpan(
      text: content,
      style: GoogleFonts.getFont(
        fontFamily,
        fontSize: fontSize,
        color: color,
      ),
    );

    TextPainter tp = TextPainter(text: span, textDirection: TextDirection.ltr);

    tp.layout();
    tp.paint(canvas, position);

    if (isSelected) {
      _drawDashedBorder(canvas, tp.size);
    }
  }

  bool contains(Offset offset) {
    return (offset - position).distance < 150;
  }

  // Function to draw dashed border
  void _drawDashedBorder(Canvas canvas, Size size) {
    const double dashWidth = 5.0;
    const double dashSpace = 5.0;
    const double padding = 4.0;

    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    Path path = Path();
    Offset start = position - const Offset(padding, padding);
    Size paddedSize = Size(size.width + padding * 2, size.height + padding * 2);

    for (double i = 0; i < paddedSize.width; i += dashWidth + dashSpace) {
      path.moveTo(start.dx + i, start.dy);
      path.lineTo(start.dx + i + dashWidth, start.dy);
    }
    for (double i = 0; i < paddedSize.height; i += dashWidth + dashSpace) {
      path.moveTo(start.dx + paddedSize.width, start.dy + i);
      path.lineTo(start.dx + paddedSize.width, start.dy + i + dashWidth);
    }
    for (double i = 0; i < paddedSize.width; i += dashWidth + dashSpace) {
      path.moveTo(
          start.dx + paddedSize.width - i, start.dy + paddedSize.height);
      path.lineTo(start.dx + paddedSize.width - i - dashWidth,
          start.dy + paddedSize.height);
    }
    for (double i = 0; i < paddedSize.height; i += dashWidth + dashSpace) {
      path.moveTo(start.dx, start.dy + paddedSize.height - i);
      path.lineTo(start.dx, start.dy + paddedSize.height - i - dashWidth);
    }

    canvas.drawPath(path, paint);
  }
}
