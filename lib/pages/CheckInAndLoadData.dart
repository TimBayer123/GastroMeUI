import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gastrome/MainLayout.dart';
import 'package:gastrome/entities/Speisekarte.dart';
import 'package:http/http.dart' as http;
import 'package:progress_indicators/progress_indicators.dart';


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
              return Text("${snapshot.error}");
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
    final response = await http.get(
        'http://GastromeApi-env.eba-gdpwc2as.us-east-2.elasticbeanstalk.com/speisekarteByRestaurantId/3aa6de1b-3451-4378-bb67-bfa406322ddd',
        //await http.get('https://jsonplaceholder.typicode.com/albums/1',
        headers: {
          'gastrome-api-auth-token': '4df6d7b9-ba79-4ae7-8a1c-cffbb657610a',
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