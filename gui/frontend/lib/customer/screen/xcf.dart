import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:omegatron/customer/screen/cards_widget.dart';
import 'package:omegatron/customer/screen/tabledata.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:omegatron/customer/screen/app_color_data.dart' as colordata;
import 'package:omegatron/customer/screen/xcf_provider.dart';
import 'package:provider/provider.dart';

class Xcf extends StatefulWidget {
  final Function(int) setSelectedScreen;
  final List<BreadCrumbItem> breadcrumbList;
  const Xcf({
    super.key,
    required this.setSelectedScreen,
    required this.breadcrumbList,
  });
  @override
  State<Xcf> createState() => _Xcf();
}

class _Xcf extends State<Xcf> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final TextStyle cardLeftSideStyle = GoogleFonts.poppins(
        textStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20 * screenWidth / 1440,
            color: colordata.AppColors.secondaryColor));
    final TextStyle cardLeftSideNumericStyle = GoogleFonts.poppins(
        textStyle: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 20 * screenWidth / 1440,
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
        body: Consumer<XcfProvider>(builder: (context, value, child) {
          final xcfDetails = value.xcfModelDetails;
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
                      'XCF',
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
                      children: [
                        Expanded(
                          flex: 5,
                          child: Container(
                              height: MediaQuery.of(context).size.height * 0.4,
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text('BAF : ',
                                            style: cardLeftSideStyle),
                                        Text(xcfDetails.bafValue.toString(),
                                            style: cardLeftSideNumericStyle),
                                      ],
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.03),
                                    Row(
                                      children: [
                                        Text('Arbitary Funds : ',
                                            style: cardLeftSideStyle),
                                        Text(
                                            xcfDetails.arbitaryFundValue
                                                .toString(),
                                            style: cardLeftSideNumericStyle)
                                      ],
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
                                            profitlossvalue: xcfDetails
                                                .investmentProfitLossValue,
                                            profitlossnumericvalue: xcfDetails
                                                .investmentProfitLossNumericValue,
                                            barGraphData: xcfDetails
                                                .investmentBarGraphData),
                                        FittedBox(
                                          child: RichText(
                                              text: TextSpan(
                                                  text: "Investment Amount: ",
                                                  style: investmentAndCurrent,
                                                  children: <TextSpan>[
                                                TextSpan(
                                                    text: xcfDetails
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
                                            profitlossvalue: xcfDetails
                                                .currentAmountProfitLossValue,
                                            profitlossnumericvalue: xcfDetails
                                                .currentAmountProfitLossNumericValue,
                                            barGraphData:
                                                xcfDetails.currentBarGraphData),
                                        FittedBox(
                                          child: RichText(
                                              text: TextSpan(
                                                  text: "Current Value: ",
                                                  style: investmentAndCurrent,
                                                  children: <TextSpan>[
                                                TextSpan(
                                                  text: xcfDetails.currentAmount
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
                  child: TableData(tableContent: xcfDetails.tableData),
                ),
              ],
            ),
          ));
        }));
  }
}
