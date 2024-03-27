import 'package:flutter/material.dart';
import 'package:omegatron/customer/screen/base_model.dart';

class BaseProvider extends ChangeNotifier {
  BaseModel baseModelDetails = BaseModel(
      safetyNetProfitLossValue: 'Gains',
      safetyNetProfitLossNumericValue: 35,
      safetyNetCurrentAmount: 675000,
      safetyNetInvestmentAmount: 500000,
      safetyNetList: [
        {'key': 'FD :', 'value': 10000},
        {'key': 'Metals :', 'value': 20000},
        {'key': 'Bonds :', 'value': 30000},
      ],
      xcfCurrentAmount: 500000,
      xcfInvestmentAmount: 675000,
      xcfProfitLossNumericValue: 15,
      xcfProfitLossValue: 'Loss',
      xcfList: [
        {'key': 'BAF :', 'value': 100000},
        {'key': 'Arbitrage Fund :', 'value': 200000},
      ],
      xEquityLifeSnipeList: [
        {'key': 'Coal India :', 'value': 100000},
        {'key': 'Power Grid :', 'value': 200000},
      ],
      xEquityList: [
        {'key': 'Position 1 :', 'value': 100000},
        {'key': 'Position 2 :', 'value': 200000},
        {'key': 'Position 3 :', 'value': 200000},
        {'key': 'Position 4 :', 'value': 200000},
        {'key': 'Position 5 :', 'value': 200000},
      ],
      xmfList: [
        {'key': 'Liquid Funds :', 'value': 10000},
        {'key': 'Index Funds :', 'value': 20000},
        {'key': 'Mid Cap Fund :', 'value': 30000},
        {'key': 'Small Cap Fund :', 'value': 30000},
        {'key': 'International Fund :', 'value': 30000},
      ],
      xEquityLifeSnipeProfitLossValue: 'Gains',
      xEquityProfitLossValue: 'Gains',
      xmfProfitLossValue: 'Gains',
      xEquityLifeSnipeProfitLossNumericValue: 65,
      xEquityProfitLossNumericValue: 65,
      xmfProfitLossNumericValue: 55,
      xEquityCurrentAmount: 675000,
      xEquityInvestmentAmount: 500000,
      xEquityLifeSnipeCurrentAmount: 675000,
      xEquityLifeSnipeInvestmentAmount: 500000,
      xmfCurrentAmount: 675000,
      xmfInvestmentAmount: 500000);
  getbaseModelDetails() async {
    notifyListeners();
  }
}
