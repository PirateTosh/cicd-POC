import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:omegatron/customer/screen/forget_password_box.dart';

import 'package:omegatron/customer/screen/new_Password_box.dart';
import 'package:omegatron/customer/screen/signin_model.dart';
import 'package:omegatron/customer/screen/signin_page_box.dart';
import 'package:omegatron/customer/screen/signinprovider.dart';
import 'package:omegatron/customer/screen/signup_otp_box.dart';

import 'package:omegatron/customer/screen/signup_page_box.dart';
import 'package:provider/provider.dart';
import 'app_color_data.dart' as colordata;

class Signinpage extends StatefulWidget {
  const Signinpage({Key? key}) : super(key: key);

  @override
  SigninState createState() => SigninState();
}

class SigninState extends State<Signinpage> {
  SigninModel existingSigninModel = SigninModel(email: '', password: '');

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SigninProvider>(builder: (context, value, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                'assets/blue_bg.jpg',
                fit: BoxFit.cover,
              ),
            ),
            // Content
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Container
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'UNVEILING THE\n'
                        'SCIENCE BEHIND\n'
                        'WEALTH GENERATION',
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: colordata.AppColors.primaryColor,
                          ),
                        ),
                      ),
                      Text(
                        'Learn To Create The Most Sustainable\n'
                        'Passive Income System Good For Beginner\n'
                        'Perfect For Professionals',
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            letterSpacing: 2,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: colordata.AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 50,
                ),
                // Card

                SizedBox(child: Consumer<SigninProvider>(
                  builder: (context, value, child) {
                    if (value.selectedScreen == 0) {
                      return SigninPageBox(
                        setSelectedScreen: value.setSelectedScreen,
                        initialSigninModel: existingSigninModel,
                      );
                    } else if (value.selectedScreen == 1) {
                      return SignupPageBox(
                        setSelectedScreen: value.setSelectedScreen,
                        initialModel: existingSigninModel,
                      );
                    } else if (value.selectedScreen == 2) {
                      return ForgetPasswordBox(
                        setSelectedScreen: value.setSelectedScreen,
                        initialModel: existingSigninModel,
                      );
                    } else if (value.selectedScreen == 3) {
                      return SignupOtpBox(
                          setSelectedScreen: value.setSelectedScreen);
                    } else if (value.selectedScreen == 4) {
                      return NewPasswordbox(
                        setSelectedScreen: value.setSelectedScreen,
                      );
                    } else {
                      return const Text(" this is error page");
                    }
                  },
                ))
              ],
            ),
          ],
        );
      }),
    );
  }
}
