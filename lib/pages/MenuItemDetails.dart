import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gastrome/entities/Getraenk.dart';
import 'package:gastrome/entities/Speise.dart';
import 'package:gastrome/widgets/AllergeneIcons.dart';
import 'package:gastrome/widgets/VeganVegieIcons.dart';
import 'package:http/http.dart' as http;
import 'package:gastrome/settings/globals.dart';
import 'package:gastrome/entities/Rechnung.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

//Autor: Tim Bayer, Tim Riebesam
//Diese Klasse stellt die Oberfläche einer Speisen- oder Getränkeübersicht dar. Sie übermittelt zudem die Getränkebestellung an das Backend und per Email an das Restaurant
class MenuItemDetails extends StatefulWidget {
  static OverlayEntry overlayEntry;
  Getraenk getraenk;
  Speise speise;
  //Der Konstruktor der Klasse, es wird die anzuzeigende Speise oder Getränk übergeben
  MenuItemDetails({this.speise, this.getraenk});

  @override
  _MenuItemDetailsState createState() => _MenuItemDetailsState();

  static OverlayEntry getOverlay() {
    return overlayEntry;
  }
}

class _MenuItemDetailsState extends State<MenuItemDetails>
    with SingleTickerProviderStateMixin {
  dynamic item;
  AnimationController animationController;
  double containerHeight;

  //Funktionsweise: Diese Methode prüft bei Initialisierung ob eine Speise oder ein Getränk übergeben wurde. Ebenso wird ein AnimationController instantiiert
  @override
  void initState() {
    if (widget.speise != null)
      item = widget.speise;
    else if (widget.getraenk != null) item = widget.getraenk;

    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    super.initState();
    //Diese Methode wird ausgeführt, sobald alle Widgets vollständig geladen sind
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        animationController.forward();
      });
    });
  }

