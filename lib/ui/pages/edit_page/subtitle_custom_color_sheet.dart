import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

Future<Color?> showColorPicker(
    BuildContext context, Color previousColor) async {
  Color pickedColor = Colors.white;

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext buildContext) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: ColorPicker(
            labelTypes: const <ColorLabelType>[ColorLabelType.hex],
            enableAlpha: false,
            pickerColor: previousColor,
            onColorChanged: (color) {
              pickedColor = color;
            },
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('決定'),
            onPressed: () {
              Navigator.of(context).pop(pickedColor);
            },
          ),
        ],
      );
    },
  );
}
