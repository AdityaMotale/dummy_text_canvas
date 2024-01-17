import 'package:flutter/material.dart';

class TextObject {
  String content;
  Offset position;
  TextStyle style;

  TextObject({
    required this.content,
    this.position = const Offset(100, 100),
    this.style = const TextStyle(color: Colors.black),
  });

  void render(Canvas canvas) {
    TextSpan span = TextSpan(
      text: content,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 24,
      ),
    );

    TextPainter tp = TextPainter(text: span, textDirection: TextDirection.ltr);

    tp.layout();
    tp.paint(canvas, position);
  }

  bool contains(Offset offset) {
    return (offset - position).distance < 150;
  }
}
