import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gastrome/widgets/BewertungenWidget.dart';

//Autor: Tim Bayer
//Diese Klasse ermöglicht es eine Kategorie durch Klicken der zutreffenden Bewertung zu bewerten.
// Sie ist vergleichbar mit einer 5 Sterne Bewertung, bei denen der User die richtige Stenrenanzahl wählen kann. Hier werden jedoch Kreise verwendet

class BewertungAuswahlWidget extends StatelessWidget {
  final Function(int value) onValueSelect;
  String text;
  int value;
  //Der Konstruktor der Klasse besteht aus einem Text (der Kategorie), einer CallbackFunktion (die den ausgewählten Wert an der Implementierungsstelle zugänglich macht) und aus einem Wert
  BewertungAuswahlWidget({this.text, this.onValueSelect, this.value});
  GlobalKey _keyBewertungsWidget = GlobalKey();

  //Funktionsweise: Diese Methode liefert die Oberfläche des BewertungAuswahlWidget
  //Rückgabewert: Die Methode liefert die Oberfläche in Form eines Widgets
  //Übergabeparameter: Der BuildContext wird implizit übergeben
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text,style: Theme.of(context).textTheme.headline4,),
          Listener(
              onPointerDown: (PointerDownEvent event) {
                print(event.position);
                checkTap(event);
                onValueSelect(value);
              },
              child: Container(
                  height: 28,
                  key: _keyBewertungsWidget,
                  //Das BewertungWidget stellt die 5 Kreise bereit, je nach der übergebener Anzahl sind bspw. 3 von 5 Kreisen markiert
                  child: BewertungWidget(anzahl: value))),
        ],
      ),
    );
  }

  //Funktionsweise: Diese Methode prüft, welche Bewertung angeklickt wurde
  //Übergabeparameter: Das Listener Event (der Klick) wird übergeben
  void checkTap(PointerDownEvent event) {
    //Es wird die Größe des BewertungWidget bestimmt (responsiv)
    final RenderBox renderBoxRed = _keyBewertungsWidget.currentContext
        .findRenderObject();
    final position = renderBoxRed.localToGlobal(Offset.zero);
    final size = renderBoxRed.size;

    //Anhand der Breite wird das BewertungsWidget in 5 Sektionen eingeteilt
    double unitWidth = size.width/5;
    double unit0 = position.dx;
    double unit1 = unit0+unitWidth;
    double unit2 = unit0+2*unitWidth;
    double unit3 = unit0+3*unitWidth;
    double unit4 = unit0+4*unitWidth;
    double unit5 = unit0+5*unitWidth;

    //Es wird geprüft, in welcher Sektion das Klick-Event registriert wurde und entsprechend die Bewertung gesetzt
    if (event.position.dx > unit0 && event.position.dx < unit1)
      value = 1;
    else if (event.position.dx > unit1 && event.position.dx < unit2)
      value = 2;
    else if (event.position.dx > unit2 && event.position.dx < unit3)
      value = 3;
    else if (event.position.dx > unit3 && event.position.dx < unit4)
      value = 4;
    else if (event.position.dx > unit4 && event.position.dx < unit5)
      value = 5;

  }
}

