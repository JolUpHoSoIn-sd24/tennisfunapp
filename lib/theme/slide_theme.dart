import 'package:flutter/material.dart';

class CustomSliderTheme {
  static final SliderThemeData rangeSliderTheme = SliderThemeData(
    activeTrackColor: Color(0xFF464EFF),
    inactiveTrackColor: Color(0xFFEDEDED),
    thumbColor: Color(0xFF464EFF),
    overlayColor: Color(0xFF464EFF).withOpacity(0.2),
    valueIndicatorColor: Color(0xFF464EFF),
    valueIndicatorTextStyle: TextStyle(
      color: Colors.white,
    ),
    trackHeight: 4.0,
    rangeThumbShape: RoundRangeSliderThumbShape(enabledThumbRadius: 8.0),
    overlayShape: RoundSliderOverlayShape(overlayRadius: 16.0),
    rangeTrackShape: RectangularRangeSliderTrackShape(),
    rangeValueIndicatorShape: PaddleRangeSliderValueIndicatorShape(),
  );
}
