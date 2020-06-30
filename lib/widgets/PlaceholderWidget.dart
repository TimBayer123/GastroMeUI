import 'package:flutter/material.dart';

//Autor: Joseph Cherry
//https://willowtreeapps.com/ideas/how-to-use-flutter-to-build-an-app-with-bottom-navigation
//Diese Klasse stellt lediglich eine einfarbeige Fläche dar

class PlaceholderWidget extends StatelessWidget {
  final Color color;

  PlaceholderWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}