import 'dart:typed_data';

import 'package:gastrome/entities/Allergen.dart';
import 'package:gastrome/entities/Speise.dart';
import 'package:gastrome/entities/Speisekarte.dart';
import 'package:gastrome/entities/SpeisekartenItem.dart';

class Getraenk extends SpeisekartenItem{
    final String id;
    Speisekarte speisekarte;
    List<Allergen> allergene;

  Getraenk(this.id, this.speisekarte, this.allergene, String name, String beschreibung, double preis, Uint8List bild, bool vegie, bool vegan) : super(id, name, beschreibung, preis, bild, vegie, vegan);


    factory Getraenk.fromJson(Map<String, dynamic> json){
      if(json != null)
       return Getraenk(
          json['id'],
          json['speisekarte'],
          json['allergene'],
          json['name'],
          json['beschreibung'],
          json['preis'],
          json['bild'],
          json['vegie'],
          json['vegan']);
      return null;
    }
}