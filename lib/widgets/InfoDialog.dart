import 'package:flutter/material.dart';

class InfoDialog extends StatelessWidget {
 String text = "";
 String title = "";
 InfoDialog({this.text, this.title});

 //Funktionsweise: Diese Methode liefert die Oberfläche eines Info Dialogs
 //Rückgabewert: Die Methode liefert die gesamte Oberfläche in Form eines Widgets
 //Übergabeparameter: Der BuildContext wird implizit übergeben
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(title),
      content: Text(text),
    );
  }

  //Funktionsweise: Diese statische Methode erzeugt ein InfoDialog
 //Übergabeparameter: Es wird der Text und der Titel, sowie der BuildContext übergeben
 //Rückgabewert: Es wird ein Widget zurückgeliefert, in diesem Fall immer ein Info Dialog
  static Widget show(String text, String title, BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return InfoDialog(text: text, title: title);
      },
    );
  }
}
