import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omegatron/customer/screen/app_color_data.dart' as colordata;

class LineChartWidget extends StatefulWidget {
  final List<double> lineGraphData;
  const LineChartWidget({required this.lineGraphData, super.key});

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  List<LineChartBarData> getLineGraphBarData() {
    List<FlSpot> spots = [];
    List<double> xAxisValue = [0, 2, 4, 6, 8];
    for (int i = 0; i < widget.lineGraphData.length; i++) {
      spots.add(FlSpot(xAxisValue[i], widget.lineGraphData[i]));
    }

    return [
      LineChartBarData(
        color: colordata.AppColors.textPrimaryColor,
        isCurved: true,
        spots: spots,
        barWidth: 6,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
      ),
    ];
  }
  // List<LineChartBarData> linegraphBarData = [
  //   LineChartBarData(
  //     color: colordata.AppColors.textPrimaryColor,
  //     isCurved: true,
  //     spots: spots,
  //     barWidth: 6,
  //     isStrokeCapRound: true,
  //     dotData: FlDotData(show: false),
  //     belowBarData: BarAreaData(show: false),
  //   )
  // ];

  @override
  Widget build(BuildContext context) {
    return LineChart(LineChartData(
      borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(
                color: colordata.AppColors.textPrimaryColor, width: 1.2),
          )),
      gridData: FlGridData(
          drawHorizontalLine: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: colordata.AppColors.textPrimaryColor,
              strokeWidth: 1.2,
            );
          },
          drawVerticalLine: false,
          horizontalInterval: 1),
      titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(
              sideTitles: SideTitles(
            showTitles: false,
          )),
          topTitles: AxisTitles(
              sideTitles: SideTitles(
            showTitles: false,
          )),
          bottomTitles: AxisTitles(
            sideTitles: bottomTitles,
          ),
          leftTitles: AxisTitles(
              sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            reservedSize: 30,
            getTitlesWidget: (double value, TitleMeta meta) {
              String text;
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
                  text = '50k';
                  break;
                // Add more cases as needed
                default:
                  return Container();
              }
              return Text(text,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: colordata.AppColors.textPrimaryColor,
                    ),
                  ));
            },
          ))),
      minX: 0,
      minY: 0,
      maxX: 8,
      maxY: 4,
      backgroundColor: Colors.transparent,
      lineBarsData: getLineGraphBarData(),
    ));
  }
}

SideTitles get bottomTitles => SideTitles(
      showTitles: true,
      reservedSize: 32,
      interval: 1,
      getTitlesWidget: bottomTitleWidgets,
    );

Widget bottomTitleWidgets(double value, TitleMeta meta) {
  Widget text;
  final style = GoogleFonts.montserrat(
    textStyle: const TextStyle(color: colordata.AppColors.textPrimaryColor),
    fontWeight: FontWeight.w700,
    fontSize: 12,
  );
  switch (value.toInt()) {
    case 0:
      text = Text('M', style: style);
      break;
    case 2:
      text = Text('T', style: style);
      break;
    case 4:
      text = Text('W', style: style);
      break;
    case 6:
      text = Text('T', style: style);
      break;
    case 8:
      text = Text('F', style: style);
      break;

    default:
      text = const Text('');
      break;
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 10,
    child: text,
  );
}
