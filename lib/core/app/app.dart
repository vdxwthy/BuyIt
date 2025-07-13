import 'package:buy_it/core/themes/theme.dart';
import 'package:buy_it/routes/app_routes.dart';
import 'package:flutter/material.dart';

class ChizhikApp extends StatelessWidget {
  const ChizhikApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BuyIt',
      theme: lightTheme,
      initialRoute: '/',
      routes:  routes,
    );
  }
}