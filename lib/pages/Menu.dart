import 'package:flutter/material.dart';
import 'package:gastrome/entities/Speise.dart';
import 'package:gastrome/widgets/HeadlineWidget.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          HeadlineWidget(restaurantName: 'Cafe Simple', callWaiterButton: true),
        ],
      ),
    );
  }
}
