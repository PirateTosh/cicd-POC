// ignore_for_file: file_names

class XEquityLifeSnipeModel {
  final int coalIndiaValue;
  final int powerGridValue;

  final int investmentAmount;
  final int currentAmount;
  final String investmentProfitLossValue;
  final String currentAmountProfitLossValue;
  final int investmentProfitLossNumericValue;
  final int currentAmountProfitLossNumericValue;
  final List<double> investmentBarGraphData;
  final List<double> currentBarGraphData;

  List<dynamic> tableData;
  XEquityLifeSnipeModel({
    required this.coalIndiaValue,
    required this.powerGridValue,
    required this.currentAmount,
    required this.investmentAmount,
    required this.currentAmountProfitLossNumericValue,
    required this.currentAmountProfitLossValue,
    required this.investmentProfitLossNumericValue,
    required this.investmentProfitLossValue,
    required this.currentBarGraphData,
    required this.investmentBarGraphData,
    required this.tableData,
  });
  factory XEquityLifeSnipeModel.fromJson(Map<String, dynamic> json) {
    return XEquityLifeSnipeModel(
      coalIndiaValue: json['coal_India_Value'],
      powerGridValue: json['power_Grid_Value'],
      currentAmount: json['current_amount'],
      investmentAmount: json['investment_amount'],
      investmentProfitLossValue: json['investment_Profit_Loss_Value'],
      currentAmountProfitLossValue: json['current_Amount_Profit_Loss_Value'],
      investmentProfitLossNumericValue:
          json['investment_Profit_Loss_Numeric_Value'],
      currentAmountProfitLossNumericValue:
          json['current_Amount_Profit_Loss_Numeric_Value'],
      currentBarGraphData: json['current_Bar_Graph_Data'],
      investmentBarGraphData: json['investment_Bar_Graph_Data'],
      tableData: json['table_Data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coal_India_Value': coalIndiaValue,
      'power_Grid_Value': powerGridValue,
      'current_amount': currentAmount,
      'investment_amount': investmentAmount,
      'investment_Profit_Loss_Value': investmentProfitLossValue,
      'current_Amount_Profit_Loss_Value': currentAmountProfitLossValue,
      'investment_Profit_Loss_Numeric_Value': investmentProfitLossNumericValue,
      'current_Amount_Profit_Loss_Numeric_Value':
          currentAmountProfitLossNumericValue,
      'current_Bar_Graph_Data': currentBarGraphData,
      'investment_Bar_Graph_Data': investmentBarGraphData,
      'table_Data': tableData,
    };
  }
}
