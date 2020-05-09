import 'dart:typed_data';

import 'package:gastrome/entities/Allergen.dart';
import 'package:gastrome/entities/Speise.dart';
import 'package:gastrome/entities/Speisekarte.dart';
import 'package:gastrome/entities/SpeisekartenItem.dart';

class Getraenk extends SpeisekartenItem{
    final int id;
    Speisekarte speisekarte;
    List<Allergen> allergene;

  Getraenk(this.id, this.speisekarte, this.allergene, int itemId, String name, String beschreibung, double preis, Uint8List bild, bool vegie, bool vegan) : super(itemId, name, beschreibung, preis, bild, vegie, vegan);

}