import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gastrome/settings/globals.dart';
import 'package:http/http.dart' as http;

class CheckOutDialog extends StatefulWidget {
  String text = "";
  String textJa = "";
  String textNein = "";
  String tischNr;

  CheckOutDialog({this.text, this.textJa, this.textNein, this.tischNr});

  @override
  _CheckOutDialogState createState() => _CheckOutDialogState();
}

class _CheckOutDialogState extends State<CheckOutDialog> {
  @override
  void initState() {
    clearGuests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
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
            widget.tischNr!=null ? clearGuests() : null;
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


  Future<bool> clearGuests() async {
    //await Future.delayed(Duration(seconds: 2));
    final response = await http.patch(
        gastroMeApiUrl + '/tisch/gaesteliste/clear/' + widget.tischNr,
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
