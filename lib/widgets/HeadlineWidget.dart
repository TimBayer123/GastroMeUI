import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HeadlineWidget extends StatelessWidget {
  String restaurantName;
  bool callWaiterButton;

  HeadlineWidget({this.restaurantName, this.callWaiterButton});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(restaurantName,
                  style: Theme.of(context).textTheme.headline1,)
              )
          ),
          Container(
              alignment: Alignment.centerRight,
              child: FloatingActionButton(
                elevation: 0,
                child: Icon(callWaiterButton ? Icons.directions_run : null, color: Theme.of(context).accentColor),
              ),
          ),
        ],
      ),
    );
  }
}
