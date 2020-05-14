import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HeadlineWidget extends StatelessWidget {
  String title;
  String subtitle;
  bool callWaiterButton;

  HeadlineWidget({this.title, this.subtitle, this.callWaiterButton});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 30, 30, 20),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(title,
                          style: Theme.of(context).textTheme.headline1, textAlign: TextAlign.left,),
                        if(subtitle != null) Text(subtitle,
                          style: Theme.of(context).textTheme.headline2, textAlign: TextAlign.left,)
                      ],
                    ),
                )
            ),
            if(callWaiterButton) Container(
                alignment: Alignment.centerRight,
                child: FloatingActionButton(
                  elevation: 0,
                  child: Icon(Icons.directions_run, color: Theme.of(context).accentColor),
                ),
            ),
          ],
        ),
      ),
    );
  }
}
