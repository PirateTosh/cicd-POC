import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:omegatron/customer/screen/page_header.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:badges/badges.dart' as badges;
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:omegatron/common/constants/assets_constant.dart';
import 'package:omegatron/customer/screen/app_color_data.dart' as colordata;

class Ride extends StatefulWidget {
  bool isRidePage;
  final int baseridebreadcrumchangevalue;
  final void Function(dynamic, int, Function(int)) addToBreadCrum;
  final List<BreadCrumbItem> breadcrumbList;
  final Function(int) setSelectedScreen;
  Ride(
      {Key? key,
      required this.addToBreadCrum,
      required this.isRidePage,
      required this.baseridebreadcrumchangevalue,
      required this.breadcrumbList,
      required this.setSelectedScreen});

  @override
  State<Ride> createState() => _RideState();
}

class _RideState extends State<Ride> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    double cardWidth = screenSize.width * 0.45;
    double cardHeight = screenSize.height * 0.45;
    final double screenWidth = MediaQuery.of(context).size.width;
    double scaleFactor = screenWidth / 1440; // Assuming 1440 is the base width

    // You can adjust these values according to your requirements
    if (screenSize.width <= 1440 && screenSize.width > 1024) {
      cardWidth = screenSize.width * 0.26;
      cardHeight = screenSize.height * 0.42;
    } else if (screenSize.width <= 1024) {
      cardWidth = screenSize.width * 0.26;
      scaleFactor = screenWidth / screenSize.width;
      cardHeight = screenSize.height * 0.50;
    }

    return Scaffold(
      backgroundColor: colordata.AppColors.primaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 15, 0, 0),
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
              pageTitle: 'Ride',
              value: 1,
              breadcrumbList: widget.breadcrumbList,
              baseridebreadcrumchangevalue2:
                  widget.baseridebreadcrumchangevalue,
              baseridebreadcrumchangevalue: 2,
              breadCrumImage: AssetsConstants.analytics,
              setSelectedScreen: widget.setSelectedScreen,
              isBasePage: false,
              isRidePage: true,
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
                      _buildCard('MB 1 (Y-Index)', 500000, 525000, () {
                        // Navigate to the desired page when this card is clicked
                        Navigator.pushNamed(context, '/page1');
                      }, scaleFactor, context, colordata.AppColors.greenShade_2,
                          'Gains', '+65%'),
                      _buildCard('Delta Cycling (Y-Index)', 500000, 525000, () {
                        // Navigate to the desired page when this card is clicked
                        Navigator.pushNamed(context, '/page2');
                      }, scaleFactor, context, colordata.AppColors.greenShade_2,
                          'Gains', '+65%'),
                      _buildCard('MB 1 (Y-Commodities)', 500000, 525000, () {
                        // Navigate to the desired page when this card is clicked
                        Navigator.pushNamed(context, '/page3');
                      }, scaleFactor, context, colordata.AppColors.redColor,
                          'Loss', '-35%'),
                      _buildCard('MB 2 (Y-Index)', 500000, 525000, () {
                        // Navigate to the desired page when this card is clicked
                        Navigator.pushNamed(context, '/page4');
                      }, scaleFactor, context, colordata.AppColors.greenShade_2,
                          'Gains', '+65%'),
                      _buildCard('Expiry Trader (Y-Index)', 500000, 525000, () {
                        // Navigate to the desired page when this card is clicked
                        Navigator.pushNamed(context, '/page5');
                      }, scaleFactor, context, colordata.AppColors.greenShade_2,
                          'Gains', '+65%'),
                      _buildCard('Y-Equity (option trade)', 500000, 525000, () {
                        // Navigate to the desired page when this card is clicked
                        Navigator.pushNamed(context, '/page6');
                      }, scaleFactor, context, colordata.AppColors.greenShade_2,
                          'Gains', '+65%'),
                      _buildCard('FVPS', 500000, 525000, () {
                        // Navigate to the desired page when this card is clicked
                        Navigator.pushNamed(context, '/page7');
                      }, scaleFactor, context, colordata.AppColors.greenShade_2,
                          'Gains', '+65%'),
                      _buildCard('DPVS', 500000, 525000, () {
                        // Navigate to the desired page when this card is clicked
                        Navigator.pushNamed(context, '/page8');
                      }, scaleFactor, context, colordata.AppColors.greenShade_2,
                          'Gains', '+65%'),
                      _buildCard('Future Snipe', 500000, 525000, () {
                        // Navigate to the desired page when this card is clicked
                        Navigator.pushNamed(context, '/page9');
                      }, scaleFactor, context, colordata.AppColors.greenShade_2,
                          'Gains', '+65%'),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
      String name,
      int value,
      int cvalue,
      Function() onTap,
      double scalefactor,
      BuildContext context,
      Color color,
      String gainAndLossValue,
      String gainAndLossNumericValue) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.24,
          height: MediaQuery.of(context).size.height * 0.27,
          child: Column(
            children: [
              Container(
                height: 13.0,
                decoration: const BoxDecoration(
                    color: colordata.AppColors.blueShade_2,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.0),
                      topRight: Radius.circular(24.0),
                    )),
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
                    child: Column(
                      children: [
                        Expanded(
                          flex: 8,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 6,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 0, 0, 0),
                                  child: Text(
                                    name,
                                    style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                            fontSize: 16 * scalefactor,
                                            fontWeight: FontWeight.w500)),
                                  ),
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
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              gainAndLossValue,
                                              style: GoogleFonts.montserrat(
                                                textStyle: TextStyle(
                                                  color: colordata.AppColors
                                                      .textPrimaryColor,
                                                  fontSize: 12 *
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      1440,
                                                ),
                                              ),
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
                                            child: CircularPercentIndicator(
                                              radius: 55 *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1440,
                                              lineWidth: 3.0 *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1440,
                                              percent: 0.65,
                                              center: Text(
                                                gainAndLossNumericValue,
                                                style: TextStyle(
                                                  fontSize: 14 *
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      1440,
                                                  color: color,
                                                ),
                                              ),
                                              footer: Column(
                                                children: [
                                                  SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.05,
                                                      child: gainAndLossValue ==
                                                              'Loss'
                                                          ? SvgPicture.asset(
                                                              AssetsConstants
                                                                  .lossicon,
                                                              fit: BoxFit
                                                                  .contain,
                                                            )
                                                          : SvgPicture.asset(
                                                              AssetsConstants
                                                                  .gainicon,
                                                              fit: BoxFit
                                                                  .contain,
                                                            )),
                                                  Text(
                                                    gainAndLossNumericValue,
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      textStyle: TextStyle(
                                                        fontSize: 11,
                                                        color: color,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      "ROI",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        textStyle:
                                                            const TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              progressColor: color,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                        Text(value.toString(),
                                            style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    fontSize: 12 * scalefactor,
                                                    color: colordata
                                                        .AppColors.greenShade_5,
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
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                        Text(value.toString(),
                                            style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    fontSize: 12 * scalefactor,
                                                    color: colordata
                                                        .AppColors.greenShade_5,
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
    );
  }
}
