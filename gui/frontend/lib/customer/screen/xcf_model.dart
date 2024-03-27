class XcfModel {
  final int bafValue;
  final int arbitaryFundValue;

  final int investmentAmount;
  final int currentAmount;
  final String investmentProfitLossValue;
  final String currentAmountProfitLossValue;
  final int investmentProfitLossNumericValue;
  final int currentAmountProfitLossNumericValue;
  final List<double> investmentBarGraphData;
  final List<double> currentBarGraphData;

  List<dynamic> tableData;
  XcfModel({
    required this.bafValue,
    required this.arbitaryFundValue,
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
  factory XcfModel.fromJson(Map<String, dynamic> json) {
    return XcfModel(
      bafValue: json['baf_Value'],
      arbitaryFundValue: json['arbitary_Fund_Value'],
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
      'baf_Value': bafValue,
      'arbitary_Fund_Value': arbitaryFundValue,
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
