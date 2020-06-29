import 'package:flutter/material.dart';
import 'package:gastrome/entities/Getraenk.dart';
import 'package:gastrome/entities/Restaurant.dart';
import 'package:gastrome/entities/Speise.dart';
import 'package:gastrome/entities/Speisekarte.dart';
import 'package:http/http.dart' as http;
import 'package:gastrome/settings/globals.dart';
import 'dart:convert';
import 'MenuCardWidget.dart';

//Autor: Tim Riebesam
//Diese Klasse stellt die Speisekarte in der Klasse MenuItemDetails dar.
//Es wird die Speisekarte auf dem Backend geladen und die einzelnen Items als Liste dargestellt.

class MenuLogedOutWidget extends StatefulWidget {
  Restaurant restaurant;

  //im Konstruktor wird das Restaurant übergeben
  MenuLogedOutWidget({this.restaurant});

  @override
  _MenuLogedOutWidgetState createState() => _MenuLogedOutWidgetState();
}

class _MenuLogedOutWidgetState extends State<MenuLogedOutWidget> with TickerProviderStateMixin{
  TabController tabController;
  bool changeTab;
  bool showFood;
  Future<Speisekarte> futureSpeisekarte;

  //Funktionsweise: Diese Methode ruft bei Initialisierung die Methoden zum Laden der Speisekarte auf.
  @override
  void initState() {
    changeTab = false;
    showFood = true;
    //Initialisierung des TabControllers mit Zwei Optionen (Speisen/Getränke)
    tabController = TabController(initialIndex: 0, length: 2, vsync: this);

    tabController.animation.addListener(() {
      if (changeTab) {
        tabController.index == 0 ? showFood = true : showFood = false;
        changeTab = false;
        setState(() {});
      }
    });

    //Laden der Speisekarte
    futureSpeisekarte = fetchSpeisekarte();
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  //Funktionsweise: Diese Methode liefert die Oberfläche des Widgets
  //Rückgabewert: Die Methode liefert die gesamte Oberfläche in Form eines Widgets
  //Übergabeparameter: Der BuildContext wird implizit übergeben
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 700,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            elevation: 0.0,
            flexibleSpace: Center(
              child: SafeArea(
                child: TabBar(
                  controller: tabController,
                  indicatorColor: Theme.of(context).accentColor,
                  indicatorPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  onTap: (int index) {
                    changeTab = true;
                  },
                  tabs: [
                    Tab(
                        icon: Icon(Icons.fastfood,
                            color: !showFood
                                ? Colors.black54
                                : Theme.of(context).accentColor)),
                    Tab(
                        icon: Icon(Icons.local_cafe,
                            color: showFood
                                ? Colors.black54
                                : Theme.of(context).accentColor)),
                  ]
                ),
              ),
            ),
          ),
          body: TabBarView(
            controller: tabController,
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(height: 10,),
                  FutureBuilder(
                    future: futureSpeisekarte,
                    builder: (context, snapshot){
                      //Wenn Daten vorhanden weiter, alternativ zeige Fehlermeldung
                      if(snapshot.hasData){
                        Speisekarte speisekarte = snapshot.data;
                        //Wenn tatsächliche Daten vorhanden zeige für jedes Item auf der Speisekarte ein menuCardWidget, alternativ zeige Meldung dass keine Daten vorhanden.
                        if(speisekarte.speisen.length > 0)
                          return Container(
                            height: MediaQuery.of(context).size.height - 250,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: speisekarte.speisen.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index){
                                Speise speise = speisekarte.speisen[index];
                                return MenuCardWidget(speise: speise);
                              },
                            ),
                          );
                        else
                          return Container(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Text(
                              "Dieses Restaurant bietet leider keine Speisen an.",
                              style: Theme.of(context).textTheme.headline5,
                              textAlign: TextAlign.center,
                            ),
                          );
                      } else {
                        return Container(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.sentiment_dissatisfied,
                                size: 160,
                                color: Theme.of(context).accentColor,
                              ),
                              Text(
                                "Wir konnten keine Speisekarte laden.\n\nBitte prüfe Deine Internetverbindung.",
                                style: Theme.of(context).textTheme.headline5,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  )
                ],
              ),
              //Selbiges wie für die Speisen, diesmal für die Getränke.
              Column(
                children: <Widget>[
                  SizedBox(height: 10,),
                  FutureBuilder(
                    future: futureSpeisekarte,
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        Speisekarte speisekarte = snapshot.data;
                        if(speisekarte.getraenke.length > 0)
                          return Container(
                            height: MediaQuery.of(context).size.height - 250,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: speisekarte.getraenke.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index){
                                Getraenk getraenk = speisekarte.getraenke[index];
                                return MenuCardWidget(getraenk: getraenk);
                              },
                            ),
                          );
                        else
                          return Container(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Text(
                                  "Dieses Restaurant bietet leider keine Getränke an.",
                                  style: Theme.of(context).textTheme.headline5,
                                  textAlign: TextAlign.center,
                                ),
                          );
                      } else {
                        return Container(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.sentiment_dissatisfied,
                                size: 160,
                                color: Theme.of(context).accentColor,
                              ),
                              Text(
                                "Wir konnten keine Speisekarte laden.\n\nBitte prüfe Deine Internetverbindung.",
                                style: Theme.of(context).textTheme.headline5,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Funktionsweise: Diese Methode lädt die Speisekarte über einen GET Request
  //Rückgabewert: es wird asynchron ein Future des Typs Speisekarte zurückgeliefert, da das Ergebnis der Request nicht direkt vorliegt
  Future<Speisekarte> fetchSpeisekarte() async {
    //await Future.delayed(Duration(seconds: 2));
    final response = await http.get(
        gastroMeApiUrl + '/speisekarte/restaurant/' + widget.restaurant.id,
        headers: {
          gastroMeApiAuthTokenName : gastroMeApiAuthTokenValue,
        });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Speisekarte.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Speisekarte laden fehlgeschlagen');
    }
  }

}
