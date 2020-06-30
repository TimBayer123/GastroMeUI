import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//Autor: Tim Bayer, Tim Riebesam
//Diese Klassen setzen die Vegan/Vegie Icons zusammen

class VeganIcon extends StatelessWidget {

  //Funktionsweise: Diese Methode liefert die Oberfläche des Vegan-Icons
  //Rückgabewert: Die Methode liefert die Oberfläche in Form eines Widgets
  //Übergabeparameter: Der BuildContext wird implizit übergeben
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 30,
      child: Stack(
          children: [
            Positioned(
              bottom: 0,
              right: 20,
                child: FaIcon(FontAwesomeIcons.seedling, color: Color(0xff708b1a), size: 20,)
            ),
            Positioned(
              bottom: 2,
              right: 0,
              child: Text("vegan", style: TextStyle(
                fontFamily: "Lato",
                fontSize: 10,
                color:Color(0xff708b1a),
              )),
            )
          ]
      ),
    );
  }
}

class VegieIcon extends StatelessWidget {
  //Funktionsweise: Diese Methode liefert die Oberfläche des Vegie Icons
  //Rückgabewert: Die Methode liefert die Oberfläche in Form eines Widgets
  //Übergabeparameter: Der BuildContext wird implizit übergeben
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 30,
      child: Stack(
          children: [
            Positioned(
                bottom: 0,
                right: 20,
                child: FaIcon(FontAwesomeIcons.seedling, color: Color(0xff99bd27), size: 20,)
            ),
            Positioned(
              bottom: 2,
              right: 3,
              child: Text("vegie", style: TextStyle(
                fontFamily: "Lato",
                fontSize: 10,
                color: Color(0xff99bd27),
              )),
            )
          ]
      ),
    );
  }
}

