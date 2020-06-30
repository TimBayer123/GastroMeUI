import 'package:flutter/material.dart';
//Autor: Tim Bayer
//Diese Klasse stellt einen Button dar, der sich über die gesamte Breite (abzuüglich dem Padding) erstreckt

class FullWidthButton extends StatefulWidget {
  Function function;
  String buttonText;

  //Der Konstruktor der Klasse erfordert einen ButtonText und eine Funktion, die bei onTap ausgeführt wird
  FullWidthButton({@required this.buttonText, @required this.function});

  @override
  _FullWidthButtonState createState() => _FullWidthButtonState();
}

class _FullWidthButtonState extends State<FullWidthButton> {
  bool tapDown = false;

  //Funktionsweise: Diese Methode liefert die Oberfläche des FullWidth Buttons
  //Rückgabewert: Die Methode liefert die Oberfläche in Form eines Widgets
  //Übergabeparameter: Der BuildContext wird implizit übergeben
  @override
  Widget build(BuildContext context) {
    //Der Listener prüft wann geklickt und der Button wieder released wird
    return  Listener(
      onPointerDown: onTapFunction,
      onPointerUp: onReleaseFunction,
      // Der Button ändert bei Click seine Farbe, daher wird ein AnimatedContainer verwendet
      child: AnimatedContainer(
        duration: Duration(microseconds: 1),
        curve: Curves.linear,
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: tapDown ? Theme.of(context).accentColor.withOpacity(0.5) : Theme.of(context).accentColor,
            boxShadow: [
              BoxShadow(
                offset: Offset(0.00, 2.00),
                color: Color(0xff000000).withOpacity(0.20),
                blurRadius: 8,
              ),
            ]),
        child: Center(
          child: Text(
            widget.buttonText,
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
      ),
    );
  }

  //Funktionsweise: Bei tap wird die Farbe des Buttons angepasst und die übergebene Funktion ausgeführt
  //Übergabeparameter: Es wird das ListenerEvent übergeben
  void onTapFunction(PointerDownEvent details){
    //Hierdurch wird der Farbwechsel des Buttons veranlasst
      tapDown = true;
      //Hierdurch wird der Farbwechesl des Buttons ausgeführt (Das gesamte Widget wird neu gebaut)
      setState(() {});
      //Hierdurch wird die übergebene onTab Funktion ausgeführt
    widget.function();
  }

  //Funktionsweise: Bei Relaese wird die Farbe wieder angepasst
  //Übergabeparameter: Es wird das ListenerEvent übergeben
  void onReleaseFunction(PointerUpEvent details){
    //Hierdurch wird der Farbwechsel veranlasst
    tapDown = false;
    //Hierdurch wird der Farbwechsel asugeführt (Das gesamte Widget wird neu gebaut)
    setState(() {});
  }

  //Funktionsweise: Es wird geprüft ob der FullWidth Button noch angezeigt wird bevor dieser neu gebaut wird, ansonsten führt dies zu einem Fehler
  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }
}
