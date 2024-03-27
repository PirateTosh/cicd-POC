import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:omegatron/customer/screen/app_color_data.dart' as colordata;

class BarGraphWidget extends StatefulWidget {
  final List<double> barGraphData;
  const BarGraphWidget({required this.barGraphData, super.key});
  @override
  State<BarGraphWidget> createState() => _BarGraphWidget();
}

class _BarGraphWidget extends State<BarGraphWidget> {
  final Color barColor = colordata.AppColors.textPrimaryColor;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    BarData mybarData = BarData(
      mon: widget.barGraphData[0],
      tue: widget.barGraphData[1],
      wed: widget.barGraphData[2],
      thru: widget.barGraphData[3],
      fri: widget.barGraphData[4],
      sat: widget.barGraphData[5],
      sun: widget.barGraphData[6],
    );
    mybarData.initialzedBarData();
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
            constraints: const BoxConstraints.tightFor(),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: BarChart(BarChartData(
              alignment: BarChartAlignment.spaceBetween,
              maxY: 5,
              minY: 0,
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(show: false),
              barGroups: mybarData.barData
                  .map((data) => BarChartGroupData(x: data.x, barRods: [
                        BarChartRodData(
                          toY: data.y,
                          color: colordata.AppColors.textPrimaryColor,
                          width: 16 * screenWidth / 1440,
                        )
                      ]))
                  .toList(),
            ))));
  }
}

class IndividualBar {
  final x;
  final double y;
  IndividualBar({required this.x, required this.y});
}

class BarData {
  final double mon;
  final double tue;
  final double wed;
  final double thru;
  final double fri;
  final double sat;
  final double sun;
  BarData(
      {required this.mon,
      required this.tue,
      required this.wed,
      required this.thru,
      required this.fri,
      required this.sat,
      required this.sun});
  List<IndividualBar> barData = [];
  void initialzedBarData() {
    barData = [
      IndividualBar(x: 0, y: mon),
      IndividualBar(x: 0, y: tue),
      IndividualBar(x: 0, y: wed),
      IndividualBar(x: 0, y: thru),
      IndividualBar(x: 0, y: fri),
      IndividualBar(x: 0, y: sat),
      IndividualBar(x: 0, y: sun),
    ];
  }
}
