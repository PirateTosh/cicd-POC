import 'package:flutter/material.dart';
import 'package:omegatron/customer/screen/x_equity_model.dart';

class XEquityProvider extends ChangeNotifier {
  XEquityModel xEquityModelDetails = XEquityModel(
      position_1Value: 100000,
      position_2Value: 100000,
      position_3Value: 100000,
      position_4Value: 100000,
      position_5Value: 100000,
      position_6Value: 100000,
      position_7Value: 100000,
      position_8Value: 100000,
      position_9Value: 100000,
      position_10Value: 100000,
      currentAmount: 675000,
      investmentAmount: 500000,
      currentAmountProfitLossNumericValue: 35,
      currentAmountProfitLossValue: 'Loss',
      investmentProfitLossNumericValue: 76,
      investmentProfitLossValue: 'Profit',
      currentBarGraphData: [
        4.40,
        2.50,
        3.9,
        2.3,
        1.6,
        4.5,
        3.8
      ],
      investmentBarGraphData: [
        4.40,
        2.50,
        3.9,
        2.3,
        1.6,
        4.5,
        3.8
      ],
      tableData: [
        {
          "Count": "1",
          "Script Name": "NIFTY",
          "Spot": "21450",
          "Lot Size": "50",
          "Status": "BOUGHT",
          "Qty": "50",
          "Date": "15/1/2024"
        },
        {
          "Count": "2",
          "Script Name": "NIFTY",
          "Spot": "21450",
          "Lot Size": "50",
          "Status": "SOLD",
          "Qty": "50",
          "Date": "15/1/2024"
        },
        {
          "Count": "3",
          "Script Name": "NIFTY",
          "Spot": "21450",
          "Lot Size": "50",
          "Status": "BOUGHT",
          "Qty": "50",
          "Date": "15/1/2024"
        },
        {
          "Count": "4",
          "Script Name": "NIFTY",
          "Spot": "21450",
          "Lot Size": "50",
          "Status": "SOLD",
          "Qty": "50",
          "Date": "15/1/2024"
        },
        {
          "Count": "5",
          "Script Name": "NIFTY",
          "Spot": "21450",
          "Lot Size": "50",
          "Status": "BOUGHT",
          "Qty": "50",
          "Date": "15/1/2024"
        }
      ]);
  getxEquityModelDetails() async {
    notifyListeners();
  }
}
