class BaseModel {
  final String safetyNetProfitLossValue;
  final int safetyNetProfitLossNumericValue;
  final int safetyNetInvestmentAmount;
  final int safetyNetCurrentAmount;
  final List<Map<String, dynamic>> safetyNetList;
  final String xcfProfitLossValue;
  final int xcfProfitLossNumericValue;
  final int xcfInvestmentAmount;
  final int xcfCurrentAmount;
  final List<Map<String, dynamic>> xcfList;
  final List<Map<String, dynamic>> xEquityList;
  final List<Map<String, dynamic>> xmfList;
  final List<Map<String, dynamic>> xEquityLifeSnipeList;
  final String xmfProfitLossValue;
  final String xEquityProfitLossValue;
  final String xEquityLifeSnipeProfitLossValue;
  final int xmfProfitLossNumericValue;
  final int xEquityLifeSnipeProfitLossNumericValue;
  final int xEquityProfitLossNumericValue;
  final int xmfInvestmentAmount;
  final int xmfCurrentAmount;
  final int xEquityLifeSnipeInvestmentAmount;
  final int xEquityLifeSnipeCurrentAmount;
  final int xEquityInvestmentAmount;
  final int xEquityCurrentAmount;
  BaseModel({
    required this.safetyNetProfitLossValue,
    required this.safetyNetProfitLossNumericValue,
    required this.safetyNetCurrentAmount,
    required this.safetyNetInvestmentAmount,
    required this.safetyNetList,
    required this.xcfList,
    required this.xcfCurrentAmount,
    required this.xcfInvestmentAmount,
    required this.xcfProfitLossNumericValue,
    required this.xcfProfitLossValue,
    required this.xEquityLifeSnipeList,
    required this.xEquityList,
    required this.xmfList,
    required this.xEquityLifeSnipeProfitLossValue,
    required this.xEquityProfitLossValue,
    required this.xmfProfitLossValue,
    required this.xEquityLifeSnipeProfitLossNumericValue,
    required this.xEquityProfitLossNumericValue,
    required this.xmfProfitLossNumericValue,
    required this.xEquityCurrentAmount,
    required this.xEquityInvestmentAmount,
    required this.xEquityLifeSnipeCurrentAmount,
    required this.xEquityLifeSnipeInvestmentAmount,
    required this.xmfCurrentAmount,
    required this.xmfInvestmentAmount,
  });
  factory BaseModel.fromJson(Map<String, dynamic> json) {
    return BaseModel(
      safetyNetProfitLossValue: json['safety_net_profit_loss_value'],
      safetyNetProfitLossNumericValue:
          json['safety_net_Profit_Loss_Numeric_Value'],
      safetyNetCurrentAmount: json['safety_net_current_amount'],
      safetyNetInvestmentAmount: json['safety_net_investment_amount'],
      safetyNetList: json['safety_net_list'],
      xcfCurrentAmount: json['xcf_current_amount'],
      xcfInvestmentAmount: json['xcf_investment_amount'],
      xcfProfitLossNumericValue: json['xcf_profit_loss_numeric_value'],
      xcfProfitLossValue: json['xcf_profit_loss_value'],
      xcfList: json['xcf_list'],
      xEquityLifeSnipeList: json['x_Equity_Life_Snipe_List'],
      xEquityList: json['x_Equity_List'],
      xmfList: json['xmf_List'],
      xEquityLifeSnipeProfitLossValue:
          json['x_Equity_Life_Snipe_Profit_Loss_Value'],
      xEquityProfitLossValue: json['x_Equity_Profit_Loss_Value'],
      xmfProfitLossValue: json['xmf_Profit_Loss_Value'],
      xmfProfitLossNumericValue: json['xmf_Profit_Loss_Numeric_Value'],
      xEquityProfitLossNumericValue: json['x_Equity_Profit_Loss_Numeric_Value'],
      xEquityLifeSnipeProfitLossNumericValue:
          json['x_Equity_Life_Snipe_Profit_Loss_Numeric_Value'],
      xEquityCurrentAmount: json['x_Equity_Current_Amount'],
      xEquityInvestmentAmount: json['x_Equity_Investment_Amount'],
      xEquityLifeSnipeCurrentAmount: json['x_Equity_Life_Snipe_Current_Amount'],
      xEquityLifeSnipeInvestmentAmount:
          json['x_Equity_Life_Snipe_Investment_Amount'],
      xmfCurrentAmount: json['xmf_Current_Amount'],
      xmfInvestmentAmount: json['xmf_Investment_Amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'safety_net_profit_loss_value': safetyNetProfitLossValue,
      'safety_net_Profit_Loss_Numeric_Value': safetyNetProfitLossNumericValue,
      'safety_net_current_amount': safetyNetCurrentAmount,
      'safety_net_investment_amount': safetyNetInvestmentAmount,
      'safety_net_list': safetyNetList,
      'xcf_current_amount': xcfCurrentAmount,
      'xcf_investment_amount': xcfInvestmentAmount,
      'xcf_profit_loss_numeric_value': xcfProfitLossNumericValue,
      'xcf_profit_loss_value': xcfProfitLossValue,
      'xcf_list': xcfList,
      'x_Equity_Life_Snipe_List': xEquityLifeSnipeList,
      'x_Equity_List': xEquityList,
      'xmf_List': xmfList,
      'x_Equity_Life_Snipe_Profit_Loss_Value': xEquityLifeSnipeProfitLossValue,
      'x_Equity_Profit_Loss_Value': xEquityProfitLossValue,
      'xmf_Profit_Loss_Value': xmfProfitLossValue,
      'xmf_Profit_Loss_Numeric_Value': xmfProfitLossNumericValue,
      'x_Equity_Profit_Loss_Numeric_Value': xEquityProfitLossNumericValue,
      'x_Equity_Life_Snipe_Profit_Loss_Numeric_Value':
          xEquityLifeSnipeProfitLossNumericValue,
      'x_Equity_Current_Amount': xEquityCurrentAmount,
      'x_Equity_Investment_Amount': xEquityInvestmentAmount,
      'x_Equity_Life_Snipe_Current_Amount': xEquityLifeSnipeCurrentAmount,
      'x_Equity_Life_Snipe_Investment_Amount': xEquityLifeSnipeInvestmentAmount,
      'xmf_Current_Amount': xmfCurrentAmount,
      'xmf_Investment_Amount': xmfInvestmentAmount
    };
  }
}
