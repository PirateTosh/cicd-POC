import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:omegatron/customer/screen/login_button.dart';

import 'app_color_data.dart' as colordata;
import 'package:omegatron/customer/screen/formfieldstyleandvalidation.dart';

class SignupOtpBox extends StatefulWidget {
  final void Function(int) setSelectedScreen;
  const SignupOtpBox({
    Key? key,
    required this.setSelectedScreen,
  }) : super(key: key);

  @override
  SignupOtpBoxState createState() => SignupOtpBoxState();
}

class SignupOtpBoxState extends State<SignupOtpBox> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
// Track password visibility

  TextEditingController otpController = TextEditingController();
  onPressedSubmitOtpFunction() {
    if (_formKey.currentState!.validate()) {
      // If form is valid, navigate to the Home page
      widget.setSelectedScreen(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 405,
      height: 400,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colordata.AppColors.primaryColor.withOpacity(0.3),
                  colordata.AppColors.primaryColor.withOpacity(0.1),
                ],
                stops: const [0.2, 1.0],
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Image.asset(
                    'assets/white_logo.png',
                    height: 90,
                    width: 300,
                  ),
                ),
                SizedBox(
                    width: 280,
                    height: 250,
                    child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextFormField(
                              controller: otpController,
                              style: FormFieldStyleAndValidation.labelStyle,
                              decoration: InputDecoration(
                                  hintText: 'Enter OTP',
                                  enabledBorder: FormFieldStyleAndValidation
                                      .enableBorderStyle,
                                  focusedBorder: FormFieldStyleAndValidation
                                      .focusedBorderStyle,
                                  hintStyle:
                                      FormFieldStyleAndValidation.labelStyle),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                            ),
                            LoginButton(
                                text: 'Submit',
                                onPressedFunction: onPressedSubmitOtpFunction)
                          ],
                        ))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
