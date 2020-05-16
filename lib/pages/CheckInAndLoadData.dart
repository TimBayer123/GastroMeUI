import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gastrome/MainLayout.dart';
import 'package:gastrome/entities/Speisekarte.dart';
import 'package:http/http.dart' as http;
import 'package:progress_indicators/progress_indicators.dart';
import 'package:gastrome/settings/globals.dart';


class CheckInAndLoadData extends StatefulWidget {
  @override
  _CheckInAndLoadDataState createState() => _CheckInAndLoadDataState();
}

class _CheckInAndLoadDataState extends State<CheckInAndLoadData>{
  AnimationController animationController;
  Future<Speisekarte> futureSpeisekarte;
  Speisekarte loadedSpeisekarte;

  @override
  void initState() {
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
      child: FutureBuilder<Speisekarte>(
          future: futureSpeisekarte,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              loadedSpeisekarte = snapshot.data;
              return MainLayout(navBarindex: 0,loggedIn: true, speisekarte: loadedSpeisekarte);
            } else if (snapshot.hasError) {
              return Center(child: Text("${snapshot.error}", style:Theme.of(context).textTheme.headline4));
            }
            print('Laden noch nicht funktioniert');
            return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HeartbeatProgressIndicator(
                      child: Icon(Icons.store, color: Theme.of(context).accentColor, size: 40),
                    ),
                    SizedBox(height: 40),
                    FadingText(
                      'Sie werden eingecheckt...',
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
        gastroMeApiUrl + '/speisekarteByRestaurantId/0da85d23-185d-460a-ba10-690850997017',
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