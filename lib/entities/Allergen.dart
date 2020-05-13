import 'dart:typed_data';
import 'package:gastrome/entities/Getraenk.dart';
import 'package:gastrome/entities/Speise.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


class Allergen{
  final String id;
  List<Speise> speisen;
  List<Getraenk> getraenke;
  String name;
  String bezeichnung;
  Uint8List symbol;

  Allergen({this.id, this.speisen, this.getraenke, this.name, this.bezeichnung, this.symbol});

  factory Allergen.fromJson(Map<String, dynamic> json){
    if(json != null)
      return Allergen(
        id: json['id'],
        speisen: json['speisen'],
        getraenke: json['getraenke'],
        name: json['name'],
        bezeichnung: json['bezeichnung'],
        symbol: json['symbol'],
    );
    return null;
  }

}

Future<Allergen> fetchAllergen() async {
  final response =
  await http.get('https://jsonplaceholder.typicode.com/albums/1');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Allergen.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Allergen laden fehlgeschlagen');
  }
}