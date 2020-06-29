import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gastrome/entities/Bewertung.dart';

class BewertungenSmallWidget extends StatelessWidget {
  Bewertung bewertung;

  BewertungenSmallWidget({this.bewertung});


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
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Column(
              children: <Widget>[
                BewertungWidget(anzahl: bewertung.essen),
              ],
            ),
          ],
        ),
        SizedBox(height: 1,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Atmosphäre",
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Column(
              children: <Widget>[
                BewertungWidget(anzahl: bewertung.atmosphaere),
              ],
            ),
          ],
        ),
        SizedBox(height: 1,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Service",
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Column(
              children: <Widget>[
                BewertungWidget(anzahl: bewertung.service),
              ],
            ),
          ],
        ),
        SizedBox(height: 1,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Preise",
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Column(
              children: <Widget>[
                BewertungWidget(anzahl: bewertung.preise),
              ],
            ),
          ],
        ),
        SizedBox(height: 1,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Sonderwünsche",
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Column(
              children: <Widget>[
                BewertungWidget(anzahl: bewertung.sonderwuensche),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
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
      list.add(new FaIcon(FontAwesomeIcons.solidCircle, color: Theme.of(context).accentColor, size: 10,));
      list.add(new SizedBox(width: 2,));
    }

    for(var i = 0; i < (5-anzahl); i++) {
      list.add(new FaIcon(FontAwesomeIcons.circle, color: Theme.of(context).accentColor, size: 10,));
      list.add(new SizedBox(width: 2,));
    }

    return list;
  }

}
