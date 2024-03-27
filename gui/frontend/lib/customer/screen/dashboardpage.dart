import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:omegatron/common/constants/assets_constant.dart';
import 'package:omegatron/customer/screen/cards_widgets2.dart';
import 'package:omegatron/customer/screen/dashboard_models.dart';
import 'package:omegatron/customer/screen/dashboard_provider.dart';
import 'package:omegatron/customer/screen/gradient_arrow_icon.dart';
import 'package:omegatron/customer/screen/gradientbutton.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:omegatron/customer/screen/graphcardwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:omegatron/customer/screen/app_color_data.dart' as colordata;

class DashboardPage extends StatefulWidget {
  final Function(dynamic, int, Function(int)) addToBreadCrum;
  final List<BreadCrumbItem> breadcrumbList;
  const DashboardPage(
      {required this.addToBreadCrum, required this.breadcrumbList, super.key});
  @override
  State<DashboardPage> createState() => _DashboardPage();
}

class _DashboardPage extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );
  }

  final TextStyle _dropdownstyle1 = GoogleFonts.merriweatherSans(
      textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: colordata.AppColors.greenShade_1));
  final TextStyle _dropdownstyle2 = GoogleFonts.merriweatherSans(
      textStyle: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black));
  late bool isShowingMainData = true;
  bool isDropdownContentVisible = false;
  String dropdownValue = 'A';
  int currentIndexCard = 0;
  bool graphshowvalue = true;
  List<String> dropdownitems = [
    'A',
    'B',
    'C',
    'D',
  ];
  double calculateTextFontSize(double screenWidth) {
    // You can adjust these values based on your preferences
    if (screenWidth < 600) {
      return 14.0;
    } else if (screenWidth <= 1500) {
      return 18.0;
    } else {
      return 26.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double textFontSize = calculateTextFontSize(screenWidth);
    @override
    void dispose() {
      _animationController.dispose();
      super.dispose();
    }

    return Scaffold(
        backgroundColor: colordata.AppColors.primaryColor,
        body: Consumer<DashboardProvider>(builder: (context, value, child) {
          final dashboardDetails = value.dashboardModelDetails;
          return SingleChildScrollView(
            child: Column(
              children: [
                _headerWidget(textFontSize, context, widget.addToBreadCrum,
                    widget.breadcrumbList),
                Stack(children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(58, 10, 16, 0),
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Dashboard",
                                    style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                            color: colordata
                                                .AppColors.secondaryColor,
                                            fontSize: textFontSize * 2,
                                            fontWeight: FontWeight.w800))),
                                Text(
                                    "Welcome back, ${dashboardDetails.firstName}",
                                    style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                            color:
                                                colordata.AppColors.greyColor,
                                            fontSize: textFontSize - 2,
                                            fontWeight: FontWeight.w500))),
                              ],
                            ),
                          ),
                        ),
                        _cardsWidget(textFontSize, dashboardDetails),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                          child: Center(
                            child: DotsIndicator(
                              dotsCount: 2,
                              position: currentIndexCard.toDouble(),
                              decorator: const DotsDecorator(
                                color: colordata.AppColors.greyShade_1,
                                activeColor: colordata.AppColors.greenShade_1,
                              ),
                            ),
                          ),
                        ),
                      ])),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.easeIn,
                    height: isDropdownContentVisible ? 200 : 0,
                    child: Visibility(
                      visible: isDropdownContentVisible,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 30, 0),
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: _dropDownListView(),
                        ),
                      ),
                    ),
                  ),
                ]),
                Padding(
                  padding: const EdgeInsets.fromLTRB(62, 0, 16, 0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text("Active Bots",
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: colordata.AppColors.secondaryColor,
                                fontSize: textFontSize + 8))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(62, 10, 0, 0),
                  child: Row(
                    children: [
                      RingWithGap(
                        ringGradient: colordata.AppColors.blueRingGradient,
                        gapColor: Colors.white,
                        radius: MediaQuery.of(context).size.width * 0.023,
                        gapWidth: MediaQuery.of(context).size.width * 0.02,
                        strokeWidth: MediaQuery.of(context).size.width * 0.02,
                        svgPath: 'assets/bots_icon.svg',
                        labelText: 'OmegaTron',
                      ),
                      const SizedBox(width: 20),
                      RingWithGap(
                        ringGradient: colordata.AppColors.greenRingGradient,
                        gapColor: Colors.white,
                        radius: MediaQuery.of(context).size.width * 0.023,
                        gapWidth: MediaQuery.of(context).size.width * 0.02,
                        strokeWidth: MediaQuery.of(context).size.width * 0.02,
                        svgPath: 'assets/bots_icon_green.svg',
                        labelText: 'DeltaTron',
                      ),
                      const SizedBox(width: 20),
                      RingWithGap(
                        ringGradient: colordata.AppColors.yellowRingGradient,
                        gapColor: Colors.white,
                        radius: MediaQuery.of(context).size.width * 0.023,
                        gapWidth: MediaQuery.of(context).size.width * 0.02,
                        strokeWidth: MediaQuery.of(context).size.width * 0.02,
                        svgPath: 'assets/bots_icon_yellow.svg',
                        labelText: 'Ltron',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }));
  }

  Widget _headerWidget(
    double textFontSize,
    BuildContext context,
    Function(dynamic, int, Function(int)) addToBreadCrum,
    List<BreadCrumbItem> breadcrumbList,
  ) {
    return Consumer<DashboardProvider>(
      builder: (context, value, child) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 30, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 7,
                child: Row(
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('Portfolio Grading',
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                            fontSize: textFontSize,
                            color: colordata.AppColors.secondaryColor,
                            fontWeight: FontWeight.w600,
                          ))),
                    ),
                    const SizedBox(width: 5),
                    Text(dropdownValue,
                        style: GoogleFonts.merriweatherSans(
                            textStyle: TextStyle(
                                fontSize: textFontSize * 2,
                                fontWeight: FontWeight.w800,
                                color: colordata.AppColors.greenShade_1))),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isDropdownContentVisible = !isDropdownContentVisible;
                        });
                        if (isDropdownContentVisible) {
                          _animationController.forward();
                        }
                      },
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      child: Icon(
                        isDropdownContentVisible
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        size: 40.0,
                        color: colordata.AppColors.dropdownArrowColor,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GradientButton(
                      breadcrumbList: breadcrumbList,
                      text: 'Base',
                      screenIndex: 1,
                      value: 0,
                      baseridebreadcrumchangevalue: 2,
                      setSelectedScreen:
                          Provider.of<DashboardProvider>(context, listen: false)
                              .setSelectedScreen,
                      breadCrumImage: AssetsConstants.home,
                      addToBreadCrum: addToBreadCrum,
                      isActivePage: false,
                      onPressedCallback: () {
                        value.setSelectedScreen(1);
                      },
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    GradientButton(
                      breadcrumbList: breadcrumbList,
                      text: 'Ride',
                      screenIndex: 2,
                      value: 0,
                      baseridebreadcrumchangevalue: 2,
                      setSelectedScreen:
                          Provider.of<DashboardProvider>(context, listen: false)
                              .setSelectedScreen,
                      breadCrumImage: AssetsConstants.home,
                      addToBreadCrum: addToBreadCrum,
                      isActivePage: false,
                      onPressedCallback: () {
                        value.setSelectedScreen(2);
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _cardsWidget(double textFontSize, DashboardModel dashboardDetails) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 500),
      crossFadeState:
          graphshowvalue ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstChild:
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        CardsWidget2(
            title: 'Total Profit And Loss',
            profitlossnumericvalue:
                dashboardDetails.totalProfitLossNumericValue,
            profitlossvalue: dashboardDetails.totalProfitLossValue,
            graphData: dashboardDetails.totalProfitLossLineGraphData,
            graphshow: true,
            dashboardPageCard: true),
        CardsWidget2(
            title: 'Base Profit And Loss',
            profitlossnumericvalue: dashboardDetails.baseProfitLossNumericValue,
            profitlossvalue: dashboardDetails.baseProfitLossValue,
            graphshow: false,
            graphData: dashboardDetails.baseBarGraphData,
            dashboardPageCard: true),
        CardsWidget2(
            title: 'Ride Profit And Loss',
            profitlossnumericvalue: dashboardDetails.rideProfitLossNumericValue,
            profitlossvalue: dashboardDetails.rideProfitLossValue,
            graphshow: false,
            graphData: dashboardDetails.rideBarGraphData,
            dashboardPageCard: true),
        Center(
          child: GradientArrowIcon(
            icon: Icons.arrow_forward_ios,
            onPressed: () {
              setState(() {
                graphshowvalue = false;
                currentIndexCard++;
              });
            },
          ),
        ),
      ]),
      secondChild: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Center(
            child: GradientArrowIcon(
              icon: Icons.arrow_back_ios,
              onPressed: () {
                setState(() {
                  graphshowvalue = true;
                  currentIndexCard--;
                });
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
              child: GraphCardWidget(
                  cardHeading: 'Satistics To Date',
                  lineChartData1_1: dashboardDetails.lineChartData1_1,
                  lineChartData1_2: dashboardDetails.lineChartData1_2)),
        ],
      ),
    );
  }

  Widget _dropDownListView() {
    return ListView(
      children: [
        ListTile(
          leading: Text(dropdownitems[0], style: _dropdownstyle1),
          title: Text('Delta Cycling', style: _dropdownstyle2),
          onTap: () {
            setState(() {
              dropdownValue = dropdownitems[0];
            });
          },
        ),
        ListTile(
          leading: Text(dropdownitems[1], style: _dropdownstyle1),
          title: Text("Up Next", style: _dropdownstyle2),
          onTap: () {
            setState(() {
              dropdownValue = dropdownitems[1];
            });
          },
        ),
        ListTile(
          leading: Text(dropdownitems[2], style: _dropdownstyle1),
          title: Text("Up Next", style: _dropdownstyle2),
          onTap: () {
            setState(() {
              dropdownValue = dropdownitems[2];
            });
          },
        ),
        ListTile(
          leading: Text(dropdownitems[3], style: _dropdownstyle1),
          title: Text("Up Next", style: _dropdownstyle2),
          onTap: () {
            setState(() {
              dropdownValue = dropdownitems[3];
            });
          },
        ),
      ],
    );
  }
}

