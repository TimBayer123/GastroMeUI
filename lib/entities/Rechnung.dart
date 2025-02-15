import 'package:gastrome/entities/GetraenkOrder.dart';
import 'Speise.dart';

//Autor: Tim Riebesam, Tim Bayer
//Die Rechnung Entität ist äquivalent zur Entität in der Backend Anwendung

class Rechnung{
  final String id;
  List<Speise> speisen;
  List<GetraenkOrder> getraenkOrders;
  DateTime timestamp;
  bool billPayed;

  Rechnung({this.id, this.speisen, this.getraenkOrders, this.timestamp, this.billPayed});

  //Diese Factory wandelt das JSON-Objekt in das äquivalente Dart-Objekt um
  factory Rechnung.fromJson(Map<String, dynamic> json){
    var speisenJson = json['speisen'] as List;
    List<Speise> _speisen = speisenJson.map((tagJson) => Speise.fromJson(tagJson)).toList();
    var getraenkOrdersJson = json['getraenkOrders'] as List;
    List<GetraenkOrder> _getraenkOrders = getraenkOrdersJson.map((tagJson) => GetraenkOrder.fromJson(tagJson)).toList();
    return Rechnung(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      speisen: _speisen,
      getraenkOrders: _getraenkOrders,
      billPayed: json['billPayed'],
    );
  }

  //Funktionsweise: Diese Methode berechnet die Summe der Bestellungen und liefert diese zurück
  double sum() {
    double sum = 0;
    getraenkOrders.forEach((item) { sum += item.getraenk.preis; });
    speisen.forEach((item) { sum += item.preis; });
    return sum;
  }

}