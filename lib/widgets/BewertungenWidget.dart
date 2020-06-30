import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gastrome/entities/Restaurant.dart';

//Autor: Tim Riebesam, Tim Bayer
//Diese Klasse stellt die Oberfläche für die Bewertungen dar. Eine Bewertung besteht aus einer Kategorie und 5 Kreisen, die je nach Bewertung unterschiedlich eingefärbt sind
//Es werden 5 Bewertungen untereinander dargestellt

class BewertungenWidget extends StatefulWidget {
  Restaurant restaurant;
  bool Function(bool) onRezessionenClick;

  //Der Konstruktor der Klasse übergibt ein Restaurant und einer Callback-Funktion, die anzeigt ob die Rezessionen angezeigt werden und der Text angepasst werden muss.
  BewertungenWidget({this.restaurant, this.onRezessionenClick});

  @override
  _BewertungenWidgetState createState() => _BewertungenWidgetState();
}

class _BewertungenWidgetState extends State<BewertungenWidget> {
  bool showRezessionen = false;

  //Bei Initialisierung wird der Status, der anzeigt ob Rezessionen angezeigt werden, auf false gesetzt.
  @override
  void initState() {
    showRezessionen = false;
    super.initState();
  }

  //Funktionsweise: Diese Methode liefert die Oberfläche des BewertungenWidget
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
              style: Theme.of(context).textTheme.headline4,
            ),
            Column(
              children: <Widget>[
                BewertungWidget(anzahl: widget.restaurant.getEssensBewertung(),),
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
              style: Theme.of(context).textTheme.headline4,
            ),
            Column(
              children: <Widget>[
                BewertungWidget(anzahl: widget.restaurant.getAtmosphaereBewertung(),),
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
              style: Theme.of(context).textTheme.headline4,
            ),
            Column(
              children: <Widget>[
                BewertungWidget(anzahl: widget.restaurant.getServiceBewertung(),),
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
              style: Theme.of(context).textTheme.headline4,
            ),
            Column(
              children: <Widget>[
                BewertungWidget(anzahl: widget.restaurant.getPreiseBewertung(),),
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
              style: Theme.of(context).textTheme.headline4,
            ),
            Column(
              children: <Widget>[
                BewertungWidget(anzahl: widget.restaurant.getSonderwuenscheBewertung(),),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        //Unter den Bewertungen wird ein kleiner Text angezeigt, über den die Rezessionen ein- oder ausgeblendet werden
        GestureDetector(
          onTap: (){
            setState(() {
              showRezessionen = widget.onRezessionenClick(showRezessionen);
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                !showRezessionen ? "Rezessionen anzeigen" : "Rezessionen ausblenden",
                style: Theme.of(context).textTheme.bodyText2,
              ),
              Icon(
                !showRezessionen ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                size: 14,
                color: Colors.black54,
              )
            ],
          ),
        )
      ],
    );
  }
}

//Diese innere Klasse wird als Hilfsklasse verwendet. Sie addiert die Anzahl der markierten Kreise mit einer gewissen Anzahl an unmarkierten Kreise, sodass die Gesamtanzahl immer 5 entspricht
class BewertungWidget extends StatelessWidget {
  int anzahl;

  BewertungWidget({this.anzahl});

  //Funktionsweise: Diese Methode liefert eine Reihe an 5 Kreisen (davon ist die Anzahl der Bewertung markiert)
  //Rückgabewert: Die Methode liefert eine liste an 5 Kreisen (Widgets)
  //Übergabeparameter: Der BuildContext wird übergeben
  @override
  Widget build(BuildContext context) {
    return Row(
      children: addPointsAsWidgets(context),
    );
  }

  List<Widget> addPointsAsWidgets(context){
    List<Widget> list = new List();

    //Hier werden die markierten Kreise hinzugefügt
    for(var i = 0; i < anzahl; i++){
      list.add(new FaIcon(FontAwesomeIcons.solidCircle, color: Theme.of(context).accentColor, size: 20,));
      list.add(new SizedBox(width: 5,));
    }

    //Hier werden die unmarkierten Kreise hinzugefügt. Die Gesamtanzahl an Kreise ist immer 5
    for(var i = 0; i < (5-anzahl); i++) {
      list.add(new FaIcon(FontAwesomeIcons.circle, color: Theme.of(context).accentColor, size: 20,));
      list.add(new SizedBox(width: 5,));
    }

    return list;
  }

}
