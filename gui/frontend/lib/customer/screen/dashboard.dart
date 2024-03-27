import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:omegatron/customer/screen/dashboard_provider.dart';
import 'package:omegatron/customer/screen/dashboardpage.dart';
import 'package:omegatron/customer/screen/safetynet.dart';
import 'package:omegatron/customer/screen/xcf.dart';
import 'package:omegatron/customer/screen/xequity.dart';
import 'package:omegatron/customer/screen/xequitylifesnipe.dart';
import 'package:omegatron/customer/screen/xmf.dart';
import 'package:provider/provider.dart';
import 'package:omegatron/customer/screen/base.dart';
import 'package:omegatron/customer/screen/ride.dart';

class Dashboard extends StatefulWidget {
  final Function(dynamic, int, Function(int)) addToBreadCrum;

  final List<BreadCrumbItem> breadcrumbList;
  const Dashboard({
    super.key,
    required this.addToBreadCrum,
    required this.breadcrumbList,
  });
  @override
  State<Dashboard> createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffFAF9FF),
        body: Consumer<DashboardProvider>(builder: (context, value, child) {
          if (value.selectedScreen == 0) {
            return DashboardPage(
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
            return const Text(" this is error page");
          }
        }));
  }
}
