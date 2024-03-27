import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:omegatron/common/constants/assets_constant.dart';
import 'package:omegatron/customer/screen/analyticsprovider.dart';
import 'package:omegatron/customer/screen/cards_widgets2.dart';
import 'package:omegatron/customer/screen/graphcardwidget.dart';
import 'package:omegatron/customer/screen/page_header.dart';
import 'package:provider/provider.dart';
import 'package:omegatron/customer/screen/app_color_data.dart' as colordata;

class AnalyticsPage extends StatefulWidget {
  final Function(dynamic, int, Function(int)) addToBreadCrum;
  final List<BreadCrumbItem> breadcrumbList;
  const AnalyticsPage(
      {required this.addToBreadCrum, required this.breadcrumbList, super.key});
  @override
  State<AnalyticsPage> createState() => _AnalyticsPage();
}

class _AnalyticsPage extends State<AnalyticsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colordata.AppColors.primaryColor,
      body: Consumer<AnalyticsProvider>(builder: (context, value, child) {
        final analyticsDetails = value.analyticsModelDetails;
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: PageHeaderWidget(
                  breadCrumImage: AssetsConstants.analytics,
                  pageTitle: 'Analytics',
                  value: 0,
                  breadcrumbList: widget.breadcrumbList,
                  baseridebreadcrumchangevalue: 2,
                  baseridebreadcrumchangevalue2: 2,
                  addToBreadCrum: widget.addToBreadCrum,
                  setSelectedScreen: value.setSelectedScreen,
                  isBasePage: false,
                  isRidePage: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 20, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                        child: GraphCardWidget(
                            lineChartData1_1: analyticsDetails.lineChartData1_1,
                            lineChartData1_2: analyticsDetails.lineChartData1_2,
                            cardHeading: 'Main Positions Analytics'))
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(50, 20, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CardsWidget2(
                          title: 'X CrashFund',
                          profitlossnumericvalue:
                              analyticsDetails.xCrashFundProfitLossNumericValue,
                          profitlossvalue:
                              analyticsDetails.xCrashFundProfitLossValue,
                          graphshow: true,
                          graphData: analyticsDetails.xCrashFundLineGraphData,
                          dashboardPageCard: false),
                      CardsWidget2(
                          title: 'X LifeSnipe',
                          profitlossnumericvalue:
                              analyticsDetails.xLifeSnipeProfitLossNumericValue,
                          profitlossvalue:
                              analyticsDetails.xLifeSnipeProfitLossValue,
                          graphshow: true,
                          graphData: analyticsDetails.xLifeSnipeLineGraphData,
                          dashboardPageCard: false),
                      CardsWidget2(
                          title: 'Delta Cycling',
                          profitlossnumericvalue: analyticsDetails
                              .deltaCyclingProfitLossNumericValue,
                          profitlossvalue:
                              analyticsDetails.deltaCyclingProfitLossValue,
                          graphshow: true,
                          graphData: analyticsDetails.deltaCyclingLineGraphData,
                          dashboardPageCard: false)
                    ],
                  )),
            ],
          ),
        );
      }),
    );
  }
}
