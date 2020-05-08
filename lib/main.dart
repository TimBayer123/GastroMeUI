import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gastrome/MainLayout.dart';
import 'package:gastrome/pages/Loading.dart';
import 'package:gastrome/pages/RestaurantOverview.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: Color(0xfff29f05),
      accentColor: Color(0xfff2f2f2),
      primaryIconTheme: IconThemeData(color: Color(0xfff2f2f2).withOpacity(0.60)),
      accentIconTheme: IconThemeData(color: Color(0xfff2f2f2)),
      canvasColor: Color(0xfff29f05),

      textTheme: TextTheme(
        headline1: TextStyle(fontSize: 72.0, fontFamily: 'Lato', fontWeight: FontWeight.bold),
        headline6: TextStyle(fontSize: 36.0, fontFamily: 'Lato', fontStyle: FontStyle.italic),
        bodyText1: TextStyle(fontSize: 16.0, fontFamily: 'Lato',),
      ),
    ),
    initialRoute: '/main',
    routes: {
      '/': (context) => Loading(),
      '/main': (context) => MainLayout(),
    },
  ));
}
