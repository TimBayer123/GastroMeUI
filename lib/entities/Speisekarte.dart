import 'package:gastrome/entities/Getraenk.dart';
import 'package:gastrome/entities/Restaurant.dart';
import 'package:gastrome/entities/Speise.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Speisekarte{
  final String id;
  Restaurant restaurant;
  List<Speise> speisen;
  List<dynamic> getraenke;

  Speisekarte({this.id, this.restaurant, this.speisen, this.getraenke});

  factory Speisekarte.fromJson(Map<String, dynamic> json){
    var speisenJson = json['speisen'] as List;
    List<Speise> _speisen = speisenJson.map((tagJson) => Speise.fromJson(tagJson)).toList();
    return Speisekarte(
      id: json['id'],
      restaurant: json['restaurant'],
      speisen: _speisen,
      getraenke: json['getraenke'],
    );
  }


}

Future<Speisekarte> fetchSpeisekarte() async {
  final response =
  await http.get('http://GastromeApi-env.eba-gdpwc2as.us-east-2.elasticbeanstalk.com/speisekarteByRestaurantId/3aa6de1b-3451-4378-bb67-bfa406322ddd',
  //await http.get('https://jsonplaceholder.typicode.com/albums/1',
      headers: {
        'gastrome-api-auth-token': '4df6d7b9-ba79-4ae7-8a1c-cffbb657610a',
      });

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Speisekarte.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Speisekarte laden fehlgeschlagen');
  }
}