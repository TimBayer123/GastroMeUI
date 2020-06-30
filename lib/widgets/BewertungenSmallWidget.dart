import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gastrome/entities/Bewertung.dart';

//Autor: Tim Bayer (Logik+ Aufbau: Tim Riebesam)
//Diese Klasse stellt die selbe Oberfläche wie das BewertungenWidget dar, jedoch stark verkleinert.
//Daher stammt die Logik und der Aufbau von Tim Riebesam

class BewertungenSmallWidget extends StatelessWidget {
  Bewertung bewertung;

  BewertungenSmallWidget({this.bewertung});


  //Funktionsweise: Diese Methode liefert die Oberfläche des BewertungenSmallWidget
  //Rückgabewert: Die Methode liefert die Oberfläche in Form eines Widgets
  //Übergabeparameter: Der BuildContext wird implizit übergeben
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

//Diese innere Klasse wird als Hilfsklasse verwendet. Sie addiert die Anzahl der markierten Kreise mit einer gewissen Anzahl an unmarkierten Kreise, sodass die Gesamtanzahl immer 5 entspricht
class BewertungWidget extends StatelessWidget {
  int anzahl;

  BewertungWidget({this.anzahl});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: addPointsAsWidgets(context),
    );
  }

  //Funktionsweise: Diese Methode liefert eine Reihe an 5 Kreisen (davon ist die Anzahl der Bewertung markiert)
  //Rückgabewert: Die Methode liefert eine liste an 5 Kreisen (Widgets)
  //Übergabeparameter: Der BuildContext wird übergeben
  List<Widget> addPointsAsWidgets(context){
    List<Widget> list = new List();

    //Hier werden die markierten Kreise hinzugefügt
    for(var i = 0; i < anzahl; i++){
      list.add(new FaIcon(FontAwesomeIcons.solidCircle, color: Theme.of(context).accentColor, size: 10,));
      list.add(new SizedBox(width: 2,));
    }

    //Hier werden die unmarkierten Kreise hinzugefügt. Die Gesamtanzahl an Kreise ist immer 5
    for(var i = 0; i < (5-anzahl); i++) {
      list.add(new FaIcon(FontAwesomeIcons.circle, color: Theme.of(context).accentColor, size: 10,));
      list.add(new SizedBox(width: 2,));
    }

    return list;
  }

}
