import 'dart:typed_data';

//Autor: Tim Bayer, Tim Bayer
//Die SpeisekartenItem Entität ist äquivalent zur Entität in der Backend Anwendung

class SpeisekartenItem{
  final String id;
  String name;
  String beschreibung;
  double preis;
  Uint8List bild;
  bool vegie;
  bool vegan;
  String erlaeuterung;

  SpeisekartenItem(this.id, this.name, this.beschreibung, this.preis,
      this.bild, this.vegie, this.vegan, this.erlaeuterung);
}