import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omegatron/customer/screen/app_color_data.dart' as colordata;

class GradientButton extends StatefulWidget {
  final void Function(dynamic, int, Function(int)) addToBreadCrum;
  final int value;
  final List<BreadCrumbItem> breadcrumbList;
  final Function(int) setSelectedScreen;
  final String text;
  final String breadCrumImage;
  final int screenIndex;
  bool isActivePage;
  int baseridebreadcrumchangevalue;
  final VoidCallback onPressedCallback;
  GradientButton({
    required this.setSelectedScreen,
    required this.value,
    required this.breadcrumbList,
    required this.breadCrumImage,
    required this.screenIndex,
    required this.baseridebreadcrumchangevalue,
    required this.addToBreadCrum,
    required this.isActivePage,
    required this.text,
    required this.onPressedCallback,
    super.key,
  });
  @override
  State<GradientButton> createState() => _GradientButton();
}

class _GradientButton extends State<GradientButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        if (widget.isActivePage == false) {
          setState(() {
            widget.onPressedCallback();

            if ((widget.screenIndex == 1 || widget.screenIndex == 2) &&
                widget.value == 0) {
              widget.addToBreadCrum(
                  widget.breadCrumImage, 0, widget.setSelectedScreen);
            }
            if (widget.baseridebreadcrumchangevalue == 1) {
              widget.breadcrumbList.removeLast();
            }
            if (widget.baseridebreadcrumchangevalue == 4) {
              widget.breadcrumbList.removeLast();
            }

            widget.addToBreadCrum(widget.text.toUpperCase(), widget.screenIndex,
                widget.setSelectedScreen);
          });
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.06,
        height: MediaQuery.of(context).size.height * 0.062,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: widget.isActivePage
                  ? [
                      colordata.AppColors.greenShade_3,
                      colordata.AppColors.greenShade_4
                    ]
                  : [
                      colordata.AppColors.blueShade_5,
                      colordata.AppColors.blueShade_4
                    ]),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(widget.text,
              style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                      color: colordata.AppColors.textPrimaryColor,
                      fontSize: 20 * MediaQuery.of(context).size.width / 1440,
                      fontWeight: FontWeight.w600))),
        ),
      ),
    );
  }
}
