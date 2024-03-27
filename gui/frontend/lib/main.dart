import 'package:flutter/material.dart';
import 'package:omegatron/customer/screen/analyticsprovider.dart';
import 'package:omegatron/customer/screen/base_provider.dart';
import 'package:omegatron/customer/screen/dashboard_provider.dart';

import 'package:omegatron/customer/screen/safetynet_provider.dart';
import 'package:omegatron/customer/screen/profile_provider.dart';
import 'package:omegatron/customer/screen/signin_page.dart';
import 'package:omegatron/customer/screen/signinprovider.dart';

import 'package:omegatron/customer/screen/xequitylifesnipe_provider.dart';
import 'package:omegatron/customer/screen/x_equity_provider.dart';
import 'package:omegatron/customer/screen/xcf_provider.dart';
import 'package:omegatron/customer/screen/xmf_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DashboardProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AnalyticsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => BaseProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SafetynetProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => XcfProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => XmfProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => XEquityProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => XEquityLifeSnipeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SigninProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'OmegaTron App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          brightness: Brightness.light,
        ),
        home: const Signinpage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
