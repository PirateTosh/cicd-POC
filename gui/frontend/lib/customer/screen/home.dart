import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:omegatron/customer/screen/analytics.dart';
import 'package:omegatron/customer/screen/analyticsprovider.dart';
import 'package:omegatron/customer/screen/app_color_data.dart' as colordata;
import 'package:omegatron/customer/screen/dashboard.dart';
import 'package:omegatron/customer/screen/dashboard_provider.dart';
import 'package:omegatron/customer/screen/activepositions.dart';
import 'package:omegatron/customer/screen/profile.dart';
import 'package:omegatron/customer/screen/settings.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:omegatron/common/constants/assets_constant.dart';

import 'package:omegatron/customer/screen/signinprovider.dart';
import 'package:provider/provider.dart';

class ExampleDashboard {
  const ExampleDashboard(this.label, this.iconSvg, this.selectedIconSvg);

  final String label;
  final String iconSvg;
  final String selectedIconSvg;
}

const List<ExampleDashboard> destinations = <ExampleDashboard>[
  ExampleDashboard('Dashboard', AssetsConstants.home, AssetsConstants.home),
  ExampleDashboard(
      'Analytics', AssetsConstants.analytics, AssetsConstants.analytics),
  ExampleDashboard('Active Positions', AssetsConstants.subscription,
      AssetsConstants.subscription),
  ExampleDashboard(
      'Settings', AssetsConstants.setting, AssetsConstants.setting),
  ExampleDashboard('Profile', AssetsConstants.setting, AssetsConstants.setting)
];

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => HomePage();
}

