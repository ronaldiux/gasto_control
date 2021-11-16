import 'package:flutter/cupertino.dart';
import 'package:gasto_control/model/Colors.dart';

class Defaultwidgets {
  static Text dfText(String text,
      {Color? defaultcolor,
      double tamanhofonte = 16,
      TextAlign align = TextAlign.left,
      FontWeight fontweight = FontWeight.w400}) {
    Color textcolor =
        (defaultcolor == null) ? CustomColors.tema1() : defaultcolor;

    return Text(
      text,
      textAlign: align,
      style: TextStyle(
        fontWeight: fontweight,
        color: textcolor,
        fontSize: tamanhofonte,
      ),
    );
  }
}
