import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';

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
  double entfernung;

  Restaurant({this.id, this.name, this.beschreibung, this.standort,
      this.rezessionen, this.speisekarte, this.bild, this.entfernung});

  String getGesamtbewertung(){
    double gesamtbwertung = 0;
    rezessionen.forEach((rezession) {
      if(rezession.bewertung != null){
        int rezessionPunkte = rezession.bewertung.essen + rezession.bewertung.atmosphaere + rezession.bewertung.preise + rezession.bewertung.service + rezession.bewertung.sonderwuensche;
        gesamtbwertung+=(rezessionPunkte/5);
      }
    });
    if(rezessionen.length > 0)
      return (gesamtbwertung/rezessionen.length).round().toString();
    return "-";
  }

  String getEntfernungAsString(){
    if(entfernung != null && entfernung > 999.99)
      return double.parse((entfernung/1000).toStringAsFixed(2)).toString().replaceAll(".", ",") + " km entfernt";
    else
      return entfernung != null ? (entfernung).round().toString() + " m entfernt" : "";
  }

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
        bild: base64Decode(json['bild'],),
        entfernung: 0,
      );
    }
    return null;
  }

}