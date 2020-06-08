import 'Getraenk.dart';
import 'Speise.dart';

class Rechnung{
  final String id;
  List<Speise> speisen;
  List<Getraenk> getraenke;
  DateTime timestamp;

  Rechnung({this.id, this.speisen, this.getraenke, this.timestamp});

  factory Rechnung.fromJson(Map<String, dynamic> json){
    var speisenJson = json['speisen'] as List;
    List<Speise> _speisen = speisenJson.map((tagJson) => Speise.fromJson(tagJson)).toList();
    var getraenkeJson = json['getraenke'] as List;
    List<Getraenk> _getraenke = getraenkeJson.map((tagJson) => Getraenk.fromJson(tagJson)).toList();
    return Rechnung(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      speisen: _speisen,
      getraenke: _getraenke,
    );
  }

}