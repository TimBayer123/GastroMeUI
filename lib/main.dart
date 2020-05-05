import 'package:flutter/material.dart';
import 'package:gastrome/pages/Home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    theme: ThemeData(
      // Define the default brightness and colors.
      textSelectionHandleColor: Colors.red,
      brightness: Brightness.dark,
      primaryColor: Colors.green,
      accentColor: Colors.deepOrangeAccent,

      // Define the default font family.
      fontFamily: 'CrimsonText',

      // Define the default TextTheme. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.
      /*textTheme: TextTheme(
        headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        body1: TextStyle(fontSize: 16.0, fontFamily: 'Hind'),
      ),*/
    ),
    initialRoute: '/home',
    routes: {
      '/': (context) => Home(
        i: 5,
      ),
      '/home': (context) => Home(
        i: 5,
      ),

    },
  ));
}
