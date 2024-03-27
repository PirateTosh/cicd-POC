import 'package:flutter/material.dart';
import 'package:omegatron/customer/screen/bar_graph_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omegatron/customer/screen/app_color_data.dart' as colordata;

class CardsWidget extends StatelessWidget {
  String profitlossvalue;
  int profitlossnumericvalue;
  List<double> barGraphData;

  CardsWidget(
      {required this.profitlossnumericvalue,
      required this.profitlossvalue,
      required this.barGraphData,
      super.key});
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    Color color = profitlossvalue == 'Profit'
        ? colordata.AppColors.greenShade_5
        : colordata.AppColors.redColor;
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * 0.17,
        decoration: BoxDecoration(
          gradient: colordata.AppColors.cardsGradient,
          borderRadius: const BorderRadius.all(Radius.circular(24)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(profitlossvalue,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                              fontSize: 16 * screenWidth / 1440,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                              color: colordata.AppColors.textPrimaryColor))),
                  Row(
                    children: [
                      Text(
                        "R O I  ",
                        style: TextStyle(
                            color: colordata.AppColors.textPrimaryColor,
                            fontSize: 16 * screenWidth / 1440,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        ' $profitlossnumericvalue%',
                        style: TextStyle(
                            color: color,
                            fontSize: 16 * screenWidth / 1440,
                            fontWeight: FontWeight.w800),
                      ),
                    ],
                  )
                ],
              ),
              Expanded(
                  flex: 5,
                  child: BarGraphWidget(
                    barGraphData: barGraphData,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
