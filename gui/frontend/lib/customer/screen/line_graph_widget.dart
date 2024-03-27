import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omegatron/customer/screen/app_color_data.dart' as colordata;
import 'package:omegatron/customer/screen/dashboard_models.dart';

class LineGraphWidget extends StatelessWidget {
  final List<GraphDataModel> lineChartData1_1;
  final List<GraphDataModel> lineChartData1_2;
  const LineGraphWidget(
      {required this.isShowingMainData,
      required this.lineChartData1_1,
      required this.lineChartData1_2,
      super.key});

  final bool isShowingMainData;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return LineChart(LineChartData(
      lineTouchData: lineTouchData1,
      gridData: gridData,
      titlesData: titlesData1(screenWidth, isShowingMainData),
      borderData: borderData,
      lineBarsData: lineBarsData1,
      minX: 0,
      maxX: 14,
      maxY: 4,
      minY: 0,
    ));
  }

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData titlesData1(double screenWidth, bool isShowingMainData) =>
      FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles(screenWidth),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(screenWidth, isShowingMainData),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
        lineChartBarData1_2,
      ];

  Widget leftTitleWidgets(double value, TitleMeta meta, double screenWidth,
      bool isShowingMainData) {
    String text;
    if (isShowingMainData) {
      switch (value.toInt()) {
        case 0:
          text = '23Jan';
          break;
        case 1:
          text = '23Jan';
          break;
        case 2:
          text = '23Jan';
          break;
        case 3:
          text = '23Jan';
          break;
        default:
          return const SizedBox.shrink();
      }
    } else {
      switch (value.toInt()) {
        case 0:
          text = '5k';
          break;
        case 1:
          text = '10k';
          break;
        case 2:
          text = '15k';
          break;
        case 3:
          text = '20k';
          break;
        default:
          return const SizedBox.shrink();
      }
    }
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(text,
          maxLines: 1,
          style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
            color: colordata.AppColors.greyShade_2,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          )),
          textAlign: TextAlign.center),
    );
  }

  SideTitles leftTitles(double screenWidth, bool isShowingMainData) =>
      SideTitles(
        getTitlesWidget: (double value, TitleMeta meta) =>
            leftTitleWidgets(value, meta, screenWidth, isShowingMainData),
        showTitles: true,
        interval: 1,
        reservedSize: screenWidth * 0.05,
      );
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    String text;

    switch (value.toInt()) {
      case 1:
        text = '23Jan';
        break;
      case 3:
        text = '23Jan';
        break;
      case 5:
        text = '23Jan';
        break;
      case 7:
        text = '23Jan';
        break;
      case 9:
        text = '23Jan';
        break;
      case 11:
        text = '23Jan';
        break;
      case 13:
        text = '23Jan';
        break;

      default:
        return const SizedBox.shrink();
    }

    return FittedBox(
      fit: BoxFit.contain,
      child: Text(text,
          style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
            color: colordata.AppColors.greyShade_2,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          )),
          textAlign: TextAlign.center),
    );
  }

  SideTitles bottomTitles(double screenWidth) => SideTitles(
        showTitles: true,
        reservedSize: screenWidth * 0.015,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => FlGridData(
        drawHorizontalLine: true,
        horizontalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: colordata.AppColors.greyShade_2,
            strokeWidth: 1.5,
          );
        },
        drawVerticalLine: false,
      );

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
          bottom:
              BorderSide(color: colordata.AppColors.greyShade_2, width: 1.5),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        color: const Color(0xFFE6E6E6),
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: lineChartData1_1.map((data) => FlSpot(data.x, data.y)).toList(),
      );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: true,
        color: colordata.AppColors.blueShade_5,
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData:
            BarAreaData(show: false, color: colordata.AppColors.redColor),
        spots: lineChartData1_2.map((data) => FlSpot(data.x, data.y)).toList(),
      );
}
