import 'package:gastrome/entities/PLZ.dart';
import 'package:gastrome/entities/Restaurant.dart';

class Standort {
  final int id;
  Restaurant restaurant;
  PLZ plz;
  String strasse;
  String hausnummer;
  String laengengrad;
  String breitengrad;
  String beschreibung;


  Standort({this.id, this.restaurant, this.plz, this.strasse, this.hausnummer,
    this.laengengrad, this.breitengrad, this.beschreibung});

}
