import 'package:flutter/material.dart';

class Font {
  Font({
    required this.screenName,
    required this.name,
    required this.fileName,
  });

  late String screenName;
  late String name;
  late String fileName;
}

class SubtitleFontService {
  final Color _customBorderColor = Colors.white;
  final Color _customFontColor = Colors.white;

  final List<Font> fontList = <Font>[
    Font(
      fileName: 'YasashisaGothicBold.otf',
      screenName: 'やさしさゴシック',
      name: 'YasashisaGothicBoldV2-bold',
    ),
    Font(
        fileName: 'AkazukiPOP.otf',
        screenName: 'あかずきんPop',
        name: '07AkazukinPop'),
    Font(
      fileName: 'SoukouMincho.ttf',
      screenName: '装甲明朝',
      name: 'SoukouMincho',
    ),
    Font(
      fileName: 'Corporate-Logo-Medium-ver3.otf',
      screenName: 'コーポレート・ロゴ',
      name: 'Corporate-Logo-Medium-ver3',
    ),
    Font(
      fileName: 'Koruri-Regular.ttf',
      screenName: '小瑠璃フォント',
      name: 'Koruri-Regular',
    ),
    Font(
      fileName: '',
      screenName: 'systemFont',
      name: 'systemFont',
    ),
  ];
  double getFontHeight(String fontName) {
    var fontSize = 0.0;
    switch (fontName) {
      case "YasashisaGothicBoldV2-bold":
        return 0.45;
      case "07AkazukinPop":
        return 0.38;
      case "SoukouMincho":
        return 0.00;
      default:
        print("no font");
    }
    return fontSize;
  }
  // double getFontHeight(String fontName) {
  //   var fontSize = 1.0;
  //   switch (fontName) {
  //     case "YasashisaGothicBoldV2-bold":
  //       return 1.45;
  //     case "07AkazukinPop":
  //       return 1.38;
  //     case "SoukouMincho":
  //       return 1.00;
  //     default:
  //       print("no font");
  //   }
  //   return fontSize;
  // }

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
  // customFontColor
}

enum SubtitlesBorderColor {
  white,
  black,
  red,
  blue,
  green,
  yellow,
  // customBorderColor
}
