import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gastrome/settings/globals.dart';
import 'package:http/http.dart' as http;

//Autor: Tim Bayer
//Diese Klasse implementiert einen Dialog, der beim Check Out angezeigt wird

class CheckOutDialog extends StatefulWidget {
  String text = "";
  String textJa = "";
  String textNein = "";
  String tischId;

  //Der Konstruktor der Klasse
  CheckOutDialog({this.text, this.textJa, this.textNein, this.tischId});

  @override
  _CheckOutDialogState createState() => _CheckOutDialogState();
}

class _CheckOutDialogState extends State<CheckOutDialog> {

  //Funktionsweise: Bei Initialisierung wird die Gästeliste des Tisches gelöscht
  @override
  void initState() {
    clearGuests();
    super.initState();
  }

  //Funktionsweise: Diese Methode liefert die Oberfläche des CheckOut Dialogs
  //Rückgabewert: Die Methode liefert die Oberfläche in Form eines Widgets
  //Übergabeparameter: Der BuildContext wird implizit übergeben
  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: new Text('Bist du dir sicher?'),
      content: loggedIn ? new Text(widget.text) : new Text("Möchtest du die GastroMe App wirklich verlassen?"),
      actions: <Widget>[
        new GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Navigator.of(context).pop(false);
          },
          child: Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 12, 12),
              child: loggedIn ? Text(widget.textNein) : Text("Nein, das war ein Versehen"),
            ),
          ),
        ),
        SizedBox(height: 16),
        new GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            widget.tischId!=null ? clearGuests() : null;
            //Entweder wird der User ausgechekt oder die App geschlossen, abhängig pb man sich im eingecheckten oder ausgecheckten Zustand befindet
            loggedIn ? Navigator.of(context).pop(true) : SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            loggedIn = false;
          },
          child: Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 12, 12),
              child: Text(widget.textJa)
            ),
          ),
        ),
      ],
    );
  }

  //Funktionsweise: Diese Methode leert über eine Patch-Request die Gästeliste, dies geschieht asynchron
  //Rückgabewert: Die Methode liefert einen Future bool, für Kontrollzwecke
  Future<bool> clearGuests() async {
    //await Future.delayed(Duration(seconds: 2));
    final response = await http.patch(
        gastroMeApiUrl + '/tisch/gaesteliste/clear/' + widget.tischId,
        headers: {
          gastroMeApiAuthTokenName : gastroMeApiAuthTokenValue,
        });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return true;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Gast hinzufügen fehlgeschlagen');
    }
  }
}
