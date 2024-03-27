class XEquityModel {
  final int position_1Value;
  final int position_2Value;
  final int position_3Value;
  final int position_4Value;
  final int position_5Value;
  final int position_6Value;
  final int position_7Value;
  final int position_8Value;
  final int position_9Value;
  final int position_10Value;
  final int investmentAmount;
  final int currentAmount;
  final String investmentProfitLossValue;
  final String currentAmountProfitLossValue;
  final int investmentProfitLossNumericValue;
  final int currentAmountProfitLossNumericValue;
  final List<double> investmentBarGraphData;
  final List<double> currentBarGraphData;

  List<dynamic> tableData;
  XEquityModel({
    required this.position_1Value,
    required this.position_2Value,
    required this.position_3Value,
    required this.position_4Value,
    required this.position_5Value,
    required this.position_6Value,
    required this.position_7Value,
    required this.position_8Value,
    required this.position_9Value,
    required this.position_10Value,
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
  factory XEquityModel.fromJson(Map<String, dynamic> json) {
    return XEquityModel(
      position_1Value: json['position_1_Value'],
      position_2Value: json['position_2_Value'],
      position_3Value: json['position_3_Value'],
      position_4Value: json['position_4_Value'],
      position_5Value: json['position_5_Value'],
      position_6Value: json['position_6_Value'],
      position_7Value: json['position_7_Value'],
      position_8Value: json['position_8_Value'],
      position_9Value: json['position_9_Value'],
      position_10Value: json['position_10_Value'],
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
      'position_1_Value': position_1Value,
      'position_2_Value': position_2Value,
      'position_3_Value': position_3Value,
      'position_4_Value': position_4Value,
      'position_5_Value': position_5Value,
      'position_6_Value': position_6Value,
      'position_7_Value': position_7Value,
      'position_8_Value': position_8Value,
      'position_9_Value': position_9Value,
      'position_10_Value': position_10Value,
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
