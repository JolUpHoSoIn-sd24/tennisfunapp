import 'package:flutter/material.dart';
import 'package:tennisfunapp/theme/text_theme.dart';

class TextFormFieldThemes {
  static final TextStyle textStyle = TextFormFieldThemes.textStyle;

  static final InputDecoration baseInputDecoration = InputDecoration(
    filled: true,
    fillColor: Color(0xFF4E4E4E),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(
        color: Color(0xFFD3D3D3),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(
        color: Colors.black,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(
        color: Colors.red,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(
        color: Colors.red,
      ),
    ),
  );
}