import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gastrome/MainLayout.dart';
import 'package:gastrome/entities/Restaurant.dart';
import 'package:gastrome/entities/Speisekarte.dart';
import 'package:gastrome/pages/QrCodeScanner.dart';
import 'package:http/http.dart' as http;
import 'package:progress_indicators/progress_indicators.dart';
import 'package:gastrome/settings/globals.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';


class CheckInAndLoadData extends StatefulWidget {
  String restaurantId;
  String tischNr;
  CheckInAndLoadData({this.restaurantId, this.tischNr});
  @override
  _CheckInAndLoadDataState createState() => _CheckInAndLoadDataState();
}

class _CheckInAndLoadDataState extends State<CheckInAndLoadData>{
  AnimationController animationController;
  Future<Speisekarte> futureSpeisekarte;
  Future<Restaurant> futureRestaurant;
  Speisekarte loadedSpeisekarte;

  @override
  void initState() {
    addGuestToTable();
    futureRestaurant = fetchRestaurant();
    futureSpeisekarte = fetchSpeisekarte();
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: !loggedIn ? Navigator.push(context, MaterialPageRoute(
        builder: (context) => QrCodeScan(),
      )):
      FutureBuilder(
          future:  Future.wait([futureRestaurant, futureSpeisekarte]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData && futureRestaurant!=null) {
              setGlobalDetails(snapshot.data[0]);
              loadedSpeisekarte = snapshot.data[1];
              return MainLayout(navBarindex: 0, speisekarte: loadedSpeisekarte);
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

  Future<bool> addGuestToTable() async {
    //await Future.delayed(Duration(seconds: 2));
    final response = await http.patch(
        gastroMeApiUrl + '/tisch/gaesteliste/add/' + widget.tischNr,
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

  void setGlobalDetails(Restaurant loadedRestaurant){
    tischId = widget.tischNr;
    restaurant = loadedRestaurant;
  }



}