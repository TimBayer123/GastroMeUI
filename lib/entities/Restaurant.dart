import 'dart:convert';
import 'dart:typed_data';

import 'package:gastrome/entities/Rezession.dart';
import 'package:gastrome/entities/Speisekarte.dart';
import 'package:gastrome/entities/Standort.dart';


class Restaurant{
  final String id;
  String name;
  String beschreibung;
  Standort standort;
  List<Rezession> rezessionen;
  Speisekarte speisekarte;
  Uint8List bild;

  Restaurant({this.id, this.name, this.beschreibung, this.standort,
      this.rezessionen, this.speisekarte, this.bild});

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    if(json != null){
      var rezessionenJson = json['rezessionen'] as List;
      List<Rezession> _rezessionen = rezessionenJson.map((tagJson) => Rezession.fromJson(tagJson)).toList();

      return Restaurant(
        id: json['id'],
        name: json['name'],
        beschreibung: json['beschreibung'],
        standort: Standort.fromJson(json['standort']),
        rezessionen: _rezessionen,
        bild: base64Decode(json['bild']),
      );
    }
    return null;
  }

}