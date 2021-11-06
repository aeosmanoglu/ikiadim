import 'package:flutter/material.dart';

class CustomColors {
  Color primaryColor;
  Color secondaryColor;

  CustomColors({
    this.primaryColor = const Color(0xFF194073),
    this.secondaryColor = const Color(0xFFD9CA7E),
  });

  MaterialColor _materialColor(Color color) {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(.1 * i);
    }

    for (var strength in strengths) {
      final double ds = .5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  get primarySwatch => _materialColor(primaryColor);
  get secondarySwatch => _materialColor(secondaryColor);
}
