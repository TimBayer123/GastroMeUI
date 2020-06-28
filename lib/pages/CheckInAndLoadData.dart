import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gastrome/Home.dart';
import 'package:gastrome/entities/Restaurant.dart';
import 'package:gastrome/entities/Speisekarte.dart';
import 'package:gastrome/pages/QrCodeScanner.dart';
import 'package:http/http.dart' as http;
import 'package:progress_indicators/progress_indicators.dart';
import 'package:gastrome/settings/globals.dart';

//Autor: Tim Bayer
//Diese Klasse stellt den Lade-Screen nach dem Login dar. Hier werden die Speisekarte und die Restaurantdaten geladen.
//Ebenso wird dem Tisch des QR Codes ein Gast hinzugefügt.

class CheckInAndLoadData extends StatefulWidget {
  String restaurantId;
  String tischId;
  //Der Konstruktor der Klasse besteht aus der Restaurant- und Tisch-ID
  CheckInAndLoadData({this.restaurantId, this.tischId});
  @override
  _CheckInAndLoadDataState createState() => _CheckInAndLoadDataState();
}

class _CheckInAndLoadDataState extends State<CheckInAndLoadData>{
  AnimationController animationController;
  Future<Speisekarte> futureSpeisekarte;
  Future<Restaurant> futureRestaurant;
  Speisekarte loadedSpeisekarte;

  //Funktionsweise: Diese Methode ruft bei Initialisierung die Methoden zum Laden der Speisekarte und den Restaurantdaten auf. Ebenso die Methode zum HInzufügen eines Gastes aufgerufen
  @override
  void initState() {
    //Bei Initialisierung des Lade-Screens, wird ein Gast zum Tisch hinzugefügt,...
    addGuestToTable();
    //...die Restaurantdaten geladen und...
    futureRestaurant = fetchRestaurant();
    //...die Speisekarte geladen
    futureSpeisekarte = fetchSpeisekarte();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //Funktionsweise: Diese Methode liefert die Oberfläche des Ladescreens
  //Rückgabewert: Die Methode liefert die gesamte Oberfläche in Form eines Widgets
  //Übergabeparameter: Der BuildContext wird implizit übergeben
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      //Ist der globale Parameter loggedIn=false wird der QRCodeScaner aufgerufen.
      child: !loggedIn ? Navigator.push(context, MaterialPageRoute(
        builder: (context) => QrCodeScan(),
      )):
      //Der FutureBuilder kann Widgets verarbeiten, die erst in Zukunft existieren.
      //Sind die Futures Restaurant und Speisekarte geladen, wird der HomeScreen angezeigt.
      //Ansonsten wird ein Lade-Widget angezeigt.
      FutureBuilder(
          future:  Future.wait([futureRestaurant, futureSpeisekarte]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData && futureRestaurant!=null) {
              setGlobalDetails(snapshot.data[0]);
              loadedSpeisekarte = snapshot.data[1];
              return Home(navBarindex: 0, speisekarte: loadedSpeisekarte);
            } else if (snapshot.hasError) {
              return Center(child: Text("${snapshot.error}", style:Theme.of(context).textTheme.headline4));
            }
            return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HeartbeatProgressIndicator(
                      child: Icon(Icons.store, color: Theme.of(context).accentColor, size: 40),
                    ),
                    SizedBox(height: 40),
                    FadingText(
                      'Wir bereiten ihren Tisch vor...',
                      style: Theme.of(context).textTheme.headline4,
                    )

                  ],
                ));
          }),
    );
  }

  //Funktionsweise: Diese Methode lädt die Speisekarte über eine GET Request
  //Rückgabewert: es wird asynchron ein Future des Typs Speisekarte zurückgeliefert, da das Ergebnis der Request nicht direkt vorliegt
  Future<Speisekarte> fetchSpeisekarte() async {
    //await Future.delayed(Duration(seconds: 2));
    final response = await http.get(
        gastroMeApiUrl + '/speisekarte/restaurant/' + widget.restaurantId,
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

  //Funktionsweise: Diese Methode lädt die Restaurant-Daten über eine GET Request
  //Rückgabewert: es wird asynchron ein Future des Typs Restaurant zurückgeliefert, da das Ergebnis der Request nicht direkt vorliegt
  Future<Restaurant> fetchRestaurant() async {
    //await Future.delayed(Duration(seconds: 2));
    final response = await http.get(
        gastroMeApiUrl + '/restaurant/' + widget.restaurantId,
        headers: {
          gastroMeApiAuthTokenName : gastroMeApiAuthTokenValue,
        });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Restaurant.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Restaurant laden fehlgeschlagen');
    }
  }

  //Funktionsweise: Diese Methode fügt den Gast einem Tisch hinzu. Dies geschieht asynchron
  //Rückgabewert: es wird ein Future des Typs bool zurückgeliefert.
  Future<bool> addGuestToTable() async {
    //await Future.delayed(Duration(seconds: 2));
    final response = await http.patch(
        gastroMeApiUrl + '/tisch/gaesteliste/add/' + widget.tischId,
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

  //Funktionsweise: in dieser Methode werden die gloaben Variablen TischId und Restaurant gesetzt.
  void setGlobalDetails(Restaurant loadedRestaurant){
    tischId = widget.tischId;
    restaurant = loadedRestaurant;
  }



}