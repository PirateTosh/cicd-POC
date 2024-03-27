import 'package:omegatron/customer/screen/dashboard_models.dart';

class AnalyticsModel {
  final String xCrashFundProfitLossValue;
  final int xCrashFundProfitLossNumericValue;
  final String xLifeSnipeProfitLossValue;
  final int xLifeSnipeProfitLossNumericValue;
  final String deltaCyclingProfitLossValue;
  final int deltaCyclingProfitLossNumericValue;
  final List<double> deltaCyclingLineGraphData;
  final List<double> xLifeSnipeLineGraphData;
  final List<double> xCrashFundLineGraphData;
  final List<GraphDataModel> lineChartData1_1;
  final List<GraphDataModel> lineChartData1_2;

  AnalyticsModel(
      {required this.xCrashFundProfitLossValue,
      required this.xCrashFundProfitLossNumericValue,
      required this.xLifeSnipeProfitLossValue,
      required this.xLifeSnipeProfitLossNumericValue,
      required this.deltaCyclingProfitLossValue,
      required this.deltaCyclingProfitLossNumericValue,
      required this.deltaCyclingLineGraphData,
      required this.xLifeSnipeLineGraphData,
      required this.xCrashFundLineGraphData,
      required this.lineChartData1_1,
      required this.lineChartData1_2});
  factory AnalyticsModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsModel(
        xCrashFundProfitLossValue: json['x_crash_fund_profit_loss_value'],
        xCrashFundProfitLossNumericValue:
            json['x_crash_fund_profit_loss_numeric_value'],
        xLifeSnipeProfitLossValue: json['x_Life_Snipe_Profit_Loss_Value'],
        xLifeSnipeProfitLossNumericValue:
            json['x_Life_Snipe_Profit_Loss_Numeric_Value'],
        deltaCyclingProfitLossValue: json['delta_Cycling_Profit_Loss_Value'],
        deltaCyclingProfitLossNumericValue:
            json['delta_Cycling_Profit_Loss_Numeric_Value'],
        deltaCyclingLineGraphData: json['delta_Cycling_Line_Graph_Data'],
        xLifeSnipeLineGraphData: json['x_Life_Snipe_Line_Graph_Data'],
        xCrashFundLineGraphData: json['x_Crash_Fund_Line_Graph_Data'],
        lineChartData1_1: json['line_Chart_Data_1_1'],
        lineChartData1_2: json['line_Chart_Data_1_2']);
  }

  Map<String, dynamic> toJson() {
    return {
      'x_crash_fund_profit_loss_value': xCrashFundProfitLossValue,
      'x_crash_fund_profit_loss_numeric_value':
          xCrashFundProfitLossNumericValue,
      'x_Life_Snipe_Profit_Loss_Value': xLifeSnipeProfitLossValue,
      'x_Life_Snipe_Profit_Loss_Numeric_Value':
          xLifeSnipeProfitLossNumericValue,
      'delta_Cycling_Profit_Loss_Value': deltaCyclingProfitLossValue,
      'delta_Cycling_Profit_Loss_Numeric_Value':
          deltaCyclingProfitLossNumericValue,
      'delta_Cycling_Line_Graph_Data': deltaCyclingLineGraphData,
      'x_Life_Snipe_Line_Graph_Data': xLifeSnipeLineGraphData,
      'x_Crash_Fund_Line_Graph_Data': xCrashFundLineGraphData,
      'line_Chart_Data_1_1': lineChartData1_1,
      'line_Chart_Data_1_2': lineChartData1_2
    };
  }
}
