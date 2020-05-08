import 'package:flutter/material.dart';
import 'package:gastrome/pages/RestaurantOverview.dart';

import 'PlaceholderWidget.dart';
import 'package:gastrome/settings/globals.dart' as globals;

class MainLayout extends StatefulWidget {
  Widget child;

  MainLayout({@required this.child});

  static _MainLayoutState of(BuildContext context) =>
      context.findAncestorStateOfType();

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  bool showNavBar = true;
  int currentIndex = 0;

  //In dieser Liste sind alle Seiten aufgeführt, die über die Navbar erreichbar sind
  final List<Widget> listOfPages = [
    RestaurantOverview(),
    PlaceholderWidget(Colors.blueGrey),
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
              automaticallyImplyLeading: false,
            flexibleSpace: SafeArea(
              child: TabBar(
                indicatorColor: Theme.of(context).primaryIconTheme.color,
                onTap: (int index){ setState(() {
                  index==0 ? showNavBar = true : showNavBar = false;
                });
                },
                  tabs: [
                Tab(icon: Icon(Icons.menu, color: !showNavBar ? Theme.of(context).primaryIconTheme.color : Theme.of(context).accentIconTheme.color)),
                Tab(icon: Icon(Icons.person, color: showNavBar ? Theme.of(context).primaryIconTheme.color : Theme.of(context).accentIconTheme.color)),
              ]),
            ),
          ),
          bottomNavigationBar: showNavBar ? BottomNavigationBar(
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
          ): null,
          body:  TabBarView(
            children: [
              listOfPages[currentIndex],
              PlaceholderWidget(Colors.amber),
            ],
          )

          ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}