//Funktionsweise: Die Dispose Methode beendet die erstellten Controller, um den Speicherplatz freizugeben
  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  //Funktionsweise: Diese Methode liefert die Oberfläche der Speisen- oder Getränkeübersicht
  //Rückgabewert: Die Methode liefert die gesamte Oberfläche in Form eines Widgets
  //Übergabeparameter: Der BuildContext wird implizit übergeben
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: loggedIn ? MediaQuery.of(context).size.height - 55 : MediaQuery.of(context).size.height - 75,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //Animation, die die Seite einfliegen lässt
              SizeTransition(
                sizeFactor: animationController,
                axis: Axis.vertical,
                axisAlignment: -1,
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.transparent,
                      height: 5,
                    ),
                    //Schatten unter der Speisen-/Getränkeübersicht
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(40.0),
                            topRight: const Radius.circular(40.0)),
                        boxShadow: <BoxShadow>[
                          new BoxShadow(
                            color: Colors.black26,
                            blurRadius: 2.0,
                            offset: new Offset(0.0, -2.0),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(40.0),
                            topRight: const Radius.circular(40.0)),
                        child: Container(
                          height: loggedIn ? MediaQuery.of(context).size.height - 100 : MediaQuery.of(context).size.height - 120,
                          child: Column(
                            children: [
                              AspectRatio(
                                aspectRatio: 3 / 1.5,
                                child: Stack(
                                  children: [
                                    //Das Bild der Speise oder des Getränks
                                    Container(
                                      decoration: new BoxDecoration(
                                        image: new DecorationImage(
                                            fit: BoxFit.fitWidth,
                                            alignment: FractionalOffset.center,
                                            image:
                                                Image.memory(item.bild).image),
                                      ),
                                    ),
                                    Positioned(
                                        top: 10,
                                        right: 10,
                                        child: GestureDetector(
                                          //Wird das Overlay geschlossen, schließt sich die Übersicht animiert nach unten
                                          onTap: () {
                                            animationController.reverse();
                                            MenuItemDetails.overlayEntry=null;
                                          },
                                          child: Container(
                                            color: Colors.transparent,
                                            width: 50,
                                            height: 50,
                                            child: Center(
                                              child: Icon(
                                                Icons.close,
                                                color: Theme.of(context)
                                                    .accentIconTheme
                                                    .color,
                                                size: 30,
                                              ),
                                            ),
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  color: Theme.of(context).primaryColor,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                                    child: ListView(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(item.name,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline1),
                                            ),
                                            item.vegan
                                                ? VeganIcon()
                                                : item.vegie
                                                    ? VegieIcon()
                                                    : SizedBox(width: 50),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 30, 0, 30),
                                          child: Text(
                                            item.erlaeuterung!=null ? item.erlaeuterung : item.beschreibung,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 20, 0, 10),
                                          child: Text('Allergene',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4),
                                        ),
                                        Row(
                                          //Hier werden die ALlergene angezeigt. Ist das ensprechende Allergen enthalten wird ein Icon angezeigt, ansonsten eine leere Box mit Größe 0
                                          children: [
                                            item.allergene.toString().contains(
                                                    "Glutenhaltiges Getreide")
                                                ? WheatIcon()
                                                : SizedBox(
                                                    width: 0,
                                                  ),
                                            item.allergene
                                                    .toString()
                                                    .contains('Eier')
                                                ? EggIcon()
                                                : SizedBox(
                                                    width: 0,
                                                  ),
                                            item.allergene
                                                    .toString()
                                                    .contains('Erdnüsse')
                                                ? NutsIcon()
                                                : SizedBox(
                                                    width: 0,
                                                  ),
                                            item.allergene
                                                .toString()
                                                .contains('Milch und Milchprodukte')
                                                ? MilkIcon()
                                                : SizedBox(
                                              width: 0,
                                            ),
                                            !item.allergene
                                                        .toString()
                                                        .contains('Erdnüsse') &&
                                            !item.allergene
                                                        .toString()
                                                        .contains(
                                                            "Glutenhaltiges Getreide") &&
                                            !item.allergene
                                                        .toString()
                                                        .contains('Eier') &&
                                            !item.allergene
                                                    .toString()
                                                    .contains('Milch und Milchprodukte')
                                                ? Text(
                                                    "Keine Allergene enthalten",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline4,
                                                  )
                                                : SizedBox(
                                                    width: 0,
                                                  ),
                                          ],
                                        ),
                                        SizedBox(height: 20,),
                                        //Hier können Getränke über einen Button bestellt werden
                                        item is Getraenk && loggedIn ?
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              RaisedButton(
                                                color: Theme.of(context).accentColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                padding: EdgeInsets.all(10),
                                                onPressed: () => orderGetraenkDialogBox(item),
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(
                                                      item.preis.toStringAsFixed(2).replaceAll(".", ",") + " € - bestellen ",
                                                      style: Theme.of(context).textTheme.headline3,),
                                                    Icon(
                                                      Icons.arrow_forward_ios,
                                                      color: Theme.of(context).primaryColor,)
                                                  ],
                                                ),
                                              )
                                            ],
                                          ) : SizedBox(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  //Funktionsweise: Es wird ein Bestätigungsdialog angezeigt, ob das Getränk bestellt werden möchte.
  //Übergabeparameter: Es wird das zu bestellende Getränk übergeben
  void orderGetraenkDialogBox(Getraenk getraenk){
    Widget cancelButton = FlatButton(
      child: Text("Abbrechen"),
      onPressed:  (){
        animationController.forward();
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Bestellen"),
      onPressed: () => orderGetraenk(getraenk),
    );

    // set up the AlertDialog
    AlertDialog orderGetraenkDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(getraenk.name + " bestellen"),
      content: Text("Möchtest Du wirklich einen " + getraenk.name + " für " + getraenk.preis.toStringAsFixed(2).replaceAll(".", ",") + " € bestellen?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        animationController.reverse();
        return orderGetraenkDialog;
      },
    );
  }

  //Funktionsweise: Es wird die Rechnung für einen Tisch über eine Get-Request asynchron geladen.
  //Rückgabewert: Es wird das Rechnungsobjekt als Future zurückgeliefert
  Future<Rechnung> getRechnungForTisch() async {
    var response = await http.get(gastroMeApiUrl + '/tisch/' + tischId + '/currentRechnung',
        headers: { gastroMeApiAuthTokenName: gastroMeApiAuthTokenValue });

    if(response.statusCode == 200){
      Rechnung rechnung = Rechnung.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      rechnungGlobal = rechnung;
      return  rechnung;
    } else {
      //TODO Handle Error
    }
  }

  //Funktionsweise: Es wird ein Getränk über eine Patch-Request bestellt bzw. der Rechnung des Tisches hinzugefügt
  //Übergabeparameter: Es wird das zu bestellende Getränk übergeben
  void orderGetraenk(Getraenk getraenk) async {
    var response = await http.patch(gastroMeApiUrl + '/rechnung/' + (await getRechnungForTisch()).id + '/add/getraenk',
        body: getraenk.id,
        headers: { gastroMeApiAuthTokenName: gastroMeApiAuthTokenValue });

    if(response.statusCode == 200){
      Rechnung rechnung = Rechnung.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      sendMailGetraenkOrder(getraenk, rechnung);
      animationController.forward();
      Navigator.pop(context);
      //TODO Animation: Betrag zu Rechnung hinzugefügt.
    } else {
      //TODO Handle Error
    }
  }

  //Funktionsweise: Es wird die Getränkebestellung an die hinterlegte Email-Adresse gesendet.
  //Übergabeparameter: Es wird das zu bestellende Getränk und die Rechnung übergeben
  void sendMailGetraenkOrder(Getraenk getraenk, Rechnung rechnung) async {
    String subject = 'Bestellung von ' + getraenk.name + " für Tisch-Nr. " + tischId;
    final smtpServer = gmail(EmailUsername, EmailPassword);

    final body = Message()
      ..from = Address(EmailUsername, 'Waiter Tim')
      ..recipients.add(restaurant.email)
      ..subject = subject
      ..html = "<h1>Bestellung</h1>\n<p>Tisch Nr: "+tischId+"</p><p>Getraenk Nr: "+getraenk.id.toString()+" ( "+ getraenk.name + ")</p>"+"<p>Rechnung Nr: "+rechnung.id.toString()+"</p>";

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
