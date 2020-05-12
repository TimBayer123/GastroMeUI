import 'package:gastrome/entities/Standort.dart';

class PLZ{
  final String id;
  List<Standort> standorte;
  int plz;
  String stadt;

  PLZ({this.id, this.standorte, this.plz, this.stadt});

  factory PLZ.fromJson(dynamic json){
    if(json != null)
      return PLZ(
        id: json['id'],
        plz: json['plz'],
        stadt: json['stadt']);
    return null;
  }
}