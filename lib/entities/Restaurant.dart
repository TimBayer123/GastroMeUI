import 'dart:convert';
import 'dart:typed_data';
import 'package:gastrome/entities/Rezession.dart';
import 'package:gastrome/entities/Speisekarte.dart';
import 'package:gastrome/entities/Standort.dart';

//Autor: Tim Riebesam, Tim Bayer
//Die Restaurant Entität ist äquivalent zur Entität in der Backend Anwendung

class Restaurant{
  final String id;
  String name;
  String beschreibung;
  Standort standort;
  List<Rezession> rezessionen;
  Speisekarte speisekarte;
  Uint8List bild;
  double entfernung;
  String email;

  Restaurant({this.id, this.name, this.beschreibung, this.standort,
      this.rezessionen, this.speisekarte, this.bild, this.entfernung, this.email});

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

  int getEssensBewertung(){
    double bewertung = 0;
    rezessionen.forEach((rezession) {
      if(rezession.bewertung != null)
        bewertung+=rezession.bewertung.essen;
    });
    if(rezessionen.length > 0)
      return (bewertung/rezessionen.length).round();
    return 0;
  }

  int getAtmosphaereBewertung(){
    double bewertung = 0;
    rezessionen.forEach((rezession) {
      if(rezession.bewertung != null)
        bewertung+=rezession.bewertung.atmosphaere;
    });
    if(rezessionen.length > 0)
      return (bewertung/rezessionen.length).round();
    return 0;
  }

  int getPreiseBewertung(){
    double bewertung = 0;
    rezessionen.forEach((rezession) {
      if(rezession.bewertung != null)
        bewertung+=rezession.bewertung.preise;
    });
    if(rezessionen.length > 0)
      return (bewertung/rezessionen.length).round();
    return 0;
  }

  int getServiceBewertung(){
    double bewertung = 0;
    rezessionen.forEach((rezession) {
      if(rezession.bewertung != null)
        bewertung+=rezession.bewertung.service;
    });
    if(rezessionen.length > 0)
      return (bewertung/rezessionen.length).round();
    return 0;
  }

  int getSonderwuenscheBewertung(){
    double bewertung = 0;
    rezessionen.forEach((rezession) {
      if(rezession.bewertung != null)
        bewertung+=rezession.bewertung.sonderwuensche;
    });
    if(rezessionen.length > 0)
      return (bewertung/rezessionen.length).round();
    return 0;
  }

  String getEntfernungAsString(){
    if(entfernung != null && entfernung > 999.99)
      return double.parse((entfernung/1000).toStringAsFixed(2)).toString().replaceAll(".", ",") + " km entfernt";
    else
      return entfernung != null ? (entfernung).round().toString() + " m entfernt" : "";
  }

  //Diese Factory wandelt das JSON-Objekt in das äquivalente Dart-Objekt um
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
        email: json['email']
      );
    }
    return null;
  }

}