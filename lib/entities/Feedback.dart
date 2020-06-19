import 'Restaurant.dart';

class Feedback{
  final String id;
  String kategorie;
  String anmerkung;
  Restaurant restaurant;

  Feedback({this.id, this.kategorie, this.anmerkung, this.restaurant});
}