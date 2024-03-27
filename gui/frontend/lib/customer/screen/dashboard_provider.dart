import 'package:flutter/material.dart';
import 'package:omegatron/customer/screen/dashboard_models.dart';

class DashboardProvider extends ChangeNotifier {
  int _selectedScreen = 0;
  DashboardModel dashboardModelDetails = DashboardModel(
      firstName: "Sanjaan",
      lastName: "Singh",
      totalProfitLossValue: 'Gains',
      totalProfitLossNumericValue: 65,
      baseProfitLossValue: 'Loss',
      baseProfitLossNumericValue: 45,
      rideProfitLossValue: 'Gains',
      rideProfitLossNumericValue: 55,
      baseBarGraphData: [
        4.40,
        2.50,
        3.9,
        2.3,
        1.6,
        4.5,
        3.8
      ],
      rideBarGraphData: [
        4,
        2,
        3,
        2.3,
        4.5,
        1,
        3.8
      ],
      totalProfitLossLineGraphData: [
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

  getdashboardModelDetails() async {
    notifyListeners();
  }
}
