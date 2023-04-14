import 'package:flutter/material.dart';

class SubtitleFontService {
  final Color _customBorderColor = Colors.white;
  final Color _customFontColor = Colors.white;

  String colorsToColorCode(String color) {
    switch (color) {
      case 'white':
        return Colors.white.toHexTriplet();
      case 'blue':
        return Colors.blue.toHexTriplet();
      case 'black':
        return Colors.black.toHexTriplet();
      case 'red':
        return Colors.red.toHexTriplet();
      case 'green':
        return Colors.green.toHexTriplet();
      case 'yellow':
        return Colors.yellow.toHexTriplet();
      case 'customFontColor':
        return _customFontColor.toHexTriplet();
      case 'customBorderColor':
        return _customBorderColor.toHexTriplet();
    }
    return '#000000ff';
  }
}

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final StringBuffer buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

extension ColorX on Color {
  String toHexTriplet() =>
      '#${(value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
}

enum SubtitlesFontColor {
  white,
  black,
  red,
  blue,
  green,
  yellow,
  customFontColor
}

enum SubtitlesBorderColor {
  white,
  black,
  red,
  blue,
  green,
  yellow,
  customBorderColor
}
