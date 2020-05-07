import 'package:flutter/material.dart';
import 'package:gastrome/pages/RestaurantOverview.dart';
import 'package:gastrome/widgets/TopBar.dart';

import 'PlaceholderWidget.dart';
import 'package:gastrome/settings/globals.dart' as globals;

class MainLayout extends StatefulWidget {
  bool foodAreaAcive;
  Widget child;

  MainLayout({@required this.foodAreaAcive, @required this.child});

  static _MainLayoutState of(BuildContext context) =>
      context.findAncestorStateOfType();

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentIndex = 0;
  final List<Widget> children = [
    PlaceholderWidget(Colors.white),
    PlaceholderWidget(Colors.deepOrange),
    PlaceholderWidget(Colors.green),
    PlaceholderWidget(Colors.pink)
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            flexibleSpace: SafeArea(
              child: TabBar(tabs: [
                Tab(icon: Icon(Icons.menu)),
                Tab(icon: Icon(Icons.person)),
              ]),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            backgroundColor: Theme.of(context).primaryColor,
            selectedItemColor: Theme.of(context).accentIconTheme.color,
            unselectedItemColor: Theme.of(context).primaryIconTheme.color,
            currentIndex: currentIndex,
            onTap: onTabTapped,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.restaurant),
                title: Text('Essen'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.free_breakfast),
                title: Text('Getränke'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.credit_card),
                title: Text('Bezahlen'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.speaker_notes),
                title: Text('Feedback'),
              ),
            ],
          ),
          body:  children[currentIndex],

          ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}