class RingWithGap extends StatelessWidget {
  final Gradient ringGradient;
  final Color gapColor;
  final double radius;
  final double gapWidth;
  final double strokeWidth;
  final String svgPath;
  final String labelText;

  RingWithGap({
    required this.ringGradient,
    required this.gapColor,
    required this.radius,
    required this.gapWidth,
    required this.strokeWidth,
    required this.svgPath,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: (radius + strokeWidth) * 2,
      height: (radius + strokeWidth) * 2,
      child: Stack(
        children: [
          CustomPaint(
            painter: RingWithGapPainter(
                ringGradient, gapColor, gapWidth, strokeWidth),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(0),
                child: SvgPicture.asset(svgPath,
                    width: MediaQuery.of(context).size.width * 0.03),
              ),
            ),
          ),
          Positioned(
            bottom: 7,
            left: 0,
            right: 0,
            child: Center(
              child: Text(labelText,
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                        color: colordata.AppColors.textPrimaryColor,
                        fontSize: 11 * screenWidth / 1440,
                        fontWeight: FontWeight.w700),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

class RingWithGapPainter extends CustomPainter {
  final Gradient ringGradient;
  final Color gapColor;
  final double gapWidth;
  final double strokeWidth;

  RingWithGapPainter(
      this.ringGradient, this.gapColor, this.gapWidth, this.strokeWidth);

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    final Paint ringPaint = Paint()
      ..shader = ringGradient.createShader(Rect.fromCircle(
          center: Offset(centerX, centerY),
          radius: size.width / 2 - strokeWidth / 2))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(
        Offset(centerX, centerY), size.width / 2 - strokeWidth / 2, ringPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
