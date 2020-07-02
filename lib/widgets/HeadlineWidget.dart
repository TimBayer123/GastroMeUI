import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gastrome/settings/globals.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:http/http.dart' as http;

import 'InfoDialog.dart';

//Autor: Tim Riebesam, Tim Bayer
//Dieses Widget stellt die Kopfzeile jeder Hauptseite dar

class HeadlineWidget extends StatefulWidget {
  String title;
  String subtitle;
  bool callWaiterButton;

  //Der Konstruktor der Klasse besteht aus einem Titel, Untertitel und einem bool, der besagt ob ein Kellner-rufen Button angezeigt wird oder nicht
  HeadlineWidget({this.title, this.subtitle, this.callWaiterButton});

  @override
  _HeadlineWidgetState createState() => _HeadlineWidgetState();
}

class _HeadlineWidgetState extends State<HeadlineWidget> {

  //Funktionsweise: Diese Methode liefert die Oberfläche des Headline Widgets
  //Rückgabewert: Die Methode liefert die Oberfläche in Form eines Widgets
  //Übergabeparameter: Der BuildContext wird implizit übergeben
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(widget.title,
                          style: Theme.of(context).textTheme.headline1, textAlign: TextAlign.left,),
                        if(widget.subtitle != null) Text(widget.subtitle,
                          style: Theme.of(context).textTheme.headline2, textAlign: TextAlign.left,)
                      ],
                    ),
                )
            ),
            //Ist das callWaiterButton bool true, wird der Kellner-rufen Button angezeigt.
            if(widget.callWaiterButton) InkWell(
              //Bei onTap wird der Kellner gerufen und ein Bestätigungsdialog angezeigt
              onTap: (){
                callWaiter();
                showConfirmationDialog("Ein Kellner macht sich in Kürze auf den Weg zu dir");
              },
              child: Container(
                  alignment: Alignment.centerRight,
                  child: FloatingActionButton(
                    elevation: 0,
                    child: Icon(Icons.directions_run, color: Theme.of(context).accentColor),
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Funktionsweise: Hier wird der Kellner gerufen, die Anfrage wird via Email an eine hinterlegte Email-Adresse gesendet
  Future<void> callWaiter() async{

      String subject = 'Kellner gerufen von Tisch Nr. '+tischId;


      final smtpServer = gmail(EmailUsername, EmailPassword);

      final body = Message()
        ..from = Address(EmailUsername, 'Waiter Tim')
        ..recipients.add(restaurant.email)
        ..subject = subject
        ..html = "<h1>Kellner gerufen</h1>\n<p>Tisch Nr: "+tischId+"</p>";

      try {
        final sendReport = await send(body, smtpServer);
        //Es wird die Anfrage ebenfalls an das Backend gesendet, in dem der Kellner-gerufen Status aktualisiert wird
        callWaiterUpdateDB();
        print('Message sent: ' + sendReport.toString());
      } on MailerException catch (e) {
        print('Message not sent.');
        for (var p in e.problems) {
          print('Problem: ${p.code}: ${p.msg}');
        }
      }
  }

  //Funktionsweise: Es wird eine Patch-Request an das Backend gesendet, die den Kellner-gerufen Status aktualisiert
  Future<void> callWaiterUpdateDB() async {
    var response = await http.patch(gastroMeApiUrl + '/tisch/' + tischId + '/kellner',
    headers: { gastroMeApiAuthTokenName: gastroMeApiAuthTokenValue });

    if(response.statusCode == 200){
      //TODO Handle Success
    } else {
      //TODO Handle Error
    }
  }

  //Funktionsweise: Hier wird der spezifische Bestätigungsdialog definiert
  Future<void> showConfirmationDialog(String text){
    InfoDialog.show(text,"Kellner gerufen", context);
  }

}
