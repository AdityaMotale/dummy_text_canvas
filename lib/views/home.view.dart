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
  bool isObjectSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Listener(
            onPointerDown: (event) {
              // Reset selection
              for (var textObject in textObjects) {
                textObject.isSelected = false;
                isObjectSelected = false;
              }

              // Get the tap position
              final renderBox = context.findRenderObject() as RenderBox;
              Offset localPosition = renderBox.globalToLocal(event.position);

              // Select the object if tap is near it
              for (var textObject in textObjects) {
                if (textObject.contains(localPosition)) {
                  textObject.isSelected = true;
                  isObjectSelected = true;
                  break;
                }
              }

              setState(() {});
            },
            child: GestureDetector(
              onTap: () {},
              onPanStart: (details) {
                if (!isObjectSelected) return;

                final renderBox = context.findRenderObject() as RenderBox;

                Offset localPosition = renderBox.globalToLocal(
                  details.globalPosition,
                );

                for (var textObject in textObjects) {
                  // Check if the object is selected and the pan starts near it
                  if (textObject.isSelected &&
                      textObject.contains(localPosition)) {
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
          ),

          // top tool bar
          isObjectSelected
              ? Positioned(
                  top: 40,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.34,
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
                            Icons.delete_rounded,
                            color: Colors.black,
                          ),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.edit_rounded,
                            color: Colors.black,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox(),

          // Bottom tool bar
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
