import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gastrome/entities/Restaurant.dart';

class BewertungenWidget extends StatelessWidget {
  Restaurant restaurant;

  BewertungenWidget({this.restaurant});

  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Essen",
              style: Theme.of(context).textTheme.headline5,
            ),
            Column(
              children: <Widget>[
                BewertungWidget(anzahl: restaurant.getEssensBewertung(),),
              ],
            ),
          ],
        ),
        SizedBox(height: 2,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Atmosphäre",
              style: Theme.of(context).textTheme.headline5,
            ),
            Column(
              children: <Widget>[
                BewertungWidget(anzahl: restaurant.getAtmosphaereBewertung(),),
              ],
            ),
          ],
        ),
        SizedBox(height: 2,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Service",
              style: Theme.of(context).textTheme.headline5,
            ),
            Column(
              children: <Widget>[
                BewertungWidget(anzahl: restaurant.getServiceBewertung(),),
              ],
            ),
          ],
        ),
        SizedBox(height: 2,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Preise",
              style: Theme.of(context).textTheme.headline5,
            ),
            Column(
              children: <Widget>[
                BewertungWidget(anzahl: restaurant.getPreiseBewertung(),),
              ],
            ),
          ],
        ),
        SizedBox(height: 2,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Sonderwünsche",
              style: Theme.of(context).textTheme.headline5,
            ),
            Column(
              children: <Widget>[
                BewertungWidget(anzahl: restaurant.getSonderwuenscheBewertung(),),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              "Rezessionen anzeigen",
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 14,
              color: Colors.black54,
            )
          ],
        )
      ],
    );
  }
}

class BewertungWidget extends StatelessWidget {
  int anzahl;

  BewertungWidget({this.anzahl});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: addPointsAsWidgets(context),
    );
  }

  List<Widget> addPointsAsWidgets(context){
    List<Widget> list = new List();

    for(var i = 0; i < anzahl; i++){
      list.add(new FaIcon(FontAwesomeIcons.solidCircle, color: Theme.of(context).accentColor, size: 20,));
      list.add(new SizedBox(width: 5,));
    }

    for(var i = 0; i < (5-anzahl); i++) {
      list.add(new FaIcon(FontAwesomeIcons.circle, color: Theme.of(context).accentColor, size: 20,));
      list.add(new SizedBox(width: 5,));
    }

    return list;
  }

}
