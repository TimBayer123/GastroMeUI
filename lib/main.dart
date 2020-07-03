import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gastrome/Home.dart';
import 'package:gastrome/settings/globals.dart';

void main() {
  loggedIn=false;
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
  runApp(MaterialApp(
    theme: ThemeData(
      accentColor: Color(0xfff29f05),
      primaryColor: Color(0xfff2f2f2),
      primaryIconTheme: IconThemeData(color: Color(0xfff2f2f2).withOpacity(0.60)),
      accentIconTheme: IconThemeData(color: Color(0xfff2f2f2)),
      backgroundColor: Color(0xfff2f2f2),
      appBarTheme: AppBarTheme(color: Color(0xfff29f05)),
      canvasColor: Color(0xfff29f05),
      cardColor: Colors.white,
      floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Colors.white,foregroundColor: Color(0xfff29f05)),

      textTheme: TextTheme(
          headline1: TextStyle(fontSize: 32.0, fontFamily: 'Lato', fontWeight: FontWeight.w700, color: Colors.black),
          headline2: TextStyle(fontSize: 32.0, fontFamily: 'Lato', fontWeight: FontWeight.w500, color: Colors.black),
          headline3: TextStyle(fontSize: 20.0, fontFamily: 'Lato', fontWeight: FontWeight.w500, color: Colors.white),
          headline4: TextStyle(fontSize: 16.0, fontFamily: 'Lato', fontWeight: FontWeight.w500),
          headline5: TextStyle(fontSize: 18.0, fontFamily: 'Lato', fontWeight: FontWeight.w500),
          headline6: TextStyle(fontSize: 16.0, fontFamily: 'Lato', color: Color(0xfff29f05)),
          bodyText1: TextStyle(fontSize: 11.0, fontFamily: 'Lato',),
          bodyText2: TextStyle(fontSize: 11.0, fontFamily: 'Lato', color: Colors.black54),
      ),
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => Home(),
    },
  ));
  });
}
