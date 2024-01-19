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
                    onPressed: () async {
                      var textEditingController = TextEditingController();
                      await openTextObjectDialog(
                        context,
                        textEditingController,
                      );
                      textEditingController.dispose();
                      setState(() {});
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

  Future<void> openTextObjectDialog(
    BuildContext context,
    TextEditingController textEditingController, {
    TextObject? localTextObject,
  }) async {
    const availableFontSizes = <double>[14, 18, 24, 32, 48];
    const availableFontStyles = [
      "Poppins",
      "Inter",
      "Sacramento",
      "Montserrat",
    ];
    const availableColors = [
      Colors.black,
      Colors.red,
      Colors.cyan,
      Colors.purple,
      Colors.green,
    ];

    // by default set to 14
    double fontSize = availableFontSizes[1];

    // by default set to poppins
    String fontStyle = availableFontStyles[0];

    // by default set to black
    Color textColor = availableColors[0];

    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter localSetState) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.86,
                  height: MediaQuery.of(context).size.height * 0.43,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        "Create/Edit Text",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      TextField(
                        controller: textEditingController,
                        decoration: const InputDecoration(
                          hintText: "Dummy Text",
                          labelText: 'Text To Create',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Wrap(
                            spacing: 8.0, // Space between items
                            children: List<Widget>.generate(
                              availableColors.length,
                              (index) => InkWell(
                                onTap: () {
                                  localSetState(() {
                                    textColor = availableColors[index];
                                  });
                                },
                                child: Container(
                                  width: 25,
                                  height: 25,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4.0,
                                  ), // Additional optional margin
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: availableColors[index],
                                    border: Border.all(
                                      color: Colors.indigo,
                                      width: availableColors[index] == textColor
                                          ? 4
                                          : 0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          DropdownButton<double>(
                            icon: const Icon(Icons.keyboard_arrow_down_rounded),
                            value: fontSize,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                            items: availableFontSizes
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e.round().toString(),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (size) {
                              localSetState(() {
                                fontSize = size ?? availableFontSizes.first;
                              });
                            },
                          ),
                          DropdownButton<String>(
                            icon: const Icon(Icons.keyboard_arrow_down_rounded),
                            value: fontStyle,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                            items: availableFontStyles
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e.toString(),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (style) {
                              localSetState(() {
                                fontStyle = style ?? availableFontStyles.first;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: localTextObject != null
                            ? ElevatedButton(
                                child: const Text("Update"),
                                onPressed: () {
                                  // localTextObject ??= TextObject(
                                  //   content: "The newly created text",
                                  // );
                                  // textObjects.add(localTextObject!);
                                  Navigator.of(context).pop();
                                },
                              )
                            : ElevatedButton(
                                child: const Text("Create New Text"),
                                onPressed: () {
                                  if (textEditingController.text.isEmpty) {
                                    return;
                                  }

                                  localTextObject ??= TextObject(
                                    content: textEditingController.text,
                                    fontFamily: fontStyle,
                                    fontSize: fontSize,
                                    color: textColor,
                                  );

                                  textObjects.add(localTextObject!);

                                  Navigator.of(context).pop();
                                },
                              ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
