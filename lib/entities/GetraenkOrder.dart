import 'Getraenk.dart';
import 'Rechnung.dart';
import 'Speise.dart';

class GetraenkOrder{
  final String id;
  Getraenk getraenk;
  bool ausgeliefert;

  GetraenkOrder({this.id, this.getraenk, this.ausgeliefert});

  factory GetraenkOrder.fromJson(Map<String, dynamic> json){
    Getraenk _getraenk = Getraenk.fromJson(json['getraenk']);
    return GetraenkOrder(
      id: json['id'],
      getraenk: _getraenk,
      ausgeliefert: json['ausgeliefert'],
    );
  }

}