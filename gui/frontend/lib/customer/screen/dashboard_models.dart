class DashboardModel {
  final String firstName;
  final String? lastName;
  final String totalProfitLossValue;
  final int totalProfitLossNumericValue;
  final String baseProfitLossValue;
  final int baseProfitLossNumericValue;
  final String rideProfitLossValue;
  final int rideProfitLossNumericValue;
  final List<double> baseBarGraphData;
  final List<double> rideBarGraphData;
  final List<double> totalProfitLossLineGraphData;
  final List<GraphDataModel> lineChartData1_1;
  final List<GraphDataModel> lineChartData1_2;

  DashboardModel(
      {required this.firstName,
      this.lastName,
      required this.totalProfitLossValue,
      required this.totalProfitLossNumericValue,
      required this.baseProfitLossValue,
      required this.baseProfitLossNumericValue,
      required this.rideProfitLossValue,
      required this.rideProfitLossNumericValue,
      required this.baseBarGraphData,
      required this.rideBarGraphData,
      required this.totalProfitLossLineGraphData,
      required this.lineChartData1_1,
      required this.lineChartData1_2});
  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
        firstName: json['first_name'],
        lastName: json['last_name'],
        totalProfitLossValue: json['total_profit_loss_value'],
        totalProfitLossNumericValue: json['total_Profit_Loss_Numeric_Value'],
        baseProfitLossValue: json['base_profit_loss_value'],
        baseProfitLossNumericValue: json['base_Profit_Loss_Numeric_Value'],
        rideProfitLossValue: json['ride_profit_loss_value'],
        rideProfitLossNumericValue: json['ride_Profit_Loss_Numeric_Value'],
        baseBarGraphData: json['base_Bar_Graph_Data'],
        rideBarGraphData: json['ride_Bar_Graph_Data'],
        totalProfitLossLineGraphData: json['total_Profit_Loss_Line_Graph_Data'],
        lineChartData1_1: json['line_Chart_Data_1_1'],
        lineChartData1_2: json['line_Chart_Data_1_2']);
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName ?? lastName,
      'total_profit_loss_value': totalProfitLossValue,
      'total_Profit_Loss_Numeric_Value': totalProfitLossNumericValue,
      'base_profit_loss_value': baseProfitLossValue,
      'base_Profit_Loss_Numeric_Value': baseProfitLossNumericValue,
      'ride_profit_loss_value': rideProfitLossValue,
      'ride_Profit_Loss_Numeric_Value': rideProfitLossNumericValue,
      'base_Bar_Graph_Data': baseBarGraphData,
      'ride_Bar_Graph_Data': rideBarGraphData,
      'total_Profit_Loss_Line_Graph_Data': totalProfitLossLineGraphData,
      'line_Chart_Data_1_1': lineChartData1_1,
      'line_Chart_Data_1_2': lineChartData1_2
    };
  }
}

class GraphDataModel {
  final double x;
  final double y;

  GraphDataModel(this.x, this.y);
}
