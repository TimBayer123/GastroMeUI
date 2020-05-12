import 'package:gastrome/entities/Getraenk.dart';
import 'package:gastrome/entities/Restaurant.dart';
import 'package:gastrome/entities/Speise.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Speisekarte{
  final String id;
  Restaurant restaurant;
  List<Speise> speisen;
  List<dynamic> getraenke;

  Speisekarte({this.id, this.restaurant, this.speisen, this.getraenke});

  factory Speisekarte.fromJson(Map<String, dynamic> json){
    var speisenJson = json['speisen'] as List;
    List<Speise> _speisen = speisenJson.map((tagJson) => Speise.fromJson(tagJson)).toList();
    var getraenkeJson = json['getraenke'] as List;
    List<Getraenk> _getraenke = getraenkeJson.map((tagJson) => Getraenk.fromJson(tagJson)).toList();
    return Speisekarte(
      id: json['id'],
      restaurant: json['restaurant'],
      speisen: _speisen,
      getraenke: _getraenke,
    );
  }


}