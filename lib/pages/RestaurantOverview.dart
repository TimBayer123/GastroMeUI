import 'package:flutter/material.dart';
import 'package:gastrome/widgets/MainLayout.dart';


class RestaurantOverview extends StatefulWidget {

  @override
  _RestaurantOverviewState createState() => _RestaurantOverviewState();
}

class _RestaurantOverviewState extends State<RestaurantOverview> {

  @override
  void initState() {
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      foodAreaAcive: false,
      child: Container(
        color: Colors.white,
      ),
    );









  }
}
