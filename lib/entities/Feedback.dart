import 'Restaurant.dart';

//Autor: Tim Bayer
//Die Feedback Entität ist äquivalent zur Entität in der Backend Anwendung

class Feedback{
  final String id;
  String kategorie;
  String anmerkung;
  Restaurant restaurant;

  Feedback({this.id, this.kategorie, this.anmerkung, this.restaurant});
}