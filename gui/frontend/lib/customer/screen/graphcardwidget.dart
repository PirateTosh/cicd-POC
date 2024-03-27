import 'package:flutter/material.dart';
import 'package:omegatron/customer/screen/app_color_data.dart' as colordata;
import 'package:omegatron/customer/screen/dashboard_models.dart';
import 'package:omegatron/customer/screen/datepickerexampe.dart';
import 'package:omegatron/customer/screen/line_graph_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class GraphCardWidget extends StatefulWidget {
  final List<GraphDataModel> lineChartData1_1;
  final List<GraphDataModel> lineChartData1_2;
  String cardHeading;
  GraphCardWidget(
      {required this.cardHeading,
      required this.lineChartData1_1,
      required this.lineChartData1_2,
      super.key});
  @override
  State<GraphCardWidget> createState() => _GraphCardWidget();
}

class _GraphCardWidget extends State<GraphCardWidget> {
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
    double screenWidth = MediaQuery.of(context).size.width;

    double textFontSize = calculateTextFontSize(screenWidth);
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colordata.AppColors.textPrimaryColor,
          borderRadius: BorderRadius.circular(24),
        ),
        height: widget.cardHeading == 'Satistics To Date'
            ? MediaQuery.of(context).size.height * 0.37
            : 237.9,
        padding: const EdgeInsets.all(0),
        child: AspectRatio(
          aspectRatio: 1.23,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 50, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          widget.cardHeading,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: textFontSize + 4,
                                  color: colordata.AppColors.secondaryColor)),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.07,
                            child: const Divider(
                              color: colordata.AppColors.dividerColor,
                              thickness: 4,
                            ),
                          ),
                          const SizedBox(width: 20),
                          DatePickerContainer(),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16, left: 6),
                    child: LineGraphWidget(
                        lineChartData1_1: widget.lineChartData1_1,
                        lineChartData1_2: widget.lineChartData1_2,
                        isShowingMainData:
                            widget.cardHeading == 'Satistics To Date'
                                ? true
                                : false),
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
