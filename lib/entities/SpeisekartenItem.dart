import 'dart:typed_data';

class SpeisekartenItem{
  final int id;
  String name;
  String beschreibung;
  double preis;
  Uint8List bild;
  bool vegie;
  bool vegan;

  SpeisekartenItem(this.id, this.name, this.beschreibung, this.preis,
      this.bild, this.vegie, this.vegan);
}