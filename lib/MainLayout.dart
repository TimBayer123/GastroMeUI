import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gastrome/pages/RestaurantOverview.dart';

import 'package:gastrome/widgets/PlaceholderWidget.dart';
import 'package:gastrome/settings/globals.dart' as globals;

class MainLayout extends StatefulWidget {
  Widget child;

  MainLayout({@required this.child});

  static _MainLayoutState of(BuildContext context) =>
      context.findAncestorStateOfType();

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout>
    with SingleTickerProviderStateMixin {
  bool showNavBar = true;
  int currentNavIndex = 0;
  int currentTabIndex = 0;
  int oldTabIndex = 0;
  TabController tabController;
  TabController tabClickController;
  bool changeTab;

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
    changeTab = false;
    tabController = TabController(vsync: this, initialIndex: 0, length: 2);
    //Der AnimationListener prüft ob
    tabController.animation.addListener(() {
      if (changeTab) {
        tabController.index == 0 ? showNavBar = true : showNavBar = false;
          changeTab=false;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Center(
            child: SafeArea(
              child: TabBar(
                  controller: tabController,
                  indicatorColor: Theme.of(context).primaryIconTheme.color,
                  indicatorPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  //indicatorColor: Colors.transparent,
                  onTap: (int index) {
                    changeTab = true;
                  },
                  tabs: [
                    Tab(
                        icon: Icon(Icons.menu,
                            color: !showNavBar
                                ? Theme.of(context).primaryIconTheme.color
                                : Theme.of(context).accentIconTheme.color)),
                    Tab(
                        icon: Icon(Icons.person,
                            color: showNavBar
                                ? Theme.of(context).primaryIconTheme.color
                                : Theme.of(context).accentIconTheme.color)),
                  ]),
            ),
          ),
        ),
        bottomNavigationBar: showNavBar
            ? BottomNavigationBar(
                type: BottomNavigationBarType.shifting,
                backgroundColor: Theme.of(context).primaryColor,
                selectedItemColor: Theme.of(context).accentIconTheme.color,
                unselectedItemColor: Theme.of(context).primaryIconTheme.color,
                currentIndex: currentNavIndex,
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
              )
            : null,
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: tabController,
          children: [
            listOfPages[currentNavIndex],
            PlaceholderWidget(Colors.amber),
          ],
        ));
  }

  void onTabTapped(index) {
    setState(() {
      currentNavIndex = index;
    });
  }
}
