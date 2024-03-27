import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:flutter/material.dart';
import 'package:omegatron/common/constants/assets_constant.dart';
import 'package:omegatron/customer/screen/base_provider.dart';
import 'package:omegatron/customer/screen/page_header.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:badges/badges.dart' as badges;
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:omegatron/customer/screen/app_color_data.dart' as colordata;
import 'package:provider/provider.dart';

class Base extends StatefulWidget {
  final bool isBasePage;
  final int baseridebreadcrumchangevalue;
  final Function(dynamic, int, Function(int)) addToBreadCrum;

  final List<BreadCrumbItem> breadcrumbList;
  final Function(int) setSelectedScreen;
  const Base(
      {required this.isBasePage,
      required this.baseridebreadcrumchangevalue,
      required this.addToBreadCrum,
      required this.breadcrumbList,
      Key? key,
      required this.setSelectedScreen});

  @override
  State<Base> createState() => _BaseState();
}

class _BaseState extends State<Base> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    final double scaleFactor =
        screenWidth / 1440; // Assuming 1440 is the base width

    return Scaffold(
      backgroundColor: colordata.AppColors.primaryColor,
      body: Consumer<BaseProvider>(builder: (context, value, child) {
        final baseDetails = value.baseModelDetails;
        return SingleChildScrollView(
          child: Column(
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
              PageHeaderWidget(
                pageTitle: 'Base',
                value: 1,
                breadcrumbList: widget.breadcrumbList,
                baseridebreadcrumchangevalue:
                    widget.baseridebreadcrumchangevalue,
                baseridebreadcrumchangevalue2: 2,
                setSelectedScreen: widget.setSelectedScreen,
                isBasePage: widget.isBasePage,
                isRidePage: false,
                breadCrumImage: AssetsConstants.analytics,
                addToBreadCrum: widget.addToBreadCrum,
              ),
              Container(
                color: colordata.AppColors.primaryColor,
                padding: const EdgeInsets.fromLTRB(40, 10, 0, 0),
                child: Align(
                  alignment: Alignment.center,
                  child: LayoutBuilder(builder: (context, constraints) {
                    int numberOfCardsInRow =
                        3; // You can adjust this value based on your needs
                    double availableWidth =
                        constraints.maxWidth - 40; // Adjust padding as needed
                    double cardWidth = MediaQuery.of(context).size.width * 0.24;

                    return Wrap(
                      // spacing: (availableWidth - numberOfCardsInRow * cardWidth) /
                      //     (numberOfCardsInRow),
                      runSpacing: 12.0,
                      children: [
                        _buildCard(
                            context,
                            'SAFETY NET',
                            baseDetails.safetyNetList,
                            3,
                            scaleFactor,
                            widget.setSelectedScreen,
                            colordata.AppColors.greenShade_2,
                            baseDetails.safetyNetProfitLossValue,
                            baseDetails.safetyNetProfitLossNumericValue,
                            widget.addToBreadCrum,
                            baseDetails.safetyNetInvestmentAmount,
                            baseDetails.safetyNetCurrentAmount),
                        _buildCard(
                            context,
                            'XCF',
                            baseDetails.xcfList,
                            4,
                            scaleFactor,
                            widget.setSelectedScreen,
                            colordata.AppColors.redColor,
                            baseDetails.xcfProfitLossValue,
                            baseDetails.xcfProfitLossNumericValue,
                            widget.addToBreadCrum,
                            baseDetails.xcfInvestmentAmount,
                            baseDetails.xcfCurrentAmount),
                        _buildCard(
                            context,
                            'X- Equity (Top-5)',
                            baseDetails.xEquityList,
                            5,
                            scaleFactor,
                            widget.setSelectedScreen,
                            colordata.AppColors.greenShade_2,
                            baseDetails.xEquityProfitLossValue,
                            baseDetails.xEquityProfitLossNumericValue,
                            widget.addToBreadCrum,
                            baseDetails.xEquityInvestmentAmount,
                            baseDetails.xEquityCurrentAmount),
                        _buildCard(
                            context,
                            'XMF',
                            baseDetails.xmfList,
                            6,
                            scaleFactor,
                            widget.setSelectedScreen,
                            colordata.AppColors.greenShade_2,
                            baseDetails.xmfProfitLossValue,
                            baseDetails.xmfProfitLossNumericValue,
                            widget.addToBreadCrum,
                            baseDetails.xmfInvestmentAmount,
                            baseDetails.xEquityCurrentAmount),
                        _buildCard(
                            context,
                            'X- Equity Life Snipe',
                            baseDetails.xEquityLifeSnipeList,
                            7,
                            scaleFactor,
                            widget.setSelectedScreen,
                            colordata.AppColors.greenShade_2,
                            baseDetails.xEquityLifeSnipeProfitLossValue,
                            baseDetails.xEquityLifeSnipeProfitLossNumericValue,
                            widget.addToBreadCrum,
                            baseDetails.xEquityInvestmentAmount,
                            baseDetails.xEquityLifeSnipeCurrentAmount),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCard(
      BuildContext context,
      String name,
      List<Map<String, dynamic>> keyValueList,
      int screenIndex,
      double scalefactor,
      Function(int) setSelectedScreen,
      Color color,
      String gainAndLossValue,
      int gainAndLossNumericValue,
      Function(dynamic, int, Function(int)) addToBreadCrum,
      int investmentAmount,
      int currentAmount) {
    String profitLossSign = gainAndLossValue == 'Gains' ? '+' : '-';
    String profitLossformattedText =
        '${profitLossSign} ${gainAndLossNumericValue} %';
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setSelectedScreen(screenIndex);
          addToBreadCrum(name, screenIndex, setSelectedScreen);
        },
        child: Card(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.24,
            height: MediaQuery.of(context).size.height * 0.42,
            child: Column(
              children: [
                Container(
                  height: 13.0,
                  decoration: const BoxDecoration(
                    color: colordata.AppColors.blueShade_2,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.0),
                      topRight: Radius.circular(24.0),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: colordata.AppColors.textPrimaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24.0),
                        bottomRight: Radius.circular(24.0),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: [
                          Text(
                            name,
                            style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    fontSize: 20 * scalefactor,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 2)),
                          ),
                          Expanded(
                            flex: 8,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: keyValueList.map((item) {
                                      return Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 12, 0, 0),
                                        child: RichText(
                                          text: TextSpan(
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                fontSize: 14 * scalefactor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            children: [
                                              TextSpan(
                                                text: '${item['key']} ',
                                                style: const TextStyle(
                                                  color: colordata.AppColors
                                                      .secondaryColor, // Set key color to black
                                                ),
                                              ),
                                              TextSpan(
                                                text: '${item['value']}',
                                                style: const TextStyle(
                                                  color: colordata.AppColors
                                                      .greenShade_5, // Set value color to green
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: 10,
                                          right: 10,
                                          child: badges.Badge(
                                            badgeContent: FittedBox(
                                              child: Text(
                                                gainAndLossValue,
                                                style: TextStyle(
                                                    fontSize: 12 *
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        1440,
                                                    color: colordata.AppColors
                                                        .textPrimaryColor),
                                              ),
                                            ),
                                            position:
                                                badges.BadgePosition.topStart(),
                                            badgeStyle: badges.BadgeStyle(
                                              badgeColor: color,
                                              elevation: 4,
                                              shape: badges.BadgeShape.square,
                                              padding: const EdgeInsets.all(2),
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                            ),
                                            child: FittedBox(
                                              child: Column(
                                                children: [
                                                  CircularPercentIndicator(
                                                    radius:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.040,
                                                    lineWidth: 3.0,
                                                    percent: 0.65,
                                                    center: Text(
                                                      profitLossformattedText,
                                                      style: TextStyle(
                                                        fontSize:
                                                            14 * scalefactor,
                                                        color: color,
                                                      ),
                                                    ),
                                                    footer: Column(
                                                      children: [
                                                        SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.05,
                                                            child:
                                                                gainAndLossValue ==
                                                                        'Loss'
                                                                    ? SvgPicture
                                                                        .asset(
                                                                        AssetsConstants
                                                                            .lossicon,
                                                                        fit: BoxFit
                                                                            .contain,
                                                                      )
                                                                    : SvgPicture
                                                                        .asset(
                                                                        AssetsConstants
                                                                            .gainicon,
                                                                        fit: BoxFit
                                                                            .contain,
                                                                      )),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 10),
                                                          child: Text(
                                                            profitLossformattedText,
                                                            style: GoogleFonts
                                                                .montserrat(
                                                              textStyle:
                                                                  TextStyle(
                                                                fontSize: 13,
                                                                color: color,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          "ROI",
                                                          style: GoogleFonts
                                                              .montserrat(
                                                            textStyle:
                                                                const TextStyle(
                                                              fontSize: 13,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    progressColor: color,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 10),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Row(
                                        children: [
                                          Text(
                                            'Invested Amount: ',
                                            style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    fontSize: 12 * scalefactor,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ),
                                          Text(investmentAmount.toString(),
                                              style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      fontSize:
                                                          12 * scalefactor,
                                                      color: colordata.AppColors
                                                          .greenShade_5,
                                                      fontWeight:
                                                          FontWeight.w500))),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Row(
                                        children: [
                                          Text(
                                            'Current Value: ',
                                            style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    fontSize: 12 * scalefactor,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ),
                                          Text(currentAmount.toString(),
                                              style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      fontSize:
                                                          12 * scalefactor,
                                                      color: colordata.AppColors
                                                          .greenShade_5,
                                                      fontWeight:
                                                          FontWeight.w500))),
                                        ],
                                      ),
                                    ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
