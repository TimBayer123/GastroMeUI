import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:gastrome/entities/Getraenk.dart';
import 'package:gastrome/entities/Speise.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


class Allergen{
  final String id;
  List<Speise> speisen;
  List<Getraenk> getraenke;
  String name;
  String bezeichnung;
  Uint8List symbol;

  Allergen({this.id, this.speisen, this.getraenke, this.name, this.bezeichnung, this.symbol});

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
