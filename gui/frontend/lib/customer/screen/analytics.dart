import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:omegatron/customer/screen/analyticspage.dart';
import 'package:omegatron/customer/screen/analyticsprovider.dart';
import 'package:omegatron/customer/screen/base.dart';
import 'package:omegatron/customer/screen/ride.dart';
import 'package:omegatron/customer/screen/safetynet.dart';
import 'package:omegatron/customer/screen/xcf.dart';
import 'package:omegatron/customer/screen/xequity.dart';
import 'package:omegatron/customer/screen/xequitylifesnipe.dart';
import 'package:omegatron/customer/screen/xmf.dart';
import 'package:provider/provider.dart';
import 'package:omegatron/customer/screen/app_color_data.dart' as colordata;

class Analytics extends StatefulWidget {
  final void Function(dynamic, int, Function(int)) addToBreadCrum;

  final List<BreadCrumbItem> breadcrumbList;
  const Analytics({
    super.key,
    required this.addToBreadCrum,
    required this.breadcrumbList,
  });

  @override
  State<StatefulWidget> createState() => _Analytics();
}

class _Analytics extends State<Analytics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colordata.AppColors.primaryColor,
      body: Consumer<AnalyticsProvider>(builder: (context, value, child) {
        if (value.selectedScreen == 0) {
          return AnalyticsPage(
            addToBreadCrum: widget.addToBreadCrum,
            breadcrumbList: widget.breadcrumbList,
          );
        } else if (value.selectedScreen == 1) {
          return Base(
            setSelectedScreen: value.setSelectedScreen,
            isBasePage: true,
            baseridebreadcrumchangevalue: 1,
            breadcrumbList: widget.breadcrumbList,
            addToBreadCrum: widget.addToBreadCrum,
          );
        } else if (value.selectedScreen == 2) {
          return Ride(
            setSelectedScreen: value.setSelectedScreen,
            isRidePage: true,
            baseridebreadcrumchangevalue: 4,
            breadcrumbList: widget.breadcrumbList,
            addToBreadCrum: widget.addToBreadCrum,
          );
        } else if (value.selectedScreen == 3) {
          return SafetyNet(
              setSelectedScreen: value.setSelectedScreen,
              breadcrumbList: widget.breadcrumbList);
        } else if (value.selectedScreen == 4) {
          return Xcf(
              setSelectedScreen: value.setSelectedScreen,
              breadcrumbList: widget.breadcrumbList);
        } else if (value.selectedScreen == 5) {
          return XEquity(
              setSelectedScreen: value.setSelectedScreen,
              breadcrumbList: widget.breadcrumbList);
        } else if (value.selectedScreen == 6) {
          return Xmf(
              setSelectedScreen: value.setSelectedScreen,
              breadcrumbList: widget.breadcrumbList);
        } else if (value.selectedScreen == 7) {
          return Xequitylifesnipe(
              setSelectedScreen: value.setSelectedScreen,
              breadcrumbList: widget.breadcrumbList);
        } else {
          return const Text(" this is analytics  page");
        }
      }),
    );
  }
}
