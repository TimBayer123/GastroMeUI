import 'dart:typed_data';
import 'package:gastrome/entities/Getraenk.dart';
import 'package:gastrome/entities/Speise.dart';

//Autor: Tim Bayer, Tim Riebesam
//Die Allergen Entität ist äquivalent zur Entität in der Backend Anwendung

class Allergen{
  final String id;
  List<Speise> speisen;
  List<Getraenk> getraenke;
  String name;
  String bezeichnung;
  Uint8List symbol;

  Allergen({this.id, this.speisen, this.getraenke, this.name, this.bezeichnung, this.symbol});

  //Diese Factory wandelt das JSON-Objekt in das äquivalente Dart-Objekt um
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

  @override
  String toString(){
    return this.name;
  }
}
