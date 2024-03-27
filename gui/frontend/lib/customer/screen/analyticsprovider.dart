import 'package:flutter/material.dart';
import 'package:omegatron/customer/screen/analytics_model.dart';
import 'package:omegatron/customer/screen/dashboard_models.dart';

class AnalyticsProvider extends ChangeNotifier {
  int _selectedScreen = 0;
  AnalyticsModel analyticsModelDetails = AnalyticsModel(
      xCrashFundProfitLossValue: 'Gains',
      xCrashFundProfitLossNumericValue: 65,
      xLifeSnipeProfitLossValue: 'Gains',
      xLifeSnipeProfitLossNumericValue: 65,
      deltaCyclingProfitLossValue: 'Gains',
      deltaCyclingProfitLossNumericValue: 65,
      deltaCyclingLineGraphData: [
        0,
        2,
        1,
        3
      ],
      xLifeSnipeLineGraphData: [
        0,
        2,
        1,
        3
      ],
      xCrashFundLineGraphData: [
        0,
        2,
        1,
        3
      ],
      lineChartData1_1: [
        GraphDataModel(0, 1),
        GraphDataModel(3, 1.5),
        GraphDataModel(5, 1.4),
        GraphDataModel(7, 3.4),
        GraphDataModel(10, 2),
        GraphDataModel(12, 2.2),
        GraphDataModel(13, 1.8),
      ],
      lineChartData1_2: [
        GraphDataModel(0, 1),
        GraphDataModel(3, 2.8),
        GraphDataModel(7, 1.2),
        GraphDataModel(10, 2.8),
        GraphDataModel(12, 2.6),
        GraphDataModel(13, 3.9),
      ]);
  int get selectedScreen {
    return _selectedScreen;
  }

  setSelectedScreen(int value) {
    _selectedScreen = value;

    notifyListeners();
  }

  getanalyticsModelDetails() async {
    notifyListeners();
  }
}
