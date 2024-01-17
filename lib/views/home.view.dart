import '../canvas/text_painter.canvas.dart';
import 'package:flutter/material.dart';

import '../canvas/app_canvas.canvas.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final List<TextObject> textObjects = [];
  TextObject? draggedObject;
  Offset? dragStart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          GestureDetector(
            onPanStart: (details) {
              final renderBox = context.findRenderObject() as RenderBox;

              Offset localPosition = renderBox.globalToLocal(
                details.globalPosition,
              );

              for (var textObject in textObjects) {
                if (textObject.contains(localPosition)) {
                  draggedObject = textObject;
                  dragStart = localPosition;
                  break;
                }
              }
            },
            onPanUpdate: (details) {
              if (draggedObject != null && dragStart != null) {
                setState(() {
                  final renderBox = context.findRenderObject() as RenderBox;

                  Offset localPosition = renderBox.globalToLocal(
                    details.globalPosition,
                  );

                  Offset delta = localPosition - dragStart!;
                  draggedObject!.position += delta;
                  dragStart = localPosition;
                });
              }
            },
            onPanEnd: (details) {
              draggedObject = null;
              dragStart = null;
            },
            child: CustomPaint(
              painter: AppCanvas(textObjects: textObjects),
              size: Size.infinite,
            ),
          ),
          Positioned(
            bottom: 20,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                border: Border.all(
                  color: Colors.grey.shade500,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.undo_rounded,
                      color: Colors.black,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add_rounded,
                      size: 28,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      textObjects.add(
                        TextObject(content: "This is a dummy string"),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.redo_rounded,
                      color: Colors.black,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
