import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omegatron/customer/screen/gradientbutton.dart';
import 'package:omegatron/customer/screen/app_color_data.dart' as colordata;

class PageHeaderWidget extends StatefulWidget {
  final List<BreadCrumbItem> breadcrumbList;
  String pageTitle;
  bool isBasePage;
  int baseridebreadcrumchangevalue;
  int baseridebreadcrumchangevalue2;
  final String breadCrumImage;
  final int value;
  final Function(dynamic, int, Function(int)) addToBreadCrum;
  bool isRidePage;
  final Function(int) setSelectedScreen;
  PageHeaderWidget(
      {required this.pageTitle,
      required this.breadcrumbList,
      required this.isRidePage,
      required this.baseridebreadcrumchangevalue,
      required this.baseridebreadcrumchangevalue2,
      required this.value,
      required this.breadCrumImage,
      required this.addToBreadCrum,
      required this.isBasePage,
      required this.setSelectedScreen,
      super.key});

  @override
  State<PageHeaderWidget> createState() => _PageHeaderWidgetState();
}

class _PageHeaderWidgetState extends State<PageHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: colordata.AppColors.primaryColor,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 20, 40, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(widget.pageTitle,
                          style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 36,
                                  color: colordata.AppColors.secondaryColor))),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: Row(
                  children: [
                    GradientButton(
                      text: 'Base',
                      value: widget.value,
                      screenIndex: 1,
                      breadcrumbList: widget.breadcrumbList,
                      baseridebreadcrumchangevalue:
                          widget.baseridebreadcrumchangevalue2,
                      setSelectedScreen: widget.setSelectedScreen,
                      breadCrumImage: widget.breadCrumImage,
                      addToBreadCrum: widget.addToBreadCrum,
                      isActivePage: widget.isBasePage,
                      onPressedCallback: () {
                        widget.setSelectedScreen(1);
                      },
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    GradientButton(
                      text: 'Ride',
                      screenIndex: 2,
                      baseridebreadcrumchangevalue:
                          widget.baseridebreadcrumchangevalue,
                      value: widget.value,
                      breadcrumbList: widget.breadcrumbList,
                      setSelectedScreen: widget.setSelectedScreen,
                      breadCrumImage: widget.breadCrumImage,
                      addToBreadCrum: widget.addToBreadCrum,
                      isActivePage: widget.isRidePage,
                      onPressedCallback: () {
                        widget.setSelectedScreen(2);
                      },
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
