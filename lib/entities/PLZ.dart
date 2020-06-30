import 'package:gastrome/entities/Standort.dart';
//Autor: Tim Riebesam, TIm Bayer
//Die PLZ Entität ist äquivalent zur Entität in der Backend Anwendung

class PLZ{
  final String id;
  List<Standort> standorte;
  int plz;
  String stadt;

  PLZ({this.id, this.standorte, this.plz, this.stadt});

  //Diese Methode wandelt das JSON-Objekt in das äquivalente Dart-Objekt um
  factory PLZ.fromJson(dynamic json){
    if(json != null)
      return PLZ(
        id: json['id'],
        plz: json['plz'],
        stadt: json['stadt']);
    return null;
  }
}