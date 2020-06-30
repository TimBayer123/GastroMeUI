import 'package:gastrome/entities/PLZ.dart';
import 'package:gastrome/entities/Restaurant.dart';

class Standort {
  final String id;
  Restaurant restaurant;
  PLZ plz;
  String strasse;
  String hausnummer;
  double laengengrad;
  double breitengrad;
  String beschreibung;


  Standort({this.id, this.restaurant, this.plz, this.strasse, this.hausnummer,
    this.laengengrad, this.breitengrad, this.beschreibung});

  //Diese Methode wandelt das JSON-Objekt in das äquivalente Dart-Objekt um
  factory Standort.fromJson(dynamic json){
    if(json != null)
      return Standort(
        id: json['id'],
        restaurant: json['restaurant'],
        plz: PLZ.fromJson(json['plz']),
        strasse: json['strasse'],
        hausnummer: json['hausnummer'],
        laengengrad: json['laengengrad'],
        breitengrad: json['breitengrad'],
        beschreibung: json['beschreibung']);
    return null;
  }

  String asText(){
    return plz.plz.toString() + " " + plz.stadt + "\n" + strasse + " " + hausnummer;
  }

}
