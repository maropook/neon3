import 'package:flutter/material.dart';

abstract class Styles {
  static const int _primaryValue = 0xFFFDD475;
  static const MaterialColor primarySwatch = MaterialColor(
    _primaryValue,
    <int, Color>{
      50: Color(_primaryValue),
      100: Color(_primaryValue),
      200: Color(_primaryValue),
      300: Color(_primaryValue),
      400: Color(_primaryValue),
      500: Color(_primaryValue),
      600: Color(_primaryValue),
      700: Color(_primaryValue),
      800: Color(_primaryValue),
      900: Color(_primaryValue),
    },
  );

// #c7de60
// #f1f7d9 second
  static const Color primaryColor = Color(0xFFFDD475);
  static const Color primaryColor700 = Color(0xFFF1F7D8);

  static const Color accentColor = Color(0xFFf1f7d9);
  static const Color myButtonColor = Color.fromARGB(255, 253, 234, 234);
  static const Color secondaryColor = Color(0xFF594A31);

  static const Color recordingColor = Color.fromARGB(255, 225, 109, 109);
  static const Color secondaryColor900 = Color.fromARGB(130, 89, 74, 49);
  static const Color pageBackground = Color.fromARGB(255, 255, 255, 255);
  static const Color appBarTitleColor = commonTextColor;
  static const Color commonTextColor = Color(0xFF594A31);
  static const Color contentsColor = Color.fromARGB(255, 255, 255, 255);

  static const editModalBottomSheetBackGroundColor =
      Color.fromARGB(85, 255, 255, 255);
  static const Color taskYellowColor = Color(0xFFFFEB94);
  static const Color taskSkyColor = Color(0xFFFFC1E1DC);
  static const Color taskPinkColor = Color(0xFFFFCCAC);

  static AppBarTheme appBarTheme = const AppBarTheme(
    centerTitle: true,
    backgroundColor: Styles.primaryColor,
    iconTheme: IconThemeData(
      color: Styles.appBarTitleColor,
    ),
    // titleTextStyle: GoogleFonts.mPlusRounded1c(
    //   textStyle: const TextStyle(
    //     color: Styles.appBarTitleColor,
    //     fontSize: 25,
    //   ),
    // ),
  );
  // static const TextTheme textTheme = TextTheme(
  //   headline1: TextStyle(
  //     fontSize: 59,
  //     height: 1.0,
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w400,
  //     color: Styles.commonTextColor,
  //   ),
  //   headline2: TextStyle(
  //       fontSize: 24,
  //       height: 1.48,
  //       fontStyle: FontStyle.normal,
  //       fontWeight: FontWeight.w700,
  //       color: Styles.commonTextColor),
  //   headline3: TextStyle(
  //     fontSize: 17,
  //     height: 1.48,
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w700,
  //     color: Styles.commonTextColor,
  //   ),
  //   headline4: TextStyle(
  //     fontSize: 16,
  //     height: 1.5,
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w700,
  //     color: Styles.commonTextColor,
  //   ),
  //   headline5: TextStyle(
  //     fontSize: 14,
  //     height: 1.48,
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w700,
  //     color: Styles.commonTextColor,
  //   ),
  //   bodyText1: TextStyle(
  //     fontSize: 14,
  //     height: 1.57,
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w400,
  //     color: Styles.commonTextColor,
  //   ),
  //   bodyText2: TextStyle(
  //     fontSize: 12,
  //     height: 1.44,
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w400,
  //     color: Styles.commonTextColor,
  //   ),
  //   subtitle1: TextStyle(
  //     fontSize: 16,
  //     height: 1.5,
  //     fontStyle: FontStyle.normal,
  //     fontWeight: FontWeight.w400,
  //     color: Styles.commonTextColor,
  //   ),
  //   button: TextStyle(
  //     fontSize: 16,
  //     height: 1.13,
  //     fontWeight: FontWeight.w700,
  //     fontStyle: FontStyle.normal,
  //     color: Styles.commonTextColor,
  //   ),
  //   caption: TextStyle(
  //     fontSize: 8,
  //     height: 1.48,
  //     fontWeight: FontWeight.w400,
  //     fontStyle: FontStyle.normal,
  //     color: Styles.commonTextColor,
  //   ),
  //   overline: TextStyle(
  //     fontSize: 9,
  //     height: 1.48,
  //     fontWeight: FontWeight.w700,
  //     fontStyle: FontStyle.normal,
  //     color: Styles.commonTextColor,
  //   ),
  // );
}
