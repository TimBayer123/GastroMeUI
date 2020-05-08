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
  TabController tabController;
  TabController tabClickController;
  bool clickListenerActive;

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
    clickListenerActive = false;
    tabController = TabController(vsync: this, initialIndex: 0, length: 2);
    //Der AnimationListener prüft das Swipen der TabBar und passt die Tabs sehr agil an
    tabController.animation.addListener(() {
      setState(() {
        if (clickListenerActive) {
          if (tabController.indexIsChanging) {
            currentTabIndex == 0 ? showNavBar = true : showNavBar = false;
            print(currentTabIndex);
            clickListenerActive = false;
          }
        } else {
          int activeTabIndex = (tabController.animation.value)
              .round(); //_tabController.animation.value returns double
          if(activeTabIndex != currentTabIndex)
              currentTabIndex = activeTabIndex;
          currentTabIndex == 0 ? showNavBar = true : showNavBar = false;
          print(currentTabIndex);
          clickListenerActive = false;

        }
      });
    });
    // tabClickController = TabController(vsync: this, initialIndex: 0, length: 2);
    /*  tabClickController.addListener(() {
      setState(() {
        if(tabController.indexIsChanging || tabController.index != tabController.previousIndex)
          tabController.index == 0 ? showNavBar = true : showNavBar = false;
      });
    });*/
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
                  //indicatorColor: Colors.transparent,
                  onTap: (int index) {
                    clickListenerActive = true;
                    currentTabIndex = index;
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
