import 'package:flutter/material.dart';
import 'package:tennisfunapp/theme/text_theme.dart';

class ButtonThemes {
  static final ButtonStyle OneButtonStyle = ElevatedButton.styleFrom(
    minimumSize: Size(315, 30),
    backgroundColor: Color(0xFF464EFF),
    shape: RoundedRectangleBorder(
      side: BorderSide(width: 1, color: Color(0xFF464EFF)),
      borderRadius: BorderRadius.circular(5),
    ),
    textStyle: ButtonTextThemes.textStyle,
  );
}

class ToggleButtonThemes {
  static final double minWidth = 80;
  // 3개일 때 80, 2개일 때 120을 쓰되, 2개는 copyWith를 써서 활용
  static final BoxConstraints constraints = BoxConstraints(
    minHeight: 20,
    minWidth: minWidth,
  );
  static final Color selectedBorderColor = Color(0xFF464EFF);
  static final Color borderColor = Colors.grey;
  static final Color fillColor = Color(0xFF464EFF);
  static final Color selectedColor = Colors.grey;
  static final BorderRadius borderRadius = BorderRadius.circular(3);
  static final TextStyle textStyle = ButtonTextThemes.textStyle;
}

class TimeButtonTheme {
  static final ButtonStyle buttonStyle = TextButton.styleFrom(
    textStyle: TextFieldFormThemes.textStyle,
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    backgroundColor: Colors.white,
    side: BorderSide(color: Colors.grey, width: 1),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    ),
  );
}
