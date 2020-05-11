import 'dart:convert';
import 'dart:typed_data';
import 'package:gastrome/entities/Allergen.dart';
import 'package:gastrome/entities/Speisekarte.dart';
import 'package:gastrome/entities/SpeisekartenItem.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as I;

class Speise extends SpeisekartenItem {
  final String id;
  Speisekarte speisekarte;
  List<dynamic> allergene;

  Speise(this.id, this.speisekarte, this.allergene, String name,
      String beschreibung, double preis, Uint8List bild, bool vegie, bool vegan)
      : super(
      id,
      name,
      beschreibung,
      preis,
      bild,
      vegie,
      vegan);

  factory Speise.fromJson(Map<String, dynamic> json){
    return Speise(
        json['id'],
        json['speisekarte'],
        json['allergene'],
        json['name'],
        json['beschreibung'],
        json['preis'],
        base64Decode(json['bild']),
        json['vegie'],
        json['vegan']);
  }
}
// Diese Methode ist zur Orientierung hier notiert, benutzt wird dieses Code snippet am Verwendungsort
Future<Speise> fetchSpeise() async {
  final response =
  await http.get('https://jsonplaceholder.typicode.com/albums/1');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Speise.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Speise laden fehlgeschlagen');
  }
}