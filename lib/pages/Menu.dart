import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gastrome/entities/Getraenk.dart';
import 'package:gastrome/entities/Speise.dart';
import 'package:gastrome/entities/Speisekarte.dart';
import 'package:gastrome/widgets/MenuCardWidget.dart';
import 'package:gastrome/widgets/HeadlineWidget.dart';
import 'package:http/http.dart' as http;

class Menu extends StatefulWidget {
  bool showFoodNotDrinks;

  Menu({this.showFoodNotDrinks});
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  Future<Speisekarte> futureSpeisekarte;
  @override
  void initState() {
    futureSpeisekarte = fetchSpeisekarte();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          HeadlineWidget(restaurantName: 'Café Simple', callWaiterButton: true),
          Expanded(
            child: Container(
              child: FutureBuilder(
                  //Hier Weitermachen. Aber morgen
                  future: futureSpeisekarte,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Speisekarte speisekarte = snapshot.data;
                      return Container(
                        child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: speisekarte.speisen.length,
                                itemBuilder: widget.showFoodNotDrinks
                                    ? (context, index) {
                                        Speise speise =
                                            speisekarte.speisen[index];
                                        return MenuCardWidget(item: speise);
                                      }
                                    : (context, index) {
                                        Getraenk getraenk =
                                            speisekarte.getraenke[index];
                                        return MenuCardWidget(item: getraenk);
                                      })

                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    // By default, show a loading spinner.
                    return Center(child: CircularProgressIndicator());
                  }),
            ),
          )
        ],
      ),
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
