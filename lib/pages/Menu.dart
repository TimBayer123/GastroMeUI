import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:gastrome/entities/Getraenk.dart';
import 'package:gastrome/entities/Speise.dart';
import 'package:gastrome/entities/Speisekarte.dart';
import 'package:gastrome/widgets/MenuCardWidget.dart';
import 'package:gastrome/widgets/HeadlineWidget.dart';
import 'package:http/http.dart' as http;

class Menu extends StatefulWidget {
  Speisekarte speisekarte;
  bool showFoodNotDrinks;

  Menu({this.showFoodNotDrinks, this.speisekarte});
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  Future<Speisekarte> futureSpeisekarte;
  AnimationController animationController;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: Container(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.speisekarte.speisen.length,
                itemBuilder: widget.showFoodNotDrinks
                    ? (context, index) {
                        Speise speise = widget.speisekarte.speisen[index];
                        return MenuCardWidget(speise: speise);
                      }
                    : (context, index) {
                        Getraenk getraenk = widget.speisekarte.getraenke[index];
                        return MenuCardWidget(getraenk: getraenk);
                      })));
  }
}
