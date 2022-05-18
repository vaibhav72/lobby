import 'package:flutter/material.dart';

class MetaColors {
  static const Color primaryColor = Color(0xFF0061FF);
  static const Color secondaryColor = Colors.white;
  static const Color textColor = Colors.black;
  static const Color subTextColor = Color(0xFF707070);
  static const Color gradientColorTwo = Color(0xFF60EFFF);
  static const Color gradientColorOne = Color(0xFF0061FF);
  static const Color postShadowColor = Color(0x0061FF1F);
  static const LinearGradient gradient = LinearGradient(
    colors: [
      gradientColorOne,
      gradientColorTwo,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
