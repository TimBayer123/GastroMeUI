import 'package:flutter/material.dart';
import 'package:gastrome/entities/Rezession.dart';
import 'package:gastrome/widgets/BewertungenSmallWidget.dart';
//Autor: Tim Bayer
//Diese Klasse stellt die Oberfläche einer Rezession in der Liste an Rezessionen dar.

class RezessionItemWidget extends StatelessWidget {
  Rezession rezession;
  RezessionItemWidget({this.rezession});

  //Funktionsweise: Diese Methode liefert die Oberfläche einer Rezession
  //Rückgabewert: Die Methode liefert die Oberfläche in Form eines Widgets
  //Übergabeparameter: Der BuildContext wird implizit übergeben
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 90,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Auf der linken Seite wird die Anmerkung der Rezession angezeigt
              Flexible(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(0,0,5,0),
                    child: Text(rezession.anmerkung, style: Theme.of(context).textTheme.bodyText1)),
              ),
              //Auf der rechten Seite werden die Bewertungen der Rezession im Kleinformat angezeigt
              Expanded(
                  child: BewertungenSmallWidget(bewertung: rezession.bewertung)),
            ],
          ),
          //Rezessionen werden durch eine Trennlinie getrennt
          Divider(),
        ],
      ),
    );
  }
}
