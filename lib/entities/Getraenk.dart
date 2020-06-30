import 'dart:convert';
import 'dart:typed_data';
import 'package:gastrome/entities/Allergen.dart';
import 'package:gastrome/entities/Speisekarte.dart';
import 'package:gastrome/entities/SpeisekartenItem.dart';

//Autor: Tim Bayer, Tim Riebesam
//Die Getraenk Entität ist äquivalent zur Entität in der Backend Anwendung

class Getraenk extends SpeisekartenItem{
    final String id;
    Speisekarte speisekarte;
    List<Allergen> allergene;

  Getraenk(this.id, this.speisekarte, this.allergene, String name, String beschreibung, double preis, Uint8List bild, bool vegie, bool vegan, String erlaeuterung) : super(id, name, beschreibung, preis, bild, vegie, vegan, erlaeuterung);

    //Diese Factory wandelt das JSON-Objekt in das äquivalente Dart-Objekt um
    factory Getraenk.fromJson(Map<String, dynamic> json){
      var allergeneJson = json['allergene'] as List;
      List<Allergen> _allergene = allergeneJson.map((tagJson) => Allergen.fromJson(tagJson)).toList();
      if(json != null)
       return Getraenk(
          json['id'],
          json['speisekarte'],
          _allergene,
          json['name'],
          json['beschreibung'],
          json['preis'],
          base64Decode(json['bild']),
          json['vegie'],
          json['vegan'],
       json['erlaeuterung']);
      return null;
    }
}