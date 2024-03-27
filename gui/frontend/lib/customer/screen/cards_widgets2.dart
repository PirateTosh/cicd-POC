import 'package:flutter/material.dart';
import 'package:omegatron/customer/screen/bar_graph_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:badges/badges.dart' as badges;
import 'package:omegatron/customer/screen/app_color_data.dart' as colordata;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:omegatron/common/constants/assets_constant.dart';
import 'package:omegatron/customer/screen/linechartwidget.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CardsWidget2 extends StatelessWidget {
  bool dashboardPageCard;
  bool graphshow;
  String title;
  String profitlossvalue;
  int profitlossnumericvalue;
  List<double> graphData;

  CardsWidget2(
      {required this.graphshow,
      required this.dashboardPageCard,
      required this.title,
      required this.graphData,
      required this.profitlossnumericvalue,
      required this.profitlossvalue,
      super.key});
  double calculateTextFontSize(double screenWidth) {
    // You can adjust these values based on your preferences
    if (screenWidth < 600) {
      return 14.0;
    } else if (screenWidth <= 1500) {
      return 18.0;
    } else {
      return 26.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    String profitLossSign = profitlossvalue == 'Gains' ? '+' : '-';
    String profitLossformattedText =
        '${profitLossSign} ${profitlossnumericvalue} %';
    double screenWidth = MediaQuery.of(context).size.width;
    double textFontSize = calculateTextFontSize(screenWidth);
    double cardMinWidth;
    double cardMaxWidth;
    double cardMinHeight;
    double cardMaxHeight;

    if (dashboardPageCard) {
      cardMinWidth = MediaQuery.of(context).size.width * 0.2;
      cardMaxWidth = MediaQuery.of(context).size.width * 0.22;
      cardMinHeight = 200;
      cardMaxHeight = MediaQuery.of(context).size.height * 0.37 > 200
          ? MediaQuery.of(context).size.height * 0.37
          : 200;
    } else {
      cardMinWidth = MediaQuery.of(context).size.width * 0.2;
      cardMaxWidth = MediaQuery.of(context).size.width * 0.24;
      cardMinHeight = 200;
      cardMaxHeight = MediaQuery.of(context).size.height * 0.39 > 200
          ? MediaQuery.of(context).size.height * 0.39
          : 200;
    }
    return Flexible(
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          constraints: BoxConstraints(
            minWidth: cardMinWidth,
            maxWidth: cardMaxWidth,
            maxHeight: cardMaxHeight,
            minHeight: cardMinHeight,
          ),
          decoration: BoxDecoration(
            gradient: colordata.AppColors.cardsGradient,
            borderRadius: const BorderRadius.all(Radius.circular(24)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(title,
                                  style: TextStyle(
                                    color: colordata.AppColors.textPrimaryColor,
                                    fontSize: textFontSize - 2,
                                  )),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.005),
                            FittedBox(
                              child: RichText(
                                  text: TextSpan(
                                      text: "R O I  ",
                                      style: TextStyle(
                                        color: colordata
                                            .AppColors.textPrimaryColor,
                                        fontSize: textFontSize - 2,
                                      ),
                                      children: <TextSpan>[
                                    TextSpan(
                                        text: profitLossformattedText,
                                        style: TextStyle(
                                            color: profitlossvalue == 'Loss'
                                                ? colordata.AppColors.redColor
                                                : colordata
                                                    .AppColors.greenShade_2,
                                            fontSize: textFontSize - 2,
                                            fontWeight: FontWeight.w600)),
                                  ])),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                          flex: 3,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: FittedBox(
                              child: badges.Badge(
                                badgeContent: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                    profitlossvalue,
                                    style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                      fontSize: textFontSize - 4,
                                      color:
                                          colordata.AppColors.textPrimaryColor,
                                    )),
                                  ),
                                ),
                                position: badges.BadgePosition.topStart(
                                    top: 2, start: -17),
                                badgeStyle: badges.BadgeStyle(
                                    badgeColor: profitlossvalue == 'Loss'
                                        ? colordata.AppColors.redColor
                                        : colordata.AppColors.greenShade_2,
                                    elevation: 4,
                                    shape: badges.BadgeShape.square,
                                    padding: const EdgeInsets.all(2),
                                    borderRadius: BorderRadius.circular(3)),
                                child: FittedBox(
                                  child: CircularPercentIndicator(
                                    radius: MediaQuery.of(context).size.width *
                                        0.060,
                                    lineWidth:
                                        MediaQuery.of(context).size.width *
                                            0.004,
                                    percent: 0.65,
                                    center: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        '${profitlossnumericvalue}%',
                                        style: TextStyle(
                                          fontSize: textFontSize + 2,
                                          color: colordata
                                              .AppColors.textPrimaryColor,
                                        ),
                                      ),
                                    ),
                                    footer: profitlossvalue == 'Loss'
                                        ? SvgPicture.asset(
                                            AssetsConstants.lossicon,
                                            fit: BoxFit.contain,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.04,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.04,
                                          )
                                        : SvgPicture.asset(
                                            AssetsConstants.gainicon,
                                            fit: BoxFit.contain,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.04,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.04,
                                          ),
                                    progressColor: profitlossvalue == 'Loss'
                                        ? colordata.AppColors.redColor
                                        : colordata.AppColors.greenShade_2,
                                  ),
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
                Expanded(
                    flex: 7,
                    child: graphshow
                        ? LineChartWidget(lineGraphData: graphData)
                        : BarGraphWidget(barGraphData: graphData))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
