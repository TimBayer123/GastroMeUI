import 'Getraenk.dart';

//Autor: Tim Riebesam, Tim Bayer
//Die Getraenk-Entität ist äquivalent zur Entität in der Backend Anwendung

class GetraenkOrder{
  final String id;
  Getraenk getraenk;
  bool ausgeliefert;

  GetraenkOrder({this.id, this.getraenk, this.ausgeliefert});

  //Diese Factory wandelt das JSON-Objekt in das äquivalente Dart-Objekt um
  factory GetraenkOrder.fromJson(Map<String, dynamic> json){
    Getraenk _getraenk = Getraenk.fromJson(json['getraenk']);
    return GetraenkOrder(
      id: json['id'],
      getraenk: _getraenk,
      ausgeliefert: json['ausgeliefert'],
    );
  }

}