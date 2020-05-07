import 'package:flutter/material.dart';

class NavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).primaryColor,
        height: 70,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Expanded(
              child: IconButton(
                icon: Icon(Icons.restaurant, color: Theme.of(context).primaryIconTheme.color),
                iconSize: 30,
                onPressed: (){

                },
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.free_breakfast, color: Theme.of(context).primaryIconTheme.color),
                iconSize: 30,
                onPressed: (){

                },
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.credit_card, color: Theme.of(context).primaryIconTheme.color),
                iconSize: 30,
                onPressed: (){

                },
              ),
            ),
            Expanded(
              child: IconButton(
                iconSize: 30,
                icon: Icon(Icons.speaker_notes, color: Theme.of(context).accentIconTheme.color),
                onPressed: (){

                },
              ),
            )
          ],
        ),

    );
  }
}

