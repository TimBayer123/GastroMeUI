import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gastrome/entities/Rechnung.dart';
import 'package:gastrome/entities/SpeisekartenItem.dart';
import 'package:gastrome/settings/globals.dart';
import 'package:gastrome/widgets/FullWidthButton.dart';
import 'package:mailer/mailer.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:http/http.dart' as http;
import 'package:mailer/smtp_server/gmail.dart';

//Autor: Tim Riebesamm, Tim Bayer
//Diese Klasse stellt den Rechnung-Screen dar. Es wird die aktuelle Rechnung des eingeloggten Tisches geladen und angezeigt.
//Das Bezahlen der Rechnung ist ebenfalls möglich. Es wird jedoch nur die aktuelle Rechnung als "bezahlt" gekennzeichnet.

class BillOverview extends StatefulWidget {
  @override
  _BillOverviewState createState() => _BillOverviewState();
}

class _BillOverviewState extends State<BillOverview> with SingleTickerProviderStateMixin  {
  Future<Rechnung> futureRechnung;
  double sum = 0;
  AnimationController controller;

  //Funktionsweise: Diese Methode ruft bei Initialisierung die Methoden zum Laden der Rechnung auf.
  @override
  void initState() {
    //Während Initialisierung soll die Rechnung geladen werden. hierfür wird die Methode loadRechnung() aufgerufen.
    loadRechnung();
    //AnimationController wird initialisiert für HeartbeatProgressIndicator. repeat(reverse: true) damit dieser die Animation ständig wiederholt im Verlauf Vor-Zurück-Vor-Zurück-... und nicht nur Vor-Reset-Vor-Reset-...
    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    controller.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  //Funktionsweise: Diese Methode liefert die Oberfläche der Rechnung
  //Rückgabewert: Die Methode liefert die gesamte Oberfläche in Form eines Widgets
  //Übergabeparameter: Der BuildContext wird implizit übergeben
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(30, 0, 50, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Rechnung", style: Theme.of(context).textTheme.headline5,),
            SizedBox(height: 20,),
            //Wenn Rechnung Global gesetzt und Speisen oder Getränke auf der Rechnung vorhanden, dann lade Rechnung über FutureBuilder (z.B. in CheckInAndLoadData.dart beschrieben)
            //rechnung Global wird in MenuItemDetails.dart gesetzt, wenn ein Getränk bestellt wird.
            //Wenn Bedinung nicht erfüllt, zeige Text mit Info, dass Rechnung keine Bestellungen aufweist.
            ((rechnungGlobal != null) && (rechnungGlobal.speisen != 0 || rechnungGlobal.getraenkOrders != 0)) ?
              Expanded(
                child: FutureBuilder(
                    future: futureRechnung,
                    builder: (context, snapshot) {
                      //Wenn FutureBuilder erfolgreich, zeige Rechnung, ansonsten zeige Lade-Spinner oder bei Error eine Fehlermeldung.
                      if (snapshot.hasData){
                        Rechnung rechnung = snapshot.data;
                        List<SpeisekartenItem> items = new List();
                        items.addAll(rechnung.speisen);
                        rechnung.getraenkOrders.forEach((order) {
                          items.add(order.getraenk);
                        });
                        return Container(
                          //Liste aus den Rechnungsitems wird gebaut und angezeigt. Durch ListView scrollable
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              SpeisekartenItem item = items[index];
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(item.name, style: Theme.of(context).textTheme.bodyText1,),
                                  Text(item.preis.toStringAsFixed(2).replaceAll(".", ",") + " €", style: Theme.of(context).textTheme.bodyText1,),
                                ],
                              );
                            },
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text("Bei Laden Deiner Rechnung ist etwas Schiefgelaufen...");
                      }
                      //Default Loading Spinner
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          HeartbeatProgressIndicator(
                            child: AnimatedIcon(
                              icon: AnimatedIcons.search_ellipsis,
                              progress: controller,
                              color: Theme.of(context).accentColor,
                              size: 40,
                            ),
                            duration: new Duration(seconds: 1),
                          ),
                          SizedBox(height: 40),
                          Text(
                            'Deine Rechnung wird geladen',
                            style: Theme.of(context).textTheme.headline4,)
                        ],
                      );
                    }
                ),
              ) : Text("Deine Rechnung ist noch leer..."),
              Container(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 20),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10,),
                    SizedBox(
                      height: 2,
                      width: double.infinity,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    SizedBox(height: 4,),
                    SizedBox(
                      height: 2,
                      width: double.infinity,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    SizedBox(height: 6,),
                    Row(
                      //Summe aller Bestellungen anzeigen
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(sum.toStringAsFixed(2).replaceAll(".", ",") + " €", style: Theme.of(context).textTheme.headline4,)
                      ],
                    ),
                    SizedBox(height: 10,),
                    //Button um Rechnung zu bezahlen, ruft die Methode payBill() auf.
                    FullWidthButton(buttonText: "Rechnung bezahlen", function: () => {
                      payBill()
                    }),
                  ],
                ),
              )
          ],
        )
    );
  }

  //Funktionsweise: Diese Methode lädt die Rechnung über die Methode fetchRechnung() und berechnet die Summe der aktuellen Rechnung.
  Future<void> loadRechnung() async {
    setState(() {
      sum = 0;
    });
    futureRechnung = fetchRechnung();
    var _sum = (await futureRechnung).sum();
    setState(() {
      sum = _sum;
    });
  }

  //Funktionsweise: Diese Methode lädt die Rechnung über einen GET Request aus dem Backend.
  Future<Rechnung> fetchRechnung() async {
    final response = await http.get(gastroMeApiUrl + '/tisch/ ' + tischId + '/currentRechnung',
        headers: {
          gastroMeApiAuthTokenName: gastroMeApiAuthTokenValue
        });

    if(response.statusCode == 200){
      return Rechnung.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception("Error: " + response.statusCode.toString() + "\n" + "Rechnung laden fehlgeschlagen!");
    }
  }


  //Funktionsweise: Diese Methode sendet einen PATCH Request an das Backend, mit der Information, dass die Rechnung bezahlt wurde.
  // Bei Erfolgreicher übertragung wird eine Mail an das Restaurant gesendet und die Rechnung neu geladen, bzw. eine neue Rechnung durch das Backend erstellt.
  void payBill() async {
    var response = await http.patch(gastroMeApiUrl + '/rechnung/' + rechnungGlobal.id + '/pay',
      headers: { gastroMeApiAuthTokenName: gastroMeApiAuthTokenValue });

    if(response.statusCode == 200){
      Rechnung rechnung = Rechnung.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      sendMailBillPayed();
      loadRechnung();
      print("Rechnung bezahlt: " + rechnung.billPayed.toString());
    } else {
      print("Etwas ist schiefgelaufen...");
      //TODO Handle Error
    }
  }

  //Funktionsweise: Diese Methode sendet eine Mail an die am Restaurant-Objekt hinterlegte Email-Adresse mit der Information, dass die Rechnung für einen Tisch bezahlt wurde.
  void sendMailBillPayed() async {
    String subject = 'Rechnung von Tisch: ' + tischId + " bezahlt!";
    final smtpServer = gmail(EmailUsername, EmailPassword);

    final body = Message()
      ..from = Address(EmailUsername, 'Waiter Tim')
      ..recipients.add(restaurant.email)
      ..subject = subject
      ..html = "<h1>Rechnung bezahlt</h1>\n<p>Tisch Nr: "+tischId+"</p>";

    try {
      final sendReport = await send(body, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

}

