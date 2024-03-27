import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

import 'package:omegatron/customer/screen/login_button.dart';
import 'package:omegatron/customer/screen/signin_model.dart';
import 'app_color_data.dart' as colordata;
import 'package:omegatron/customer/screen/formfieldstyleandvalidation.dart';

class ForgetPasswordBox extends StatefulWidget {
  final void Function(int) setSelectedScreen;
  final SigninModel? initialModel;
  const ForgetPasswordBox({
    Key? key,
    required this.initialModel,
    required this.setSelectedScreen,
  }) : super(key: key);

  @override
  ForgetPasswordBoxState createState() => ForgetPasswordBoxState();
}

class ForgetPasswordBoxState extends State<ForgetPasswordBox> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isShowBackToLogin = true;

  TextEditingController otpController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  bool isSentOTP = false;

  onPressedForgetPasswordFunction() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        widget.initialModel!.email = emailController.text;
        widget.setSelectedScreen(4);
        emailController.clear();
        otpController.clear();
      });
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
                            controller: emailController,
                            style: FormFieldStyleAndValidation.labelStyle,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              enabledBorder:
                                  FormFieldStyleAndValidation.enableBorderStyle,
                              focusedBorder: FormFieldStyleAndValidation
                                  .focusedBorderStyle,
                              hintStyle: FormFieldStyleAndValidation.labelStyle,
                              suffix: GestureDetector(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      isSentOTP = true;
                                    });
                                  }
                                },
                                child: Text(
                                  'SENT OTP',
                                  style: GoogleFonts.montserrat(
                                      textStyle: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              colordata.AppColors.blueShade_4)),
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              } else if (!RegExp(
                                      r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          if (isSentOTP)
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
                                    FormFieldStyleAndValidation.labelStyle,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the OTP';
                                }
                                return null;
                              },
                            ),
                          SizedBox(
                            height: 40,
                          ),
                          LoginButton(
                              text: 'Submit',
                              onPressedFunction:
                                  onPressedForgetPasswordFunction),
                        ],
                      ),
                    )),
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () {
                    widget.setSelectedScreen(0);
                    // widget.initialSigninModel!.email = emailController.text;
                  },
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                              color: colordata.AppColors.primaryColor)),
                      children: [
                        const TextSpan(text: 'Back To '),
                        TextSpan(
                          text: 'Login',
                          style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                  decoration: TextDecoration.underline)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
