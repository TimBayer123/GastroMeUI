import 'dart:typed_data';

import 'package:gastrome/entities/Rezession.dart';
import 'package:gastrome/entities/Speisekarte.dart';
import 'package:gastrome/entities/Standort.dart';

class Restaurant{
  final int id;
  String name;
  String beschreibung;
  Standort standort;
  List<Rezession> rezessionen;
  Speisekarte speisekarte;
  Uint8List bild;

  Restaurant(this.id, this.name, this.beschreibung, this.standort,
      this.rezessionen, this.speisekarte, this.bild);
}