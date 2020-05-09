import 'dart:typed_data';

import 'package:gastrome/entities/Allergen.dart';
import 'package:gastrome/entities/Speisekarte.dart';
import 'package:gastrome/entities/SpeisekartenItem.dart';

class Speise extends SpeisekartenItem {
  final int id;
  Speisekarte speisekarte;
  List<Allergen> allergene;

  Speise(this.id, this.speisekarte, this.allergene, int itemId, String name, String beschreibung, double preis, Uint8List bild, bool vegie, bool vegan)
      : super(itemId, name, beschreibung, preis, bild, vegie, vegan);

  factory Speise.fromJson(Map<String, dynamic> json){
    return Speise(json['id'],json['speisekarte'], json['allergene'], json['id'], json['name'], json['beschreibung'], json['preis'], json['bild'], json['vegie'], json['vegan']);

}