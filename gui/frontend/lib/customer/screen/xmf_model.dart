class XmfModel {
  final int liquidFundValue;
  final int indexFundValue;
  final int midCapFundValue;
  final int smallCapFundValue;
  final int internationalFundValue;
  final int investmentAmount;
  final int currentAmount;
  final String investmentProfitLossValue;
  final String currentAmountProfitLossValue;
  final int investmentProfitLossNumericValue;
  final int currentAmountProfitLossNumericValue;
  final List<double> investmentBarGraphData;
  final List<double> currentBarGraphData;

  List<dynamic> tableData;
  XmfModel({
    required this.liquidFundValue,
    required this.indexFundValue,
    required this.midCapFundValue,
    required this.smallCapFundValue,
    required this.internationalFundValue,
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
  factory XmfModel.fromJson(Map<String, dynamic> json) {
    return XmfModel(
      liquidFundValue: json['liquid_Fund_Value'],
      indexFundValue: json['index_Fund_Value'],
      midCapFundValue: json['mid_cap_Fund_Value'],
      smallCapFundValue: json['small_cap_Fund_Value'],
      internationalFundValue: json['international_Fund_Value'],
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
      'liquid_Fund_Value': liquidFundValue,
      'index_Fund_Value': indexFundValue,
      'mid_cap_Fund_Value': midCapFundValue,
      'small_cap_Fund_Value': smallCapFundValue,
      'international_Fund_Value': internationalFundValue,
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
