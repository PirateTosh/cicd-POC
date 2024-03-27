import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_color_data.dart' as colordata;

class FormFieldStyleAndValidation {
  static final TextStyle labelStyle = GoogleFonts.montserrat(
      textStyle: const TextStyle(
          fontSize: 14, color: colordata.AppColors.textPrimaryColor));
  static const UnderlineInputBorder enableBorderStyle = UnderlineInputBorder(
    borderSide: BorderSide(color: colordata.AppColors.textPrimaryColor),
  );
  static const UnderlineInputBorder focusedBorderStyle = UnderlineInputBorder(
    borderSide: BorderSide(color: colordata.AppColors.textPrimaryColor),
  );
}
