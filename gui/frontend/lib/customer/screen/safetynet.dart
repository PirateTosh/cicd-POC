import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:omegatron/customer/screen/cards_widget.dart';
import 'package:omegatron/customer/screen/safetynet_provider.dart';
import 'package:omegatron/customer/screen/tabledata.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omegatron/customer/screen/app_color_data.dart' as colordata;
import 'package:provider/provider.dart';

class SafetyNet extends StatefulWidget {
  final Function(int) setSelectedScreen;
  final List<BreadCrumbItem> breadcrumbList;
  const SafetyNet(
      {super.key,
      required this.breadcrumbList,
      required this.setSelectedScreen});
  @override
  State<SafetyNet> createState() => _SafetyNet();
}

class _SafetyNet extends State<SafetyNet> {
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
        body: Consumer<SafetynetProvider>(builder: (context, value, child) {
          final SafetyNetDetails = value.safetynetModelDetails;
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
                      'Safety Net',
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
                                        Text('FD : ', style: cardLeftSideStyle),
                                        Text(
                                            SafetyNetDetails.fdValue.toString(),
                                            style: cardLeftSideNumericStyle),
                                      ],
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.03),
                                    Row(
                                      children: [
                                        Text('Metals : ',
                                            style: cardLeftSideStyle),
                                        Text(
                                            SafetyNetDetails.metalValue
                                                .toString(),
                                            style: cardLeftSideNumericStyle)
                                      ],
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.03),
                                    Row(
                                      children: [
                                        Text('Bonds : ',
                                            style: cardLeftSideStyle),
                                        Text(
                                            SafetyNetDetails.bondsValue
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
                                          profitlossvalue: SafetyNetDetails
                                              .investmentProfitLossValue,
                                          profitlossnumericvalue: SafetyNetDetails
                                              .investmentProfitLossNumericValue,
                                          barGraphData: SafetyNetDetails
                                              .investmentBarGraphData,
                                        ),
                                        FittedBox(
                                          child: RichText(
                                              text: TextSpan(
                                                  text: "Investment Amount: ",
                                                  style: investmentAndCurrent,
                                                  children: <TextSpan>[
                                                TextSpan(
                                                    text: SafetyNetDetails
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
                                          profitlossvalue: SafetyNetDetails
                                              .currentAmountProfitLossValue,
                                          profitlossnumericvalue: SafetyNetDetails
                                              .currentAmountProfitLossNumericValue,
                                          barGraphData: SafetyNetDetails
                                              .currentBarGraphData,
                                        ),
                                        FittedBox(
                                          child: RichText(
                                              text: TextSpan(
                                                  text: "Current Value: ",
                                                  style: investmentAndCurrent,
                                                  children: <TextSpan>[
                                                TextSpan(
                                                  text: SafetyNetDetails
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
                  child: TableData(tableContent: SafetyNetDetails.tableData),
                ),
              ],
            ),
          ));
        }));
  }
}
