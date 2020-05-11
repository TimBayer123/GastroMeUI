import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gastrome/entities/Speise.dart';
import 'package:gastrome/entities/Speisekarte.dart' as speisekarteFetch;
import 'package:gastrome/entities/Speisekarte.dart';
import 'package:gastrome/widgets/HeadlineWidget.dart';
import 'package:http/http.dart' as http;

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  Future<Speisekarte> futureSpeisekarte;
  @override
  void initState() {
    futureSpeisekarte = speisekarteFetch.fetchSpeisekarte();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          HeadlineWidget(restaurantName: 'Cafe Simple', callWaiterButton: true),
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
                          itemBuilder: (context, index) {
                            Speise speise = speisekarte.speisen[index];
                            return Card(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10,40,10,40),
                                child: Text(speise.name+ '  -  ' + speise.preis.toString()+' €'),
                              )
                            );


                          },
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    // By default, show a loading spinner.
                    return Center(child: CircularProgressIndicator());
                  }
              ),
            ),
          )
        ],
      ),
    );
  }

}
