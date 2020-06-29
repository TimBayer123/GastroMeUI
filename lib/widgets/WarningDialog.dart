import 'package:flutter/material.dart';
import 'package:gastrome/settings/globals.dart';

class WarningDialog extends StatefulWidget {
  String text = "";
  String textJa = "";
  String textNein = "";

  WarningDialog({this.text, this.textJa, this.textNein});

  @override
  _WarningDialogState createState() => _WarningDialogState();
}

class _WarningDialogState extends State<WarningDialog> {
  @override

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
            Navigator.pop(context);
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




}