class HomePage extends State<Home> {
  List<BreadCrumbItem> breadcrumbList = [];
  addToBreadCrum(
    item,
    int screenIndex,
    Function(int) setSelectedScreen,
  ) {
    if (screenIndex == 0) {
      breadcrumbList.add(BreadCrumbItem(
          content: SvgPicture.asset(item),
          onTap: () {
            setSelectedScreen(screenIndex);
            removeToBreadCrum(screenIndex);
          }));
    } else {
      breadcrumbList.add(BreadCrumbItem(
          content: Text(
            item,
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    fontSize: 16,
                    color: Color(0xff353535),
                    fontWeight: FontWeight.w600)),
          ),
          onTap: () {
            setSelectedScreen(screenIndex);
            removeToBreadCrum(screenIndex);
          }));
    }
  }

  void removeToBreadCrum(int selectedIndex) {
    if (selectedIndex > 0 && selectedIndex < breadcrumbList.length) {
      breadcrumbList.removeRange(selectedIndex + 1, breadcrumbList.length);
    } else {
      breadcrumbList.removeRange(selectedIndex, breadcrumbList.length);
    }
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int screenIndex = 0;
  late bool showNavigationDrawer;
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

  late List<Widget> pageArray;

  @override
  void initState() {
    super.initState();
    pageArray = [
      Dashboard(
        breadcrumbList: breadcrumbList,
        addToBreadCrum: addToBreadCrum,
      ),
      Analytics(
        breadcrumbList: breadcrumbList,
        addToBreadCrum: addToBreadCrum,
      ),
      ActivePositions(),
      Settings(),
      Profile(),
    ];
  }

  void handleScreenChanged(int selectedScreen) {
    setState(() {
      screenIndex = selectedScreen;
    });
  }

  void _updateProvider(int index) {
    switch (index) {
      case 0:
        Provider.of<DashboardProvider>(context, listen: false).selectedScreen !=
            0;
        {
          // If the value is not zero, set it to zero
          Provider.of<DashboardProvider>(context, listen: false)
              .setSelectedScreen(0);
          removeToBreadCrum(0);
          break;
        }
      case 1:
        Provider.of<AnalyticsProvider>(context, listen: false).selectedScreen !=
            0;
        {
          // If the value is not zero, set it to zero
          Provider.of<AnalyticsProvider>(context, listen: false)
              .setSelectedScreen(0);
          removeToBreadCrum(0);

          break;
        }
    }
  }

  Widget buildBottomBarScaffold() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: pageArray[screenIndex],
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: screenIndex,
        onDestinationSelected: (int index) {
          setState(() {
            screenIndex = index;
          });
        },
        destinations: destinations.map((ExampleDashboard destination) {
          return NavigationDestination(
            label: destination.label,
            icon: SvgPicture.asset(
              destination.iconSvg,
            ),
            selectedIcon: SvgPicture.asset(
              destination.selectedIconSvg,
            ),
            tooltip: destination.label,
          );
        }).toList(),
      ),
    );
  }

  bool expand = false;
  Widget buildDrawerScaffold(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double textFontSize = calculateTextFontSize(screenWidth);

    return Scaffold(
        key: scaffoldKey,
        body: SafeArea(
          child: Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                    gradient: colordata.AppColors.blueGradient),
                child: AnimatedCrossFade(
                  duration: const Duration(milliseconds: 800),
                  crossFadeState: expand
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: _collapseSidebar(),
                  secondChild: Drawer(
                    backgroundColor: Colors.transparent,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            children: <Widget>[
                              _sidebarHeader(),
                              _menuList(textFontSize)
                            ],
                          ),
                        ),
                        _sidebarFooter()
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: pageArray[screenIndex],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _collapseSidebar() {
    return Column(
      children: [
        const SizedBox(height: 20.0),
        IconButton(
          onPressed: () {
            setState(() {
              expand = !expand;
            });
          },
          icon: SvgPicture.asset(AssetsConstants.menuicon),
        ),
        const SizedBox(height: 20.0),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(destinations.length, (index) {
            return InkWell(
              onTap: () {
                handleScreenChanged(index);
                _updateProvider(index);
              },
              child: CustomPaint(
                painter:
                    screenIndex == index ? CustomBackgroundPainter() : null,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return colordata.AppColors.yellowIconGradient
                          .createShader(bounds);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: IconTheme(
                        data: const IconThemeData(
                            color: colordata.AppColors.textPrimaryColor,
                            size: 25.0),
                        child: SvgPicture.asset(
                          destinations[index].iconSvg,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const Spacer(),
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: SizedBox.fromSize(
                    size: const Size.fromRadius(24),
                    child: Image.asset('assets/ppi_logo_image.jpg',
                        fit: BoxFit.cover),
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget _sidebarHeader() {
    return SizedBox(
      height: 90,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 8,
              child: Row(
                children: [
                  const Image(
                    image: AssetImage('assets/ppi_logo.jpg'),
                  ),
                  const SizedBox(width: 3),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Progressive',
                              style: GoogleFonts.montserrat(
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: colordata.AppColors.textPrimaryColor,
                                ),
                              ),
                            ),
                            WidgetSpan(
                              child: Transform.translate(
                                offset: const Offset(2, -10),
                                child: Text(
                                  'TM',
                                  style: GoogleFonts.montserrat(
                                    textStyle: const TextStyle(
                                      fontSize: 7,
                                      fontWeight: FontWeight.w400,
                                      color:
                                          colordata.AppColors.textPrimaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Passive Income',
                        style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: colordata.AppColors.textPrimaryColor)),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      expand = !expand;
                    });
                  },
                  icon: SvgPicture.asset(AssetsConstants.menuicon),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuList(double textFontSize) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: destinations.length,
      itemBuilder: (context, index) {
        return Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: Stack(children: [
            // Custom Paint for active tab
            if (index == screenIndex)
              Positioned.fill(
                child: CustomPaint(
                  painter: MyCustomPainter(),
                ),
              ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 50),
              selected: false,
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              minVerticalPadding: 25,
              leading: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return colordata.AppColors.yellowIconGradient
                      .createShader(bounds);
                },
                child: IconTheme(
                  data: const IconThemeData(
                      color: colordata.AppColors.textPrimaryColor, size: 32.0),
                  child: SvgPicture.asset(destinations[index].iconSvg),
                ),
              ),
              title: Text(
                destinations[index].label,
                style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: index == screenIndex
                      ? colordata.AppColors.secondaryColor
                      : colordata.AppColors.textPrimaryColor,
                )),
              ),
              onTap: () {
                setState(() {
                  screenIndex = index;
                  _updateProvider(index);
                });
              },
            ),
          ]),
        );
      },
    );
  }

  Widget _sidebarFooter() {
    final userDetails = Provider.of<DashboardProvider>(context, listen: false)
        .dashboardModelDetails;
    return Container(
      color: const Color(0xff415FC1),
      padding: const EdgeInsets.all(8),
      child: Align(
        alignment: FractionalOffset.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    'assets/ppi_logo_image.jpg',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${userDetails.firstName} ${userDetails.lastName}',
                  style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(
                          color: colordata.AppColors.textPrimaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {},
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return colordata.AppColors.yellowIconGradient
                        .createShader(bounds);
                  },
                  child: const IconTheme(
                      data: IconThemeData(
                          color: colordata.AppColors.textPrimaryColor,
                          size: 28.0),
                      child: Icon(
                        Icons.logout,
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    showNavigationDrawer = MediaQuery.of(context).size.width >= 550;
  }

  @override
  Widget build(BuildContext context) {
    return showNavigationDrawer
        ? buildDrawerScaffold(context)
        : buildBottomBarScaffold();
  }
}

class CustomBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xffFAF9FF)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width, -5);
    path.quadraticBezierTo(size.width, 0, size.width - 20, 0);
    path.lineTo(size.width - 52, 0);
    path.quadraticBezierTo((size.width - 75) / 2, 6, (size.width - 75) / 2, 38);
    path.lineTo(size.width, 38);
    path.close();

    path.moveTo(size.width, size.height + 7);
    path.quadraticBezierTo(
        size.width, size.height, size.width - 20, size.height);
    path.lineTo(size.width - 52, size.height);
    path.quadraticBezierTo(
        (size.width - 75) / 2, size.height - 2, (size.width - 75) / 2, 38);
    path.lineTo(size.width, 38);

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class MyCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xffFAF9FF)
      ..style = PaintingStyle.fill;

    final Path path = Path();
    path.moveTo(size.width, -15);
    path.quadraticBezierTo(size.width, 5, size.width - 20, 5);
    path.lineTo(size.width - 260, 5);
    path.quadraticBezierTo(
        (size.width - 300) / 2, 2, (size.width - 300) / 2, 40);
    path.lineTo(size.width, 40);
    path.close();

    path.moveTo(size.width, size.height + 25);
    path.quadraticBezierTo(
        size.width, size.height, size.width - 20, size.height);
    path.lineTo(size.width - 280, size.height);
    path.quadraticBezierTo(
        (size.width - 300) / 2, size.height - 2, (size.width - 300) / 2, 40);
    path.lineTo(size.width, 40);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
