import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_color_data.dart' as colordata;

class LoginButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressedFunction;
  const LoginButton(
      {required this.text, required this.onPressedFunction, super.key});

  @override
  LoginButtonState createState() => LoginButtonState();
}

class LoginButtonState extends State<LoginButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressedFunction,
      style: ElevatedButton.styleFrom(
        backgroundColor: colordata.AppColors.blueShade_7,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      child: Text(
        widget.text,
        style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
                fontSize: 16, color: colordata.AppColors.primaryColor)),
      ),
    );
  }
}
