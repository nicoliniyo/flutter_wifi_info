import 'dart:ui' show Color;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeColors {
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color defaultColor = Color.fromRGBO(136, 136, 136, 1.0);
  static const Color primaryDark = Color.fromRGBO(2, 136, 209, 1.0);
  static const Color primaryLigth = Color.fromRGBO(179, 229, 252, 1.0);
  static const Color primary = Color.fromRGBO(3, 169, 244, 1.0);
  static const Color icons = Color.fromRGBO(44, 44, 44, 1.0);
  static const Color accentColor = Color.fromRGBO(254, 36, 114, 1.0);
  static const Color primaryText = Color.fromRGBO(33, 33, 33, 1.0);
  static const Color secondaryText = Color.fromRGBO(117, 117, 117, 1.0);
  static const Color divider = Color.fromRGBO(189, 189, 189, 1.0);
  static const Color info = Color.fromRGBO(44, 168, 255, 1.0);
  static const Color error = Color.fromRGBO(206, 4, 4, 1.0);
  static const Color success = Color.fromRGBO(24, 206, 15, 1.0);
  static const Color warning = Color.fromRGBO(255, 178, 54, 1.0);
  static const Color disabled = Color.fromRGBO(136, 152, 170, 1.0);
  static const Color gradientStart = Color.fromRGBO(2, 84, 129, 1.0);
  static const Color gradientEnd = Color.fromRGBO(3, 169, 244, 1.0);
}

class ThemeTextStyle {
  static TextStyle robotoWhiteText =
      GoogleFonts.roboto(textStyle: const TextStyle(color: ThemeColors.white));

  static TextStyle robotoWhite16Text = GoogleFonts.roboto(
      textStyle: const TextStyle(
    color: ThemeColors.white,
    fontSize: 16,
    fontWeight: FontWeight.normal,
  ));

  static TextStyle robotoText =
      GoogleFonts.roboto(textStyle: const TextStyle(color: ThemeColors.black));

  static TextStyle robotoBold16Text = GoogleFonts.roboto(
      textStyle: const TextStyle(
    color: ThemeColors.black,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ));

  static TextStyle roboto10Text = GoogleFonts.roboto(
      textStyle: const TextStyle(
    color: ThemeColors.secondaryText,
    fontSize: 10,
    fontWeight: FontWeight.normal,
  ));

  static TextStyle roboto10WhiteText = GoogleFonts.roboto(
      textStyle: const TextStyle(
        color: ThemeColors.white,
        fontSize: 10,
        fontWeight: FontWeight.normal,
      ));
}
