import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PoppinsStyle {
    static stylePoppins({
      double? fontSize,
      FontWeight? fontWeight,
      Color? color,
      double? height,
      TextDecoration? decoration,
    }) {
      try {
      return GoogleFonts.poppins(
        fontSize: fontSize ?? 14,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? Colors.black,
        height: height ?? 1,
        decoration: decoration,
      );
      } catch (e) {
      // Handle the exception by returning a default TextStyle
      return TextStyle(
        fontSize: fontSize ?? 14,
        fontWeight: fontWeight ?? FontWeight.normal,
        color: color ?? Colors.black,
        height: height ?? 1,
        decoration: decoration,
      );
      }
    }
}