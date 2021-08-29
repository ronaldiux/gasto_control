import 'package:flutter/material.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class CustomColors {
  static String hexTema1 = 'FF2B6C5F';
  static String hexTema2 = 'FF2777AA';

  static Color tema1({
    double opcaciti = 1,
  }) {
    return Color.fromRGBO(43, 108, 95, opcaciti);
  }

  Map<int, Color> color = {
    50: Color.fromRGBO(43, 108, 95, .1),
    100: Color.fromRGBO(43, 108, 95, .2),
    200: Color.fromRGBO(43, 108, 95, .3),
    300: Color.fromRGBO(43, 108, 95, .4),
    400: Color.fromRGBO(43, 108, 95, .5),
    500: Color.fromRGBO(43, 108, 95, .6),
    600: Color.fromRGBO(43, 108, 95, .7),
    700: Color.fromRGBO(43, 108, 95, .8),
    800: Color.fromRGBO(43, 108, 95, .9),
    900: Color.fromRGBO(43, 108, 95, 1),
  };

  static Color tema2({
    double opcaciti = 1,
  }) {
    return Color.fromRGBO(39, 119, 170, opcaciti);
  }

  static Color vermelho({
    double opcaciti = 1,
  }) {
    return Color.fromRGBO(255, 50, 50, opcaciti);
  }
}
