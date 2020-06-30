import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gastrome/entities/Rezession.dart';
import 'package:gastrome/settings/globals.dart';
import 'package:gastrome/widgets/RezessionItemWidget.dart';
import 'package:http/http.dart' as http;
import 'package:progress_indicators/progress_indicators.dart';

//Autor: Tim Bayer, Tim Riebesam
//Diese Klasse zeigt alle Rezessionen eines Restuarants an

class RezessionenWidget extends StatefulWidget {
  static GlobalKey rezessionenKey = GlobalKey();
  String restaurantId;

  //Der Konstruktor der Klasse
  RezessionenWidget({this.restaurantId});
  @override
  _RezessionenWidgetState createState() => _RezessionenWidgetState();
}

class _RezessionenWidgetState extends State<RezessionenWidget> {
  Future<List<Rezession>> futureRezessionen;

  //Bei Initialisierung werden die Rezessionen geladen
  @override
  void initState() {
    print('restaurantId: '+widget.restaurantId);
    futureRezessionen = fetchRezessionen();
    super.initState();
  }

  //Funktionsweise: Diese Methode liefert die Oberfläche des RezessionenWidgets
  //Rückgabewert: Die Methode liefert die Oberfläche in Form eines Widgets
  //Übergabeparameter: Der BuildContext wird implizit übergeben
  @override
  Widget build(BuildContext context) {
    //Der Inhalt ist in eine ScrollView gewrapped, da das RezessionenWidget dynamisch ein- und ausgeklappt werden kann. Durch die ScrollView kommt es nicht zu einem Overlflow
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Container(
        child: Column(
          key: RezessionenWidget.rezessionenKey,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(),
            Text('Rezessionen:', style: Theme.of(context).textTheme.headline5,),
            Divider(),
            //Sind die Rezessionen geladen, werden diese hier angezgeigt
            FutureBuilder(
              future: futureRezessionen,
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.hasData) {
                    List<Rezession> rezessionen = snapshot.data;
                      return Container(
                        child: ListView.builder(
                          padding: EdgeInsets.all(0),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: rezessionen.length,
                          itemBuilder: (context, index) {
                           Rezession rezession = rezessionen[index];
                            return RezessionItemWidget(rezession: rezession);
                          },
                        ),
                      );
                  } else {
                    return Center(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              HeartbeatProgressIndicator(
                                child: Icon(Icons.format_list_bulleted, color: Theme.of(context).accentColor, size: 15),
                              ),
                              SizedBox(height: 20),
                              FadingText(
                                'Die Gäste werden befragt...',
                                style: Theme.of(context).textTheme.bodyText2,
                              )

                            ],
                          ),
                        ));
                  }
                }
            ),
            SizedBox(height: 20),
          ],
        ),
      ),

    );
  }

  //Funktionsweise: Es werden alle Rezessionen eines Restaurants über eine Get-Request geladen
  //Rückgabeparameter: Es werden alle Rezessionen in Form einer Future zurückgeliefert
  Future<List<Rezession>> fetchRezessionen() async {
    print('Laden läuft');
    final response = await http.get(
        gastroMeApiUrl + '/rezession/all/restaurant/' + widget.restaurantId,
        headers: {
          gastroMeApiAuthTokenName : gastroMeApiAuthTokenValue,
        });

    print(widget.restaurantId);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print("Statuscode 200");
      List<Rezession> rezessionen = new List();
      List<dynamic> rezessionenJSON = json.decode(utf8.decode(response.bodyBytes));

      rezessionenJSON.forEach((restaurantJson) async {
        rezessionen.add(Rezession.fromJson(restaurantJson));
      });
      return rezessionen;
    } else {
      print("Statuscode 400");
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Rezessionen laden fehlgeschlagen');
    }
  }
}
