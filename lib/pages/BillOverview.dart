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

class BillOverview extends StatefulWidget {
  @override
  _BillOverviewState createState() => _BillOverviewState();
}

class _BillOverviewState extends State<BillOverview> with SingleTickerProviderStateMixin  {
  Future<Rechnung> futureRechnung;
  double sum = 0;
  AnimationController controller;

  @override
  void initState() {
    loadRechnung();
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
            ((rechnungGlobal != null) && (rechnungGlobal.speisen != 0 || rechnungGlobal.getraenke != 0)) ?
              Expanded(
                child: FutureBuilder(
                    future: futureRechnung,
                    builder: (context, snapshot) {
                      if (snapshot.hasData){
                        Rechnung rechnung = snapshot.data;
                        List<SpeisekartenItem> items = new List();
                        items.addAll(rechnung.speisen);
                        items.addAll(rechnung.getraenke);
                        return Container(
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(sum.toStringAsFixed(2).replaceAll(".", ",") + " €", style: Theme.of(context).textTheme.headline4,)
                      ],
                    ),
                    SizedBox(height: 10,),
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

  void payBill() async {
    var response = await http.patch(gastroMeApiUrl + '/rechnung/' + rechnungGlobal.id + '/pay',
      headers: { gastroMeApiAuthTokenName: gastroMeApiAuthTokenValue });

    if(response.statusCode == 200){
      Rechnung rechnung = Rechnung.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      sendMailBillPayed();
      loadRechnung();
      print("Rechnung bezahlt: " + rechnung.billPayed.toString());
    } else {
      //TODO Handle Error
    }
  }

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

}

