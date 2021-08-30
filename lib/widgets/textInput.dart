import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomFormField extends StatelessWidget {
  final bool autoFocus;
  final bool enabled;
  final FocusNode fcs;
  final TextEditingController ctrl;
  final String hinttxt;
  final String prefixtext;
  final bool obscuretxt;
  final Icon? icondecoration;
  final Widget? widgetprefix;
  final TextInputAction? txtInputAction;
  final TextInputType? keyboardType;
  final Color decorationColor;
  final Color fontColor;
  final Color lblcolor;
  final List<TextInputFormatter>? inputFormatters;

  final double fontsize;
  final double radius;
  final void Function(String)? fieldSubmitted;
  final String? Function(String?)? validator;

  const CustomFormField(
      {Key? key,
      required this.fcs,
      required this.ctrl,
      required this.hinttxt,
      this.icondecoration,
      this.fieldSubmitted,
      this.validator,
      this.obscuretxt = false,
      this.enabled = true,
      this.txtInputAction,
      this.keyboardType,
      this.decorationColor = const Color.fromRGBO(37, 37, 38, 1),
      this.fontColor = Colors.white,
      this.fontsize = 16,
      this.radius = 30,
      this.widgetprefix,
      this.lblcolor = const Color.fromRGBO(120, 119, 122, 1),
      this.prefixtext = '',
      this.inputFormatters,
      this.autoFocus = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: decorationColor,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: TextFormField(
          autofocus: autoFocus,
          textCapitalization: TextCapitalization.sentences,
          enabled: enabled,
          enableSuggestions: true,
          keyboardType: keyboardType == null ? null : keyboardType,
          textInputAction: txtInputAction == null ? null : txtInputAction,
          focusNode: fcs,
          controller: ctrl,
          obscureText: obscuretxt,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            //prefix: widgetprefix == null ? null : widgetprefix,
            icon: icondecoration == null ? null : icondecoration,
            border: InputBorder.none,
            hintText: hinttxt,
            hintStyle: TextStyle(color: lblcolor, fontSize: fontsize),
            prefixText: prefixtext,

            prefixStyle: TextStyle(color: lblcolor, fontSize: fontsize),
            labelStyle:
                GoogleFonts.bebasNeue(color: lblcolor, fontSize: fontsize),
          ),
          validator: validator,
          autovalidateMode: (ctrl.text.length == 0)
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.always,
          style: TextStyle(color: fontColor, fontSize: fontsize),
          onFieldSubmitted: fieldSubmitted,
        ),
      ),
    );
  }
}
