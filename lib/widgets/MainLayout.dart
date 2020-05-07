import 'package:flutter/material.dart';
import 'package:gastrome/widgets/NavigationBar.dart';
import 'package:gastrome/widgets/TopBar.dart';

class MainLayout extends StatefulWidget {
  bool foodAreaAcive;
  Widget child;

  MainLayout({@required this.foodAreaAcive, @required this.child});

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          TopBar(foodAreaActive: widget.foodAreaAcive),
          Expanded(
            child: Container(
              child: widget.child,
            ),
          ),
          NavigationBar()
        ],
      )


    );
  }
}
