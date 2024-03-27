import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

import 'package:omegatron/customer/screen/home.dart';
import 'package:omegatron/customer/screen/login_button.dart';
import 'package:omegatron/customer/screen/signin_model.dart';

import 'app_color_data.dart' as colordata;
import 'package:omegatron/customer/screen/formfieldstyleandvalidation.dart';

class SigninPageBox extends StatefulWidget {
  final void Function(int) setSelectedScreen;
  final SigninModel? initialSigninModel;
  const SigninPageBox({
    Key? key,
    required this.initialSigninModel,
    required this.setSelectedScreen,
  }) : super(key: key);

  @override
  SigninPageBoxState createState() => SigninPageBoxState();
}

class SigninPageBoxState extends State<SigninPageBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoginMode = true;

// Track password visibility

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  onPressedLoginFunction() {
    if (_formKey.currentState!.validate()) {
      // If form is valid, navigate to the Home page
      SigninModel(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialSigninModel != null) {
      emailController.text = widget.initialSigninModel!.email;
    }
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _controller.value,
            child: SizedBox(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextFormField(
                                      controller: emailController,
                                      style: FormFieldStyleAndValidation
                                          .labelStyle,
                                      decoration: InputDecoration(
                                          hintText: 'Email',
                                          enabledBorder:
                                              FormFieldStyleAndValidation
                                                  .enableBorderStyle,
                                          focusedBorder:
                                              FormFieldStyleAndValidation
                                                  .focusedBorderStyle,
                                          hintStyle: FormFieldStyleAndValidation
                                              .labelStyle),
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
                                    TextFormField(
                                      controller: passwordController,
                                      style: FormFieldStyleAndValidation
                                          .labelStyle,
                                      obscureText: true,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      decoration: InputDecoration(
                                          hintText: 'Password',
                                          enabledBorder:
                                              FormFieldStyleAndValidation
                                                  .enableBorderStyle,
                                          focusedBorder:
                                              FormFieldStyleAndValidation
                                                  .focusedBorderStyle,
                                          hintStyle: FormFieldStyleAndValidation
                                              .labelStyle),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your password';
                                        }
                                        return null;
                                      },
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        emailController.clear();
                                        widget.initialSigninModel!.email = '';
                                        widget.setSelectedScreen(2);
                                      },
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          'Forgot password?',
                                          style: GoogleFonts.montserrat(
                                            textStyle: const TextStyle(
                                              color: colordata
                                                  .AppColors.primaryColor,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    LoginButton(
                                        text: 'Login',
                                        onPressedFunction:
                                            onPressedLoginFunction)
                                  ],
                                ))),
                        SizedBox(
                          height: isLoginMode ? 15 : 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            emailController.clear();
                            widget.initialSigninModel!.email = '';
                            widget.setSelectedScreen(1);
                          },
                          child: RichText(
                            text: TextSpan(
                              style: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(
                                      color: colordata.AppColors.primaryColor)),
                              children: [
                                const TextSpan(
                                    text: 'Don\'t have an account? '),
                                TextSpan(
                                  text: 'Create one',
                                  style: GoogleFonts.montserrat(
                                      textStyle: const TextStyle(
                                          decoration:
                                              TextDecoration.underline)),
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
            ),
          );
        });
  }
}
