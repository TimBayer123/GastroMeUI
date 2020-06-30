import 'package:gastrome/entities/Bewertung.dart';
import 'package:gastrome/entities/Restaurant.dart';
//Autor: Tim Bayer, Tim Riebesam
//Die Rezession Entität ist äquivalent zur Entität in der Backend Anwendung


class Rezession{
    final String id;
    Restaurant restaurant;
    Bewertung bewertung;
    String anmerkung;

    Rezession({this.id, this.restaurant, this.bewertung, this.anmerkung});

    //Diese Factory wandelt das JSON-Objekt in das äquivalente Dart-Objekt um
    factory Rezession.fromJson(Map<String, dynamic> json){
        if(json != null)
            return Rezession(
            id: json['id'],
            restaurant: json['restaurant'],
            bewertung: Bewertung.fromJson(json['bewertung']),
            anmerkung: json['anmerkung']);
        return null;
    }
}