import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:omegatron/customer/screen/cards_widget.dart';

import 'package:omegatron/customer/screen/tabledata.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omegatron/customer/screen/app_color_data.dart' as colordata;
import 'package:omegatron/customer/screen/x_equity_provider.dart';
import 'package:provider/provider.dart';

class XEquity extends StatefulWidget {
  final Function(int) setSelectedScreen;
  final List<BreadCrumbItem> breadcrumbList;
  const XEquity({
    super.key,
    required this.setSelectedScreen,
    required this.breadcrumbList,
  });
  @override
  State<XEquity> createState() => _XEquity();
}

class _XEquity extends State<XEquity> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final TextStyle cardLeftSideStyle = GoogleFonts.poppins(
        textStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18 * screenWidth / 1440,
            color: colordata.AppColors.secondaryColor));
    final TextStyle cardLeftSideNumericStyle = GoogleFonts.poppins(
        textStyle: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 18 * screenWidth / 1440,
      color: colordata.AppColors.greenShade_5,
    ));
    final TextStyle investmentAndCurrent = GoogleFonts.poppins(
        textStyle: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 18 * screenWidth / 1440,
      color: colordata.AppColors.secondaryColor,
    ));
    final TextStyle investmentAndCurrentNumeric = GoogleFonts.poppins(
        textStyle: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 18 * screenWidth / 1440,
      color: colordata.AppColors.greenShade_5,
    ));
    return Scaffold(
        backgroundColor: colordata.AppColors.primaryColor,
        body: Consumer<XEquityProvider>(builder: (context, value, child) {
          final xEquityDetails = value.xEquityModelDetails;
          return SafeArea(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment
                  .start, // Align children to the start (left)
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 10, 0, 0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: BreadCrumb(
                      items: widget.breadcrumbList,
                      divider: const Icon(
                        Icons.arrow_forward_ios,
                        color: colordata.AppColors.secondaryColor,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      40, 10, 0, 0), // Adjust the padding as needed
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'X-Equity',
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 36,
                          color: colordata.AppColors.secondaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Container(
                              height: MediaQuery.of(context).size.height * 0.4,
                              width: MediaQuery.of(context).size.width * 0.5,
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Row(
                                        children: [
                                          Row(
                                            children: [
                                              Text('Position 1 : ',
                                                  style: cardLeftSideStyle),
                                              Text(
                                                  xEquityDetails.position_1Value
                                                      .toString(),
                                                  style:
                                                      cardLeftSideNumericStyle)
                                            ],
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02),
                                          Row(
                                            children: [
                                              Text('Position 2 : ',
                                                  style: cardLeftSideStyle),
                                              Text(
                                                  xEquityDetails.position_2Value
                                                      .toString(),
                                                  style:
                                                      cardLeftSideNumericStyle)
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Row(
                                        children: [
                                          Row(
                                            children: [
                                              Text('Position 3 : ',
                                                  style: cardLeftSideStyle),
                                              Text(
                                                  xEquityDetails.position_3Value
                                                      .toString(),
                                                  style:
                                                      cardLeftSideNumericStyle)
                                            ],
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02),
                                          Row(
                                            children: [
                                              Text('Position 4 : ',
                                                  style: cardLeftSideStyle),
                                              Text(
                                                  xEquityDetails.position_4Value
                                                      .toString(),
                                                  style:
                                                      cardLeftSideNumericStyle)
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Row(
                                        children: [
                                          Row(
                                            children: [
                                              Text('Position 5 : ',
                                                  style: cardLeftSideStyle),
                                              Text(
                                                  xEquityDetails.position_5Value
                                                      .toString(),
                                                  style:
                                                      cardLeftSideNumericStyle)
                                            ],
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02),
                                          Row(
                                            children: [
                                              Text('Position 6 : ',
                                                  style: cardLeftSideStyle),
                                              Text(
                                                  xEquityDetails.position_6Value
                                                      .toString(),
                                                  style:
                                                      cardLeftSideNumericStyle)
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Row(
                                        children: [
                                          Row(
                                            children: [
                                              Text('Position 7 : ',
                                                  style: cardLeftSideStyle),
                                              Text(
                                                  xEquityDetails.position_7Value
                                                      .toString(),
                                                  style:
                                                      cardLeftSideNumericStyle)
                                            ],
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02),
                                          Row(
                                            children: [
                                              Text('Position 8 : ',
                                                  style: cardLeftSideStyle),
                                              Text(
                                                  xEquityDetails.position_8Value
                                                      .toString(),
                                                  style:
                                                      cardLeftSideNumericStyle)
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Row(
                                        children: [
                                          Row(
                                            children: [
                                              Text('Position 9 : ',
                                                  style: cardLeftSideStyle),
                                              Text(
                                                  xEquityDetails.position_9Value
                                                      .toString(),
                                                  style:
                                                      cardLeftSideNumericStyle)
                                            ],
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02),
                                          Row(
                                            children: [
                                              Text('Position 10 : ',
                                                  style: cardLeftSideStyle),
                                              Text(
                                                  xEquityDetails
                                                      .position_10Value
                                                      .toString(),
                                                  style:
                                                      cardLeftSideNumericStyle)
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        Expanded(
                            flex: 5,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CardsWidget(
                                            profitlossvalue: xEquityDetails
                                                .investmentProfitLossValue,
                                            profitlossnumericvalue: xEquityDetails
                                                .investmentProfitLossNumericValue,
                                            barGraphData: xEquityDetails
                                                .investmentBarGraphData),
                                        FittedBox(
                                          child: RichText(
                                              text: TextSpan(
                                                  text: "Investment Amount: ",
                                                  style: investmentAndCurrent,
                                                  children: <TextSpan>[
                                                TextSpan(
                                                    text: xEquityDetails
                                                        .investmentAmount
                                                        .toString(),
                                                    style:
                                                        investmentAndCurrentNumeric),
                                              ])),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CardsWidget(
                                            profitlossvalue: xEquityDetails
                                                .currentAmountProfitLossValue,
                                            profitlossnumericvalue: xEquityDetails
                                                .currentAmountProfitLossNumericValue,
                                            barGraphData: xEquityDetails
                                                .currentBarGraphData),
                                        FittedBox(
                                          child: RichText(
                                              text: TextSpan(
                                                  text: "Current Value: ",
                                                  style: investmentAndCurrent,
                                                  children: <TextSpan>[
                                                TextSpan(
                                                  text: xEquityDetails
                                                      .currentAmount
                                                      .toString(),
                                                  style:
                                                      investmentAndCurrentNumeric,
                                                ),
                                              ])),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ))
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 10, 0, 0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text("History",
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                fontSize: 26 * screenWidth / 1440,
                                fontWeight: FontWeight.w800,
                                color: colordata.AppColors.secondaryColor))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                  child: TableData(tableContent: xEquityDetails.tableData),
                ),
              ],
            ),
          ));
        }));
  }
}
