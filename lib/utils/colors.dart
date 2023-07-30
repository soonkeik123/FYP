import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  static const Color themeColor = Color(0xFFE0F7FA);
  static const Color mainColor = Color(0xFF0D47A1);
  static const Color textColor = Color(0xDD000000);
  static const Color btmNaviItem = Color(0xFF5D4037);
  static const Color buttonBackgroundColor = Color(0xFFE0F7FA);
  static const Color signColor = Color(0xFF26C6DA);
  static const Color paraColor = Color(0x8A000000);

  static const Color dogBasicPurple = Color(0xFF7986CB);
  static const Color catBasicRed = Color(0xFFC62828);
  static const Color dogFullLight = Color(0xFFFF9E80);
  static const Color petBoarding = Color(0xFF0D47B7);
  static const Color catFullBrown = Color(0xFF8D6E63);
  static const Color petVaccineOrange = Color(0xFFE65100);
}

hexStringToColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF$hexColor";
  }
  return Color(int.parse(hexColor, radix: 16));
}
