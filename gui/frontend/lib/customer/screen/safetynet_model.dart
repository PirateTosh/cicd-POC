class SafetynetModel {
  final int fdValue;
  final int metalValue;
  final int bondsValue;
  final int investmentAmount;
  final int currentAmount;
  final String investmentProfitLossValue;
  final String currentAmountProfitLossValue;
  final int investmentProfitLossNumericValue;
  final int currentAmountProfitLossNumericValue;
  final List<double> investmentBarGraphData;
  final List<double> currentBarGraphData;

  List<dynamic> tableData;
  SafetynetModel({
    required this.bondsValue,
    required this.fdValue,
    required this.metalValue,
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
  factory SafetynetModel.fromJson(Map<String, dynamic> json) {
    return SafetynetModel(
      fdValue: json['fd_value'],
      bondsValue: json['bonds_value'],
      metalValue: json['metal_value'],
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
      'fd_value': fdValue,
      'bonds_value': bondsValue,
      'metal_value': metalValue,
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
