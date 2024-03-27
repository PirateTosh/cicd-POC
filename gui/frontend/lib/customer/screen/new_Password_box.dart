import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:omegatron/customer/screen/login_button.dart';

import 'app_color_data.dart' as colordata;
import 'package:omegatron/customer/screen/formfieldstyleandvalidation.dart';

class NewPasswordbox extends StatefulWidget {
  final void Function(int) setSelectedScreen;

  const NewPasswordbox({
    Key? key,
    required this.setSelectedScreen,
  }) : super(key: key);

  @override
  NewPasswordboxState createState() => NewPasswordboxState();
}

class NewPasswordboxState extends State<NewPasswordbox> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  onPressedNewPasswordFunction() {
    if (_formKey.currentState!.validate()) {
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
                            controller: passwordController,
                            style: FormFieldStyleAndValidation.labelStyle,
                            obscureText: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                                hintText: 'New Password',
                                enabledBorder: FormFieldStyleAndValidation
                                    .enableBorderStyle,
                                focusedBorder: FormFieldStyleAndValidation
                                    .focusedBorderStyle,
                                hintStyle:
                                    FormFieldStyleAndValidation.labelStyle),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              } else if (value.length < 8) {
                                return 'Must contain 8 character';
                              } else if (!value.contains(RegExp(r'[A-Z]'))) {
                                return 'Password must contain at least one uppercase letter';
                              } else if (!value.contains(
                                  RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                                return 'Password must contain at least one special character';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: confirmPasswordController,
                            style: FormFieldStyleAndValidation.labelStyle,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Confirm Password',
                              enabledBorder:
                                  FormFieldStyleAndValidation.enableBorderStyle,
                              focusedBorder: FormFieldStyleAndValidation
                                  .focusedBorderStyle,
                              hintStyle: FormFieldStyleAndValidation.labelStyle,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter correct password';
                              } else if (value != passwordController.text) {
                                return 'Password do not match!';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          LoginButton(
                              text: 'Submit',
                              onPressedFunction: onPressedNewPasswordFunction),
                          if (passwordController.text !=
                              confirmPasswordController.text)
                            const Text(
                              'Passwords do not match',
                              style: TextStyle(color: Colors.red),
                            ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
