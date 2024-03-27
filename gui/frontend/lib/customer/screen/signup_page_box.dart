import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

import 'package:omegatron/customer/screen/login_button.dart';
import 'package:omegatron/customer/screen/signin_model.dart';

import 'app_color_data.dart' as colordata;
import 'package:omegatron/customer/screen/formfieldstyleandvalidation.dart';

import 'package:flutter/cupertino.dart';

class SignupPageBox extends StatefulWidget {
  final void Function(int) setSelectedScreen;
  final SigninModel? initialModel;
  const SignupPageBox({
    Key? key,
    required this.setSelectedScreen,
    required this.initialModel,
  }) : super(key: key);

  @override
  SignupPageBoxState createState() => SignupPageBoxState();
}

class SignupPageBoxState extends State<SignupPageBox>
    with SingleTickerProviderStateMixin {
  DateTime date = DateTime.now();
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  onPressedSignUpFunction() {
    if (_formKey.currentState!.validate()) {
      widget.initialModel!.email = emailController.text;
      widget.setSelectedScreen(3);
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool signupOtp = false;
  bool _isObscure = true;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _controller.value,
              child: SizedBox(
                width: 405,
                height: 520,
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
                              height: 70,
                              width: 300,
                            ),
                          ),
                          SizedBox(
                              width: 280,
                              height: 392,
                              child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextFormField(
                                        controller: nameController,
                                        style: FormFieldStyleAndValidation
                                            .labelStyle,
                                        decoration: InputDecoration(
                                            hintText: 'Name',
                                            enabledBorder:
                                                FormFieldStyleAndValidation
                                                    .enableBorderStyle,
                                            focusedBorder:
                                                FormFieldStyleAndValidation
                                                    .focusedBorderStyle,
                                            hintStyle:
                                                FormFieldStyleAndValidation
                                                    .labelStyle),
                                        validator: (value) {
                                          if ((value == null ||
                                              value.isEmpty)) {
                                            return 'Please enter your name';
                                          }
                                          return null;
                                        },
                                      ),
                                      TextFormField(
                                        controller: dateOfBirthController,
                                        style: FormFieldStyleAndValidation
                                            .labelStyle,
                                        decoration: InputDecoration(
                                          hintText: 'DOB',
                                          enabledBorder:
                                              FormFieldStyleAndValidation
                                                  .enableBorderStyle,
                                          focusedBorder:
                                              FormFieldStyleAndValidation
                                                  .focusedBorderStyle,
                                          hintStyle: FormFieldStyleAndValidation
                                              .labelStyle,
                                          suffixIcon: IconButton(
                                            icon: const Icon(
                                              Icons.calendar_today,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                            onPressed: () {
                                              showCupertinoModalPopup<void>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 0, 20, 0),
                                                    child: Container(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(25.0),
                                                        height: 300,
                                                        width: 300,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: CupertinoColors
                                                              .white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      16.0),
                                                        ),
                                                        child:
                                                            CupertinoDatePicker(
                                                          mode:
                                                              CupertinoDatePickerMode
                                                                  .date,
                                                          initialDateTime:
                                                              DateTime.now(),
                                                          minimumDate:
                                                              DateTime(1900),
                                                          maximumDate:
                                                              DateTime.now(),
                                                          onDateTimeChanged:
                                                              (DateTime
                                                                  newDate) {
                                                            // Update the text controller when the date is changed
                                                            dateOfBirthController
                                                                    .text =
                                                                "${newDate.year}-${newDate.month.toString().padLeft(2, '0')}-${newDate.day.toString().padLeft(2, '0')}";
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your date of birth';
                                          } else if (!RegExp(
                                                  r'^\d{4}-\d{2}-\d{2}$')
                                              .hasMatch(value)) {
                                            return 'Please enter a valid date in YYYY-MM-DD format';
                                          }
                                          return null;
                                        },
                                      ),
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
                                              .labelStyle,
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
                                      TextFormField(
                                        controller: passwordController,
                                        obscureText: true,
                                        style: FormFieldStyleAndValidation
                                            .labelStyle,
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
                                              .labelStyle,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your password';
                                          } else if (value.length < 8) {
                                            return 'Must contain 8 character';
                                          } else if (!value
                                              .contains(RegExp(r'[A-Z]'))) {
                                            return 'Password must contain at least one uppercase letter';
                                          } else if (!value.contains(RegExp(
                                              r'[!@#$%^&*(),.?":{}|<>]'))) {
                                            return 'Password must contain at least one special character';
                                          }
                                          return null;
                                        },
                                      ),
                                      TextFormField(
                                        controller: confirmPasswordController,
                                        style: FormFieldStyleAndValidation
                                            .labelStyle,
                                        obscureText: _isObscure,
                                        decoration: InputDecoration(
                                          hintText: 'Confirm Password',
                                          enabledBorder:
                                              FormFieldStyleAndValidation
                                                  .enableBorderStyle,
                                          focusedBorder:
                                              FormFieldStyleAndValidation
                                                  .focusedBorderStyle,
                                          hintStyle: FormFieldStyleAndValidation
                                              .labelStyle,
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _isObscure
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _isObscure = !_isObscure;
                                              });
                                            },
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter correct password';
                                          } else if (value !=
                                              passwordController.text) {
                                            return 'Password do not match!';
                                          }
                                          return null;
                                        },
                                      ),
                                      LoginButton(
                                        text: 'Signup',
                                        onPressedFunction:
                                            onPressedSignUpFunction,
                                      )
                                    ],
                                  ))),
                          SizedBox(
                            height: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.setSelectedScreen(0);
                            },
                            child: RichText(
                              text: TextSpan(
                                style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                        color:
                                            colordata.AppColors.primaryColor)),
                                children: [
                                  TextSpan(text: 'Already have account? '),
                                  TextSpan(
                                    text: 'Login',
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
          }),
    );
  }
}
