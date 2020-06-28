import 'package:flutter/material.dart';
import 'package:gastrome/entities/Getraenk.dart';
import 'package:gastrome/entities/Speise.dart';
import 'package:gastrome/entities/Speisekarte.dart';
import 'package:gastrome/widgets/MenuCardWidget.dart';

//Autor: Tim Bayer
//Diese Klasse stellt die Oberfläche der Speisekarte dar. Sie kann Getränke oder Speisen separat darstellen
class Menu extends StatefulWidget {
  Speisekarte speisekarte;
  bool showFoodNotDrinks;

  //Der Konstruktur der Klasse. Der ShowFoodNotDrinks Parameter bestimmt ob die Speisekarte Getränke oder Speisen anzeigen soll
  Menu({this.showFoodNotDrinks, this.speisekarte});
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  Future<Speisekarte> futureSpeisekarte;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
  }

  //Funktionsweise: Diese Methode liefert die Oberfläche des Menu Screens
  //Rückgabewert: Die Methode liefert die gesamte Oberfläche in Form eines Widgets
  //Übergabeparameter: Der BuildContext wird implizit übergeben
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: Container(
          //In diesem Widget wird die Liste mit den Speisen oder Getränke geladen. Dafür wird für jedes Item ein MenuCardWidget erstellt
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: widget.showFoodNotDrinks ? widget.speisekarte.speisen.length : widget.speisekarte.getraenke.length,
                itemBuilder: widget.showFoodNotDrinks
                    ? (context, index) {
                        Speise speise = widget.speisekarte.speisen[index];
                        return MenuCardWidget(speise: speise);
                      }
                    : (context, index) {
                        Getraenk getraenk = widget.speisekarte.getraenke[index];
                        return MenuCardWidget(getraenk: getraenk);
                      })));
  }
}
